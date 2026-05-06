import Foundation

struct ForceUpdateChecker {
    /// App Store numeric ID — fill in once Apple assigns it (visible in App Store Connect after first build is approved).
    static let appStoreID = "0000000000"

    /// Public Gist URL. The app fetches this on launch; bump `minimum_version` in the gist to force users onto a newer build.
    /// Edit with: `gh gist edit 03852fac887d8355a056ae968cf30709`
    static let versionURL = URL(string: "https://gist.githubusercontent.com/mkonopinski810/03852fac887d8355a056ae968cf30709/raw/version.json")!

    struct VersionInfo: Decodable {
        let minimum_version: String
        let message: String
    }

    /// Returns (needsUpdate, message) — checks remote version.json against the running app version.
    static func check() async -> (needsUpdate: Bool, message: String) {
        do {
            let (data, _) = try await URLSession.shared.data(from: versionURL)
            let info = try JSONDecoder().decode(VersionInfo.self, from: data)

            let current = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"

            if compareVersions(current, isOlderThan: info.minimum_version) {
                return (true, info.message)
            }
        } catch {
            // If the check fails (no network, gist unavailable, etc.), don't block the user.
        }
        return (false, "")
    }

    static var appStoreURL: URL {
        URL(string: "https://apps.apple.com/app/id\(appStoreID)")!
    }

    /// Returns true if version `a` is strictly older than version `b`.
    private static func compareVersions(_ a: String, isOlderThan b: String) -> Bool {
        let aParts = a.split(separator: ".").compactMap { Int($0) }
        let bParts = b.split(separator: ".").compactMap { Int($0) }
        let count = max(aParts.count, bParts.count)
        for i in 0..<count {
            let aVal = i < aParts.count ? aParts[i] : 0
            let bVal = i < bParts.count ? bParts[i] : 0
            if aVal < bVal { return true }
            if aVal > bVal { return false }
        }
        return false
    }
}
