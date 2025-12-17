# Route by Host/Path

## Goal
Route to a screen/scene based on the incoming deep link `host` + `path` (works for both universal links and custom schemes).

## Actions Used
- `DeepLinkServicesOnUniversalLinkOpen` **or** `DeepLinkServicesOnCustomSchemeUrlOpen` (listener, persistent)
- `DeepLinkServicesGetUniversalLinkResult` **or** `DeepLinkServicesGetCustomSchemeResult` (extractor)

## Implementation Steps

1. Keep the listener action active (bootstrap scene).
2. On `receivedEvent`, call the matching `Get*Result` action and read `host` + `path`.
3. Route using PlayMaker string compares:
   - Example universal link: `https://game.com/news/patch-notes`
     - host = `game.com`
     - path = `/news/patch-notes`
   - Example custom scheme: `myapp://store/item/123`
     - host = `store`
     - path = `/item/123`

## Safety Tip
Always validate known hosts/paths before navigating (ignore unknown links).

