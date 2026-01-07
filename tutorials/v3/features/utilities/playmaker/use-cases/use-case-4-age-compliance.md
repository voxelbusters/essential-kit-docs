# Request Age Compliance Info

## Goal
Request user age range info and declaration method for compliance or gating flows.

## Actions Required
| Action | Purpose |
|--------|---------|
| UtilitiesRequestInfoForAgeCompliance | Requests age compliance info (async) |
| UtilitiesGetInfoForAgeComplianceSuccessResult | Read cached result (optional) |
| UtilitiesGetInfoForAgeComplianceError | Read cached error (optional) |

## Variables Needed
- `lowerBounds` (Int Array, optional)
- `upperBounds` (Int Array, optional)

## Implementation Steps

### 1. State: RequestAgeCompliance
**Action:** UtilitiesRequestInfoForAgeCompliance  
- Optional: set `lowerBounds` + `upperBounds` arrays (same length)
- Events:
  - `successEvent` → `HandleAgeComplianceSuccess`
  - `failureEvent` → `HandleAgeComplianceFailure`

### 2. State: HandleAgeComplianceSuccess
Use the cached outputs:
- Action: `UtilitiesGetInfoForAgeComplianceSuccessResult`

### 3. State: HandleAgeComplianceFailure
Action: `UtilitiesGetInfoForAgeComplianceError`

## Notes
- If no ranges are provided, the default range (0–100) is used.
- If array lengths differ, defaults are used.

## Flow Diagram
```
RequestAgeCompliance
    ├─ successEvent → HandleAgeComplianceSuccess
    └─ failureEvent → HandleAgeComplianceFailure
```
