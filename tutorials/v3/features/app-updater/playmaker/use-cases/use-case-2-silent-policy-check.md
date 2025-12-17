# Silent Policy Check

## Goal
Check for updates silently without blocking UI, and conditionally show update prompt based on policy.

## Actions Required
| Action | Purpose |
|--------|---------|
| AppUpdaterRequestUpdateInfo | Query store for update status (cached) |
| AppUpdaterGetRequestUpdateInfoSuccessResult | Read updateStatus after SUCCESS |

## Variables Needed
- updateStatus (Enum: AppUpdaterUpdateStatus)
- lastCheckTime (DateTime)
- checkInterval (Int) - hours between checks

## Implementation Steps

### 1. CheckIfTimeToCheck (Entry State)
Calculate time since lastCheckTime:
- If >= checkInterval → PerformCheck
- If < checkInterval → Skip

### 2. PerformCheck
**Action:** AppUpdaterRequestUpdateInfo
- Run asynchronously in background
- **Events:**
  - successEvent → GetStatus
  - failureEvent → Skip

### 3. GetStatus
**Action:** AppUpdaterGetRequestUpdateInfoSuccessResult
- **Outputs:**
  - updateStatus → updateStatus

### 4. ProcessResult
Save current time to lastCheckTime.
- If updateStatus == Available or Downloaded → ApplyUpdatePolicy
- Else → Skip

### 5. ApplyUpdatePolicy
Apply business logic:
- Critical update → Show immediate alert
- Major version → Show on next launch
- Minor version → Show badge/banner (non-intrusive)
- Patch version → Log only, no UI

### 6. Skip
Continue normal app flow without interruption

## Common Issues
- **Check frequency**: Don't check too often (recommend: 24 hours)
- **Battery/data**: Avoid checks on cellular if large metadata
- **Persistence**: Save lastCheckTime to PlayerPrefs
- **Background limits**: iOS/Android may throttle background checks

## Best Practices
- Check once per day maximum
- Use PlayerPrefs to track last check time
- Show update UI only for significant versions
- Respect user's "Don't show again" preference

## Flow Diagram
```
CheckIfTimeToCheck
├─ Time elapsed → PerformCheck
│                 ├─ SUCCESS → GetStatus → ProcessResult
│                 │                         ├─ Available/Downloaded → ApplyUpdatePolicy → [UI based on severity]
│                 │                         └─ NotAvailable → Skip
│                 └─ FAILURE → Skip
└─ Too soon → Skip
```

## Use When
- Daily app launch checks
- Non-intrusive version monitoring
- Gradual rollout strategies
- A/B testing update prompts
