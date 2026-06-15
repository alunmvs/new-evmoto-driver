# Changelog — Evmoto Driver

> A plain-language summary of app updates for Evmoto drivers. Written for non-technical readers — no developer jargon.

---

## How to Read This Document

Each new version is added **at the top** (the latest version is always first). Changes are grouped into:

| Category | What it means |
|----------|---------------|
| **New Features** | New capabilities or screens you can use right away |
| **Fixes** | Problems that have been resolved for a more stable app |
| **Look & Feel** | Visual, text, or flow changes that make the app easier to use |

**Tip:** After updating, check your version number under **Account → About** (or in the Play Store / App Store) to confirm you are on the latest release.

---

## Version 1.9.5

**Release date:** 12 June 2026  
**Build:** 52

### Summary

This release adds clearer **waiting-fee** and **advance booking** information, and fixes several issues related to logout, maps, and incoming order notifications.

---

### New Features

- **Free waiting time info** — On the payment confirmation and fee detail screens, you can see how many minutes of **free waiting time** you have before waiting fees start to apply.
- **Reject order when closing the popup** — If you close an incoming order popup without accepting it, the order is automatically **rejected** in the system so it does not stay pending.
- **Privacy Policy from website** — The Privacy Policy page now opens directly from the official website, so the content is always up to date.

---

### Fixes

- **Cleaner logout** — After signing out, your login session is fully reset so leftover data does not interfere with your next login.
- **Orders when the app first opens** — Incoming order notifications that arrive before the home screen is ready no longer cause glitches or errors.
- **Map zoom** — Fixed an issue where the map would suddenly zoom out too far.
- **Network connection** — The app now better follows your device’s proxy settings (helpful if you use a VPN or office network).

---

### Look & Feel

- **Advance booking dialog** — Trip distance (*mileage*) and estimated travel time are shown more clearly and consistently on the home screen and My Orders page; text no longer gets cut off on smaller screens.
- **Earnings tables in My Activity** — Added a **horizontal scroll bar** so earnings tables are easier to swipe left and right.
- **Guarantee income tables** — Date selection is simplified (single date picker) and the table layout is cleaner.
- **Payment screens** — Updated payment confirmation and pending fee detail screens so fee information is easier to read.
- **Notification icon** — Updated the notification icon background so it is clearer in the status bar.

---

## Template for the Next Version

> Copy the block below each time a new version is released, then fill in the user-facing changes.

```markdown
## Version X.Y.Z

**Release date:** DD Month YYYY  
**Build:** N

### Summary

[One or two sentences: what is this release mainly about?]

---

### New Features

- **[Short title]** — [Explain the benefit for drivers, without technical terms.]

---

### Fixes

- **[Short title]** — [What problem no longer happens.]

---

### Look & Feel

- **[Short title]** — [What looks or feels different when using the app.]
```

### Guidelines for writing new entries

1. Write from the **driver’s** point of view, not the developer’s.
2. Avoid terms like *API*, *controller*, *refactor*, *endpoint*.
3. Explain the **benefit**: “You can now …”, “It’s easier to …”, “You no longer need to …”.
4. One bullet = one change that can be described in a single sentence.
5. Internal-only changes (automated tests, team documentation) do **not** need to be listed.

---

*This document starts from version 1.9.5. Future version notes are added above the “Template for the Next Version” section.*
