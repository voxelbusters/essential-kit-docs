# Deep Link Services - PlayMaker

Receive and route deep links:
- Custom schemes (example: `myapp://oauth-callback?token=xyz`)
- Universal links (example: `https://game.com/promo?campaign=summer2024`)

## Actions (4)
- `DeepLinkServicesOnCustomSchemeUrlOpen` (listener): keep active; fires `receivedEvent`
- `DeepLinkServicesGetCustomSchemeResult` (extractor): call after `receivedEvent` → outputs `rawUrl/scheme/host/path/queryKeys/queryValues`
- `DeepLinkServicesOnUniversalLinkOpen` (listener): keep active; fires `receivedEvent`
- `DeepLinkServicesGetUniversalLinkResult` (extractor): call after `receivedEvent` → outputs `rawUrl/scheme/host/path/queryKeys/queryValues`

## Key pattern
1. Keep the listener action in an always-active FSM/state (bootstrap scene).
2. On `receivedEvent`, run the matching `Get*Result` action.
3. Route using `host/path` and optional query parameters (`queryKeys` + `queryValues`).

## Use cases
Start here: `use-cases/README.md`

