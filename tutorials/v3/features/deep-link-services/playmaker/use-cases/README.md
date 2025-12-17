# DeepLinkServices Use Cases

Quick-start guides for deep linking using PlayMaker custom actions.

## Available Use Cases

### 1. [Campaign Link Navigation](use-case-1-campaign-link.md)
**What it does:** Handle universal links from marketing
**Actions:** 2 (OnUniversalLinkOpen, GetUniversalLinkResult)

### 2. [OAuth Callback](use-case-2-oauth-callback.md)
**What it does:** Handle custom scheme for auth redirects
**Actions:** 2 (OnCustomSchemeUrlOpen, GetCustomSchemeResult)

### 3. [Route by Host/Path](use-case-3-route-by-host-path.md)
**What it does:** Safely route to screens/scenes based on `host` + `path`
**Actions:** 2 (OnUniversalLinkOpen or OnCustomSchemeUrlOpen, Get*Result)

### 4. [Read Query Param by Key](use-case-4-query-param-by-key.md)
**What it does:** Extract a specific query parameter (example: `token`, `campaign`) from `queryKeys/queryValues`
**Actions:** 2 (OnUniversalLinkOpen or OnCustomSchemeUrlOpen, Get*Result)

## Quick Action Reference
| Action | Purpose |
|--------|---------|
| DeepLinkServicesOnUniversalLinkOpen | Listen for universal links |
| DeepLinkServicesGetUniversalLinkResult | Read cached universal link details |
| DeepLinkServicesOnCustomSchemeUrlOpen | Listen for custom scheme URLs |
| DeepLinkServicesGetCustomSchemeResult | Read cached custom scheme details |

## Related Documentation
- **[README.md](../README.md)**
