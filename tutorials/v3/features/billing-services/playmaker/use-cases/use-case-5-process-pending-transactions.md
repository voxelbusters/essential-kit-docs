# Process Pending Transactions (AutoFinishTransactions OFF)

## Goal
Handle unfinished transactions on app launch (or after a network retry) when you do server-side receipt verification.

## When to Use
- **AutoFinishTransactions is OFF** in Essential Kit settings.
- You verify receipts on your server and only finish transactions after verification.
- The app was closed/backgrounded before you finished the transaction.

## Actions Required
| Action | Purpose |
|--------|---------|
| BillingServicesInitializeStore | Ensure billing is initialized |
| BillingServicesGetTransactions | Cache pending transactions + get `transactionCount` |
| BillingServicesGetTransactionInfo | Read `transactionId` + `receipt` for each pending item |
| BillingServicesSetReceiptVerificationState | Set verification result from your server (`Success` / `Failed`) |
| BillingServicesFinishTransactions | Finish verified transactions so they leave the queue |

## Variables Needed
- transactionCount (Int)
- transactionIndex (Int)
- transactionId (String)
- productId (String)
- receipt (String)
- receiptVerificationState (Enum: BillingReceiptVerificationState)

## Implementation Steps

### 1. InitializeStore
Run `BillingServicesInitializeStore` and wait for `successEvent`.

### 2. Get pending queue
Run `BillingServicesGetTransactions` → `transactionCount`.

### 3. Loop each pending transaction
Loop `transactionIndex = 0..transactionCount-1`:
1. `BillingServicesGetTransactionInfo(transactionIndex)` → read `transactionId`, `productId`, `receipt`, `receiptVerificationState`.
2. Send `receipt` (and `productId`/`transactionId`) to your backend for verification.
3. Based on server response:
   - **Verified**:
     - `BillingServicesSetReceiptVerificationState(transactionId, Success)`
     - Grant content (idempotent: don’t double-grant)
     - `BillingServicesFinishTransactions` with `transactionIds = [transactionId]`
   - **Rejected / invalid**:
     - `BillingServicesSetReceiptVerificationState(transactionId, Failed)`
     - Don’t grant content
     - Finish or keep in queue based on your policy (retry later vs clear immediately)

## Notes
- If `receiptVerificationState` is already `Success`, you can skip verification and just ensure content is granted, then finish.
- This use-case is the “recovery” flow for manual verification setups.

