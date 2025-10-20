# BillingServices Overview

## High-Level Architecture

BillingServices in Essential Kit follows a three-stage purchase flow that integrates seamlessly with both iOS App Store and Google Play Store:

```
[Unity Game] ↔ [Essential Kit] ↔ [Native Store]
     ↓              ↓              ↓
[UI/GameLogic] → [Cross-Platform] → [Platform-Specific]
                    [API Layer]      [iOS/Android]
```

The architecture abstracts platform differences, providing a unified interface for Unity cross-platform development.

## Concepts Covered in This Tutorial

This tutorial series will cover these essential BillingServices concepts:

1. **Store Initialization** - Loading product catalogs from native stores
2. **Product Management** - Working with consumables, non-consumables, and subscriptions  
3. **Purchase Processing** - Initiating and handling purchase transactions
4. **Transaction Handling** - Managing purchase states and completion
5. **Receipt Verification** - Validating purchases for security
6. **Purchase Restoration** - Restoring previous non-consumable purchases

## Cross-Platform Considerations

Essential Kit's BillingServices provide consistent behavior across platforms while respecting platform-specific requirements:

- **iOS**: Integrates with StoreKit framework and App Store Connect
- **Android**: Works with Google Play Billing Library and Google Play Console  
- **Unity Editor**: Includes simulator for testing without devices

The Unity mobile games SDK handles platform differences automatically, so you can focus on creating engaging monetization features for your Unity iOS and Unity Android applications.

## Key Benefits for Unity Mobile Game Developers

- **Unified API**: Single codebase works across iOS and Android
- **Automatic Setup**: Essential Kit handles complex native configuration
- **Receipt Security**: Built-in validation options prevent fraud
- **Developer Friendly**: Clear events and error handling
- **Production Ready**: Used by thousands of Unity plugin integrations

📌 **Video Note**: Use visual overview diagram showing the flow from Unity game → Essential Kit → Native stores → Purchase completion.