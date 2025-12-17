# OAuth Authentication Callback

## Goal
Handle custom scheme URLs for OAuth authentication flow.

## Actions Required
- `DeepLinkServicesOnCustomSchemeUrlOpen`
- `DeepLinkServicesGetCustomSchemeResult`

## Variables Needed
- authToken (String)

## Implementation Steps

### 1. ListenForScheme (Persistent State)
Use `DeepLinkServicesOnCustomSchemeUrlOpen` in a persistent state.

### 2. Read Link Details
On `receivedEvent`, call `DeepLinkServicesGetCustomSchemeResult` to read:
- `rawUrl`
- `queryKeys` / `queryValues`

### 3. Extract token
Example: `myapp://oauth-callback?token=xyz`
- Find key `"token"` in `queryKeys` and take the value from `queryValues` at the same index.

### 4. Complete Authentication
Use token to finalize login, store session

## Use When
Third-party login (Facebook, Google, custom OAuth)
