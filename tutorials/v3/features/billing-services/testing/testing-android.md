---
description: Testing in-app purchases on Android devices using Google Play test tools
---

# Android Sandbox Testing

Essential Kit supports Google Play’s test flows out of the box. Use this streamlined checklist to cover license testing and Play Store tracks.

## Quick Troubleshooting Reference
| Problem | Likely Cause | Quick Fix |
|---------|-------------|-----------|
| “Item unavailable” dialog | Package name or signing key doesn’t match Play Console entry | Install a build signed and named exactly like the Play Console listing. |
| No test payment methods shown | Google account not listed as a license tester | Add the Gmail address under **Play Console → Settings → Monetization → License Testing**, then reinstall. |
| Purchases charge real money | Tester isn’t a license tester | Add the account to the license tester list or warn QA when using test tracks. |
| `SERVICE_UNAVAILABLE` when sideloaded | App never uploaded and account not a license tester | Upload at least one build to a track and/or add the tester as a license tester. |
| Transactions stay pending or fail verification | Missing/mismatched Google Play public key | Paste the Base64 public key into Essential Kit Settings → Billing Services → Android. |

## 1. Configure License Testers (Recommended)
1. Open [Play Console](https://play.google.com/console/) → select your app.
2. Navigate to **Settings → Monetization → License Testing**.
3. Add testers’ Gmail addresses (group by role if helpful) and save.
4. Wait a few minutes for Google Play to recognise new testers.

**Why license testers?** You can sideload debug builds, bypass the “billing library requires Play upload” restriction, and use the special “Test card” payment methods that never charge real money.

> 💡 Keep version codes and application IDs identical to the Play listing so sideloaded builds behave like the uploaded version.

## 2. Make Test Purchases
1. Sign into the Play Store on the device with the tester’s Gmail account.
2. Install from Play or sideload your Essential Kit build (package name + signing certificate must match the listing).
3. Trigger a purchase; the dialog should display “Test card” options.
4. Complete approvals/declines to exercise both success and error paths. Essential Kit surfaces results via `BillingServices.OnTransactionStateChange`.

## 3. Optional: Play Store Test Tracks
Use internal/closed/open tracks when you need broader distribution:
1. Upload and publish your signed AAB/APK to the chosen track (allow a few hours for availability).
2. Share the opt-in URL; testers tap **Become a tester** to install from Google Play.
3. Remember: purchases in test tracks hit real payment methods unless that account is also a license tester. Automatic refunds can take ~14 days.

## 4. Before Release
- Confirm the Google Play public key matches in Essential Kit settings as invalid keys leave transactions pending making verification failed.
- Run at least one production-track smoke test with a real payment before launch.
