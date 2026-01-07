# Utilities Use Cases

Quick-start guides showing minimal implementations of common system utility tasks using PlayMaker custom actions.

## Available Use Cases

### 1. [Prompt for App Store Review](use-case-1-app-store-review.md)

- **What it does:** Open the app store page to encourage user ratings/reviews
- **Complexity:** Basic
- **Actions:** 1 (UtilitiesOpenAppStorePageDefault)
- **Best for:** In-app rating prompts, post-level completion rewards

---

### 2. [Direct Users to App Settings](use-case-2-permission-settings.md)

- **What it does:** Guide users to enable permissions in system settings
- **Complexity:** Basic
- **Actions:** 1 (UtilitiesOpenApplicationSettings)
- **Best for:** Permission denied flows, settings tutorials

---

### 3. [Cross-Promote Another App](use-case-3-cross-promotion.md)

- **What it does:** Open the app store page for a different app
- **Complexity:** Basic
- **Actions:** 1 (UtilitiesOpenAppStorePageById)
- **Best for:** Publisher portfolios, related app promotions

---

### 4. [Request Age Compliance Info](use-case-4-age-compliance.md)

- **What it does:** Requests user age range info and declaration method for compliance flows
- **Complexity:** Intermediate
- **Actions:** 1 (UtilitiesRequestInfoForAgeCompliance) + optional (UtilitiesGetInfoForAgeComplianceSuccessResult, UtilitiesGetInfoForAgeComplianceError)
- **Best for:** Age gating, regional compliance requirements

---

## Choosing the Right Use Case

**Start Here:**
- Want ratings/reviews for THIS app? → **Use Case 1**
- Users need to grant permissions? → **Use Case 2**
- Promoting a DIFFERENT app? → **Use Case 3**
- Need age compliance info? → **Use Case 4**

## Quick Action Reference

| Action | Purpose | Used In |
|--------|---------|---------|
| UtilitiesOpenAppStorePageDefault | Open store for this app | Use Case 1 |
| UtilitiesOpenApplicationSettings | Open app settings | Use Case 2 |
| UtilitiesOpenAppStorePageById | Open store with iOS + Android IDs | Use Case 3 |
| UtilitiesRequestInfoForAgeCompliance | Request age compliance info | Use Case 4 |
| UtilitiesGetInfoForAgeComplianceSuccessResult | Read cached age compliance result | Use Case 4 |
| UtilitiesGetInfoForAgeComplianceError | Read cached age compliance error | Use Case 4 |

## Related Documentation

- **[README.md](../README.md)** - Actions + quick flow
