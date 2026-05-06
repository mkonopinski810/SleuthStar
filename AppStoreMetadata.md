# Sleuth Star — App Store Connect Metadata

Copy / paste-ready text for the App Store Connect listing.

---

## Basics

- **App name (30 chars):** `Sleuth Star`
- **Subtitle (30 chars):** `Detective Mystery & Evidence`
- **Bundle ID:** `com.sleuthstar.app`
- **SKU (any unique ID for ASC):** `sleuthstar-ios-1`
- **Primary category:** Games → Adventure
- **Secondary category (optional):** Games → Puzzle
- **Pricing:** Free (recommended for launch). Or set tier as desired.
- **Availability:** All countries / all regions.

---

## Promotional Text (170 chars — appears above description, can be updated without resubmitting)

```
Step into a noir detective's office. Search crime scenes, analyze evidence with your tools, and present the truth to the bench. Every shadow has a seam.
```

---

## Description (4000 char max)

```
SLEUTH STAR is a noir detective game where YOU work the case. Every shadow has a seam.

Step into a 1940s detective's office. Pick a case from the file board. Travel to the scene of the crime. Search for fingerprints, footprints, hidden notes, and physical traces. Use your equipment — a brass magnifier, a UV flashlight, a field evidence kit, a forensic specialist — to analyze each piece. Decide what to present to the bench. Then watch the verdict play out as the judge walks through your evidence and reveals what really happened that night.

SIX HAND-CRAFTED CASES across four difficulty tiers:

ROOKIE TIER
• THE ROOFTOP ROBBERY — A penthouse safe is cracked at 2:14 AM. The doorman swears no one came in. The shadow on the security camera disagrees.
• THE CLOSING SHIFT — Sal's All-Night Diner is robbed four minutes after the suspect ordered pie. Whoever did this stayed for a snack.
• THE GREENHOUSE THEFT — A rare ghost orchid is cut at dawn. The estate dog never barked.

DETECTIVE TIER
• THE MIDNIGHT HEIST — A museum gala. A missing emerald. Forty masked guests, three hidden corridors, and a curator who isn't telling everything.

VETERAN TIER
• THE DIAMOND VANISH — A jeweler's vault. No signs of entry. The diamonds are gone, and the security tapes show only static.

MASTER TIER
• THE MASQUERADE MURDER — A senator. A masked ball. A single shot in the conservatory. Everyone has a mask. Only one has a motive.

EQUIPMENT MATTERS. Every clue can be analyzed by four different tools. The magnifier reveals surface details. The UV flashlight catches what the eye misses. The lab kit dates the evidence. The forensic verdict tells you whether to submit it. Better tools reveal more.

CAREER LADDER. Climb from Rookie to Star Sleuth across eight ranks. Each promotion is gated by cases solved AND lifetime fingerprints earned. Every conviction matters.

SHOP. Spend earned fingerprints on better gear, sharper wardrobe, and hired assistants. Detective Badge boosts your reward. The Three-Piece Suit cuts your fines. The Informant tints incriminating evidence in gold so you can spot it on the scene. The Rookie auto-collects clues. The Driver skips your cutscenes.

FEATURES
• 6 fully-voiced detective cases across 4 difficulty tiers
• Cinematic noir cutscenes for every case opening
• Multi-phase verdict reveal: the judge walks each exhibit, then narrates what really happened
• 17 unlockable items across Equipment, Wardrobe, and Assistants — every one has gameplay impact
• 8-rank career ladder with progression badges
• No ads. No microtransactions. No tracking. No accounts.
• Plays fully offline.
• Optimized for iPhone and iPad.

Step into the shoes. Light the lamp. The case files are waiting on your desk.
```

---

## Keywords (100 chars total, comma-separated)

```
detective,mystery,crime,noir,evidence,investigation,sleuth,case,puzzle,solve,whodunit,offline,clue
```

---

## What's New (4000 char max — for v1.1 release)

```
Time Attack — race the leaderboard.

Every case now tracks how long it takes you to crack it. Solve the case and your time goes straight to the Game Center leaderboard for that case. Compare against friends or the world.

NEW IN 1.1
• Game Center leaderboards — one per case, six in total
• Run timer on every case, visible while you investigate
• "Time Attack" button on the office desk to view leaderboards
• Wardrobe tab now shows your detective wearing the gear you own
• Bug fixes and polish

Thanks for playing.
```

### Previous versions

```
v1.0 — Welcome to Sleuth Star, version 1.0.

Every shadow has a seam. Open the Office, pick your case, and start solving.

LAUNCH FEATURES
• 6 hand-crafted detective cases across 4 difficulty tiers
• Procedurally-rendered noir cutscenes for every case opening
• 4 analysis tools, 17 shop items, 8-rank career ladder
• Multi-phase verdict reveal — watch the judge react to each piece you submit
• Plays fully offline. No ads, no tracking, no accounts.
```

---

## App Privacy (in App Store Connect → App Privacy section)

When asked **"Does your app collect any data?"** → **No**.

The privacy manifest (PrivacyInfo.xcprivacy) declares:
- NSPrivacyTracking: false
- NSPrivacyTrackingDomains: empty
- NSPrivacyCollectedDataTypes: empty
- Required-reason API: UserDefaults (CA92.1 — app preferences and game progress)

The Privacy Policy itself is hosted at `privacy-policy/index.html` in the project repo. After pushing to GitHub Pages (see SUBMISSION.md step 3), it lives at `https://mkonopinski810.github.io/SleuthStar/privacy-policy/`. Same pattern as LoveLlama / Sybles / ScamLlama.

---

## Age Rating

Recommended: **12+**
- Infrequent / Mild Cartoon or Fantasy Violence: **Yes** (a senator is shot in the masquerade case; no visible blood/gore, all off-screen)
- Infrequent / Mild Mature/Suggestive Themes: **Yes** (mentions of theft, murder, robbery in narrative form; no profanity, no sexual content)
- All other categories: **No**

---

## Support URL & Marketing URL

- **Support URL (required):** `https://mkonopinski810.github.io/SleuthStar/privacy-policy/support.html` (already prepared in `privacy-policy/support.html`, matches the pattern from LoveLlama / Sybles / ScamLlama)
- **Marketing URL (optional):** Skip for launch.
- **Privacy Policy URL (required):** `https://mkonopinski810.github.io/SleuthStar/privacy-policy/` (already prepared in `privacy-policy/index.html`)

---

## App Review Information

- **First name / Last name:** Mathew Konopinski
- **Phone number:** (your number)
- **Email:** (your email)
- **Demo account:** None required — game has no login or accounts.
- **Notes for the reviewer:**

```
Sleuth Star is a single-player offline detective game with no accounts, no network calls, and no in-app purchases. All gameplay is available from launch — there is no paywall or unlock fee. To test the full submission flow, simply tap "Open the Office" on the splash screen, then tap any case card.
```

---

## Build / Version

- **Marketing Version:** 1.0.0
- **Build (CFBundleVersion):** 1 (the pbxproj has CURRENT_PROJECT_VERSION = 1; bump on every TestFlight upload)
- **Minimum iOS:** 17.0
- **Targeted Device Family:** iPhone + iPad
- **Supports:** Portrait on iPhone; all orientations on iPad

---

## Screenshots Required (App Store Connect)

You must provide at least one set; provide 6 of these for best presentation:

- **iPhone 6.9" (iPhone 16 Pro Max / 17 Pro Max):** 1320 × 2868 (or 1290 × 2796 acceptable)
- **iPhone 6.5" (iPhone 11 Pro Max / etc.):** 1242 × 2688 — only required if no 6.9" set; ASC scales 6.9" down
- **iPad Pro 13"** (optional but recommended): 2064 × 2752

Screenshots are in `AppStoreScreenshots/` in this repo (generated from the iOS Simulator at iPhone 17 Pro size; reshoot at 17 Pro Max for best App Store fidelity).

---

## Pricing & Availability

- **Price tier:** Free at launch. Easy to convert to paid later.
- **Available territories:** All. Game has no localized content but English text is universal-friendly.
- **Pre-order:** Skip.
- **Game Center:** Not enabled (no leaderboards or achievements yet — could add post-launch).
