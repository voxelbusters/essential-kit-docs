# Read Query Param by Key

## Goal
Extract a specific query parameter value from the incoming link using `queryKeys` + `queryValues`.

## Actions Used
- `DeepLinkServicesOnUniversalLinkOpen` **or** `DeepLinkServicesOnCustomSchemeUrlOpen` (listener, persistent)
- `DeepLinkServicesGetUniversalLinkResult` **or** `DeepLinkServicesGetCustomSchemeResult` (extractor)

## Variables Needed
- queryKeys (Array: String)
- queryValues (Array: String)
- value (String) (example: campaignId / token)

## Implementation Steps

1. On listener `receivedEvent`, call the matching `Get*Result` action to populate `queryKeys` and `queryValues`.
2. Find the parameter:
   - Use PlayMaker Array actions to loop `i = 0..queryKeys.Length-1`
   - If `queryKeys[i] == "campaign"` then set `value = queryValues[i]`

## Example URLs
- Universal: `https://game.com/promo?campaign=summer2024`
- Custom scheme: `myapp://oauth-callback?token=xyz`

## Notes
`queryKeys` and `queryValues` are parallel arrays; use the same index for both.

