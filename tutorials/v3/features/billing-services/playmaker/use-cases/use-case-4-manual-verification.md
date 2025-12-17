# Purchase with Manual Verification

## Goal
Purchase a product with manual receipt verification for fraud prevention before granting content.

## Actions Required
| Action | Purpose |
|--------|---------|
| BillingServicesInitializeStore | Initialize billing system |
| BillingServicesBuyProduct | Initiate purchase with user tag |
| BillingServicesOnTransactionStateChange | Monitor purchase state |
| BillingServicesGetTransactionInfo | Extract transaction details |
| BillingServicesSetReceiptVerificationState | Mark receipt as verified |
| BillingServicesFinishTransactions | Finish the transaction(s) after verification |
| BillingServicesGetBuyProductError | Read cached error after failure (optional) |

## Variables Needed
- productId (String) = "coins_500"
- userId (String) - For fraud tracking
- transactionId (String)
- receipt (String)
- receiptVerificationState (Enum: BillingReceiptVerificationState)

## Implementation Steps

### 1. State: Initialize and Purchase
Same as the simple purchase flow (InitializeStore → BuyProduct), but you must keep transactions pending until your server verifies the receipt.

**Important:** Register `BillingServicesOnTransactionStateChange` in a persistent state **before** calling `BillingServicesBuyProduct`. Purchase lifecycle events come from the listener (not from BuyProduct).

**BuyProduct with tag:**
- productId: productId
- quantity: 1
- **tag: userId** (links purchase to user account)

### 2. State: ListenForPurchase
**Action:** BillingServicesOnTransactionStateChange
- Monitor for Purchased state
- When Purchased → GetTransactionDetails

### 3. State: GetTransactionDetails
**Action:** BillingServicesGetTransactionInfo
- **Inputs:**
  - transactionIndex: 0 (most recent)
- **Outputs:**
  - receipt → receipt
  - receiptVerificationState → receiptVerificationState
  - transactionId → transactionId

**Transition:** Go to VerifyWithServer

### 4. State: VerifyWithServer
Send `receipt` to your backend server:
- Endpoint: `/verify-receipt`
- Server validates with Apple/Google
- Returns: success or fraud

**On Success:** Go to MarkVerified
**On Failure:** Go to HandleFraud

### 5. State: MarkVerified
**Action:** BillingServicesSetReceiptVerificationState
- **Inputs:**
  - transactionId: transactionId
  - verificationState: Success
- **Transition:** Go to GrantContent

### 6. State: GrantContent
Add coins/currency to user account
- Go to FinishTransaction

### 7. State: FinishTransaction
**Action:** BillingServicesFinishTransactions
- **Inputs:** set `transactionIds` array to include `transactionId` (or leave empty to finish all cached/pending transactions)

## Verification Flow
```
Purchase → Purchased State
    └─ GetTransactionInfo
        └─ Send Receipt to Server
            ├─ Valid → SetVerificationState(Success)
            │          └─ Grant Content
            │              └─ FinishTransactions
            └─ Invalid → SetVerificationState(Failed)
                         └─ Don't Grant Content
```

## Common Issues

- **AutoFinishTransactions Enabled**: Disable in Essential Kit settings for manual verification
- **Transaction Finishes Too Early**: Ensure AutoFinishTransactions is off before testing
- **Receipt Validation Fails**: Check server-side Apple/Google API integration
- **Duplicate Purchases**: User tag helps identify and prevent duplicate grants

## Security Best Practices

1. **Always Verify Server-Side**: Never trust client-side verification
2. **Use User Tags**: Link purchases to accounts to prevent fraud
3. **Log Verification**: Track all receipt validations for audit
4. **Handle Failures**: Decide policy for failed verifications (refund vs block)

## When to Use Manual Verification

- **Consumables** (coins, gems): Prevent duplicate delivery
- **High-Value Items**: Extra security for expensive purchases
- **Multi-User Accounts**: Tag ensures correct user receives content
- **Fraud Prevention**: Detect and block stolen cards or chargebacks
