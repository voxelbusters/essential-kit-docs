# Campaign Deep Link Navigation

## Goal
Handle universal links from marketing campaigns and navigate to specific content.

## Actions Required
- `DeepLinkServicesOnUniversalLinkOpen`
- `DeepLinkServicesGetUniversalLinkResult`

## Variables Needed
- campaignId (String)

## Implementation Steps

### 1. ListenForLinks (Persistent State)
Use `DeepLinkServicesOnUniversalLinkOpen` in a persistent state.

### 2. Read Link Details
On `receivedEvent`, call `DeepLinkServicesGetUniversalLinkResult` to read:
- `rawUrl` (full URL)
- `queryKeys` / `queryValues` (parallel arrays)

### 3. Extract campaignId
Example URL: `https://game.com/promo?campaign=summer2024`
- Find key `"campaign"` in `queryKeys` and take the value from `queryValues` at the same index.

### 4. Navigate
Go to campaign-specific content or promo screen

## Use When
Marketing campaigns, email links, social media promotions
