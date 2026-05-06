# Sleuth Star — App Store Submission Walkthrough

Step-by-step guide for submitting Sleuth Star v1.0.0 to the App Store. Estimated time end-to-end: 2-3 hours, mostly waiting on Apple's review queue (24-72 hours).

## Prerequisites

- Apple Developer account ($99/yr) — Team ID `Q73RN5N9Y2` (already in pbxproj)
- Xcode (current stable)
- App Store Connect access at https://appstoreconnect.apple.com
- GitHub CLI (`gh`) signed in to `mkonopinski810` (for hosting privacy/support pages)

---

## Step 1 — Create the App Store Connect record

1. Go to https://appstoreconnect.apple.com → **My Apps** → **+** → **New App**
2. Fill in:
   - **Platform:** iOS
   - **Name:** Sleuth Star
   - **Primary Language:** English (U.S.)
   - **Bundle ID:** `com.sleuthstar.app` (must already be registered in your dev portal — see step 2 if not)
   - **SKU:** `sleuthstar-ios-1`
   - **User Access:** Full Access
3. Hit Create.

You now have a draft App Store record. Don't fill in the metadata yet — we'll do that after the build is uploaded.

---

## Step 2 — Register the bundle ID (if not done)

If creating the record above complained about an unknown bundle ID:
1. Go to https://developer.apple.com/account → **Certificates, IDs & Profiles** → **Identifiers**
2. **+** → **App IDs** → **App** → Continue
3. Description: `Sleuth Star`. Bundle ID: Explicit, `com.sleuthstar.app`. Capabilities: leave defaults.
4. Continue → Register.

Then go back to step 1 and retry creating the App Store Connect record.

---

## Step 3 — Host the Privacy Policy & Support pages

Apple requires a Privacy Policy URL and a Support URL. The project already has a styled `privacy-policy/` folder with `index.html` (privacy policy) and `support.html` (support page) — same pattern used for LoveLlama / Sybles / ScamLlama.

Push the project to your GitHub (`mkonopinski810` account) as a public repo named `SleuthStar`, then enable GitHub Pages:

```sh
cd /Users/mattk/Desktop/SleuthStar
git init
git add .
git commit -m "Sleuth Star v1.0.0"
gh repo create mkonopinski810/SleuthStar --public --source . --push
```

Then enable Pages:
1. Open https://github.com/mkonopinski810/SleuthStar/settings/pages
2. Source: **Deploy from a branch**
3. Branch: `main` / `(root)` → Save
4. Wait ~1 minute. Visit `https://mkonopinski810.github.io/SleuthStar/privacy-policy/` to verify it loads.

Your two URLs for App Store Connect:
- **Privacy Policy URL:** `https://mkonopinski810.github.io/SleuthStar/privacy-policy/`
- **Support URL:** `https://mkonopinski810.github.io/SleuthStar/privacy-policy/support.html`

(If you'd rather not make the source public, create a separate repo `mkonopinski810/sleuthstar-pages` containing only the `privacy-policy/` folder, and reference that URL instead.)

---

## Step 4 — Verify the build

```sh
cd /Users/mattk/Desktop/SleuthStar
xcodebuild -project SleuthStar.xcodeproj -scheme SleuthStar \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -configuration Release build CODE_SIGNING_ALLOWED=NO
```

Expect `** BUILD SUCCEEDED **`. One benign `withAnimation` warning is OK.

---

## Step 5 — Archive in Xcode

CLI archiving requires interactive provisioning auth, so the easiest path is Xcode:

1. Open the project: `open /Users/mattk/Desktop/SleuthStar/SleuthStar.xcodeproj`
2. Select the **SleuthStar** scheme → destination **"Any iOS Device (arm64)"** in the toolbar
3. Menu: **Product** → **Archive**
4. First time: Xcode will prompt to download a provisioning profile. Sign in with your Apple ID linked to team `Q73RN5N9Y2`. Accept any cert/profile prompts.
5. The archive takes 1-3 minutes. The Organizer window opens automatically when it finishes.

If archiving complains about missing icons or Privacy manifest issues, those are caught at this step — fix and re-archive.

---

## Step 6 — Validate the archive

In the Organizer window:

1. Select the new archive (top of list).
2. Click **Validate App** in the right sidebar.
3. Distribution method: **App Store Connect** → Next.
4. Distribution options: defaults are fine (Upload symbols, Manage signing) → Next.
5. Re-sign: **Automatically manage signing** → Next.
6. Validation runs (~30 seconds). Common issues at this step:
   - **Missing 1024×1024 marketing icon** — Already shipped at `Assets.xcassets/AppIcon.appiconset/AppIcon.png` — should pass.
   - **Privacy manifest issues** — Already shipped at `SleuthStar/PrivacyInfo.xcprivacy` — should pass.
   - **Bitcode required** — No longer required as of Xcode 14, ignore.

If everything's green, click Done. You haven't uploaded yet.

---

## Step 7 — Upload to App Store Connect

Same Organizer window:

1. Click **Distribute App** in the right sidebar.
2. **App Store Connect** → Next → **Upload** → Next.
3. Same options as validation → Next → Upload.
4. The upload takes 1-3 minutes. When it finishes, the build appears in App Store Connect after about 5-15 minutes of Apple-side processing (look for an email).

---

## Step 8 — Fill in the App Store Connect listing

Open https://appstoreconnect.apple.com → My Apps → Sleuth Star → **iOS App → 1.0** (left sidebar).

Use copy from `AppStoreMetadata.md`:

- **App Information:**
  - **Subtitle:** `Detective Mystery & Evidence`
  - **Privacy Policy URL:** your GitHub Pages URL from step 3
  - **Category — Primary:** Games → Adventure
  - **Category — Secondary:** Games → Puzzle
  - **Content Rights:** "No, it does not contain, show, or access third-party content"
  - **Age Rating:** click Edit → set Mild Cartoon or Fantasy Violence to "Infrequent/Mild" and Mild Horror/Fear themes to "Infrequent/Mild" → 12+

- **Pricing and Availability:**
  - **Price:** Free (or set a tier)
  - **Availability:** All countries

- **iOS App → 1.0:**
  - **Promotional Text:** copy from metadata file
  - **Description:** copy from metadata file (~2400 chars)
  - **Keywords:** copy from metadata file
  - **Support URL:** GitHub repo URL or your site
  - **Marketing URL:** optional, leave blank
  - **What's New in This Version:** copy from metadata file
  - **App Review Information:** name/phone/email/demo account info — see metadata file
  - **Version Release:** "Manually release this version" recommended for first release (so you control the launch moment)

- **App Privacy:**
  - "Does your app collect any data?" → **No**
  - This auto-populates the listing's privacy section.

- **Screenshots (iOS App → 1.0 → Previews and Screenshots):**
  - Drag in 6 PNGs from `AppStoreScreenshots/` (or your re-shot 6.9" set)
  - **Required size for primary set:** iPhone 6.9" Display (1290 × 2796 or 1320 × 2868)
  - You can re-use the same screenshots for the iPhone 6.5" slot if you don't have separate captures.

- **Build:**
  - In the left sidebar of the version page, scroll to **Build** → **+ Select a Build**
  - Pick the build that uploaded in step 7.
  - Answer the export-compliance question: "Does your app use encryption?" → **No** (we don't use any custom encryption beyond standard HTTPS, and we make no network calls anyway).

---

## Step 9 — Submit for Review

Top-right of the version page:
1. **Add for Review** (or "Submit for Review" depending on your view).
2. Confirm. The status changes to **Waiting for Review**.

Apple's typical review time is 24-72 hours. You'll get an email when status changes.

---

## Step 10 — When approved

If you chose "Manually release," go to App Store Connect → Sleuth Star → **Release This Version** when you're ready to make it live.

If you chose "Automatically release after approval," it goes live as soon as Apple approves.

---

## Common rejection reasons (and how to dodge them)

- **Crash on launch on a clean device.** Test on a TestFlight build before submitting. You can self-test via TestFlight after the build uploads.
- **Privacy manifest missing required-reason API.** Already declared in `PrivacyInfo.xcprivacy` — should be fine.
- **Privacy Policy URL returns 404.** Make sure the URL in step 3 actually loads.
- **Screenshots don't match described features.** Don't show features that aren't in the build.
- **Misuse of "Best", "#1", or other prohibited claims in marketing copy.** The description doesn't use these — should be safe.

---

## Post-launch checklist

- Monitor **App Store Connect → Sales and Trends** for daily downloads
- Reply to **Ratings and Reviews** within 7 days for first-week reviewers
- Bump `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` for each subsequent build (Apple rejects duplicate build numbers within the same version)

Good luck.
