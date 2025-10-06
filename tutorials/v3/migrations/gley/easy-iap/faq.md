# FAQ – Migrating From Gley Easy IAP

### Does Essential Kit still need the Unity IAP package?
No. Essential Kit ships with its own native billing implementations. Once you finish testing you can remove both Unity IAP and the Gley Easy IAP asset from your project. The benefit is faster fixes and updates under our control, plus no extra analytics dependencies being pulled into your build.

### Can I keep both systems installed while I migrate?
Yes. You can leave Gley in place while you rebuild your flows with Essential Kit. Just avoid mixing API calls in the same build. When you are satisfied with testing, delete Gley and Unity IAP.

### How do I recreate Gley product rewards?
Create payouts in Essential Kit Settings using *Category + Variant + Quantity*. For example choose `Currency` for your coin reward, set the variant to `coins_primary`, and keep the same store identifiers you had in Gley. See “Configure Products” in [migration-guide.md](migration-guide.md).

### Will existing purchases be recognised after the switch?
Yes. Essential Kit talks to the same App Store / Google Play back ends. Run `BillingServices.RestorePurchases(forceRefresh: false)` during startup and switch to `true` when the user taps the restore button to refresh entitlements, particularly for non-consumables and subscriptions.

### Where can I find code for advanced scenarios like server-side receipt checks?
The canonical samples live in `tutorials/v3/features/billing-services/usage.md` (see the *Server-Side Receipt Verification* section). The migration guide links back to those snippets so you stay aligned with the main documentation.

### Who can I talk to if I get stuck?
Join the Essential Kit community on [Discord](https://discord.gg/Rw5SAec4Md). You can also review the product overview at [Essential Kit](https://www.voxelbusters.com/products/essential-kit) and [Email us](mailto:support@voxelbusters.com) for direct help.

### Is there a checklist I can follow?
Yes. Work through the checklist that closes [migration-guide.md](migration-guide.md). It covers settings, code updates, testing, and cleanup.
