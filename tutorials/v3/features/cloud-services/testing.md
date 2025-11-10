# Testing & Validation

Use these checks to confirm your Cloud Services integration before release.

## Editor Simulation
- When you run in the Unity Editor, the Cloud Services simulator is active automatically
- Simulator stores data locally in JSON files to mimic cloud behavior
- To clear test data, delete the local cache file at the path shown in console logs
- Remember: simulator responses mimic native behavior but are not a substitute for on-device testing

{% hint style="warning" %}
Cloud Services testing **requires real mobile hardware** with active cloud accounts (iCloud or Google Play). The Unity Editor simulator cannot test actual cloud synchronization.
{% endhint %}

## Device Testing Checklist

### Test 1: Data Persistence After Reinstall
This validates that cloud data survives app deletion and reinstallation.

1. Install the app on a test device
2. Call `Synchronize()` on first launch (may prompt for cloud account login)
3. Set test data: `CloudServices.SetString("test_key", "test_value")`
4. Call `Synchronize()` to upload to cloud
5. Wait for sync to complete successfully
6. Uninstall the app completely
7. Reinstall the app
8. Call `Synchronize()` on launch
9. Retrieve the test data: `CloudServices.GetString("test_key")`
10. Verify the value matches step 3

**Expected result**: Data from step 3 should be restored after reinstall.

### Test 2: Cross-Device Synchronization
This validates that data syncs between multiple devices using the same cloud account.

1. Install app on Device A with cloud account signed in
2. Call `Synchronize()` and set test data
3. Call `Synchronize()` to upload changes
4. Wait for sync success confirmation
5. Install app on Device B signed into **same cloud account**
   - **iOS**: Same iCloud account
   - **Android**: Same Google Play account
6. Call `Synchronize()` on Device B
7. Retrieve the test data set in step 2
8. Verify data matches across both devices

**Expected result**: Device B should load the exact data saved on Device A.

### Test 3: Conflict Resolution
This validates that simultaneous edits on multiple devices are detected and resolved.

1. Set same key on both Device A and Device B with different values
2. Call `Synchronize()` on Device A first
3. Call `Synchronize()` on Device B
4. Verify `OnSavedDataChange` event fires on Device B with changed keys
5. Implement conflict resolution logic (pick winner or merge)
6. Call `Synchronize()` again to upload resolved data
7. Verify both devices have the resolved value

**Expected result**: `OnSavedDataChange` fires with conflict detection, allowing custom resolution logic.

### Test 4: Account Switching
This validates proper data isolation when users switch cloud accounts.

1. Sign in with Account A on a device
2. Set test data and sync
3. Sign out and sign in with Account B on the same device
4. Call `Synchronize()`
5. Verify `OnSavedDataChange` fires with `AccountChange` reason
6. Verify Account A's data is cleared and Account B's data loads

**Expected result**: Each account maintains separate cloud data with no cross-contamination.

### Test 5: Offline Behavior
This validates that the app works when cloud services are unavailable.

1. Enable airplane mode or disable network
2. Use `SetBool`, `SetString`, etc. to store data locally
3. Retrieve data with getters - should work offline
4. Re-enable network
5. Call `Synchronize()` to upload offline changes
6. Verify data syncs to cloud successfully

**Expected result**: Local storage works offline, syncs when connectivity restores.

## Pre-Submission Review
- Test on both iOS and Android devices to verify platform-specific behavior
- Ensure first-run `Synchronize()` experience is smooth (handle auth prompts gracefully)
- Verify storage limits aren't exceeded (1MB iOS, 3MB Android) with production data volumes
- Test with multiple cloud accounts to ensure proper data isolation
- Capture screenshots of successful sync operations for store submissions
- Test reinstall scenario to ensure new users can restore cloud saves
- Verify conflict resolution handles edge cases (simultaneous edits, quota violations)

## Common Testing Issues

### iOS Testing
- **iCloud not available**: User must be signed into iCloud in device settings
- **Data not syncing**: Check iCloud storage quota in Settings > [User] > iCloud
- **Simulator behavior**: iOS Simulator may not reliably test iCloud - use real devices

### Android Testing
- **Google Play login required**: First sync prompts for Google Play sign-in
- **Saved Games not enabled**: Verify Play Console has Saved Games API enabled
- **Account restrictions**: Some managed Google accounts restrict Saved Games access
- **Auto-sync timing**: Android auto-syncs on app state changes - test backgrounding behavior

## Debug Logging
Enable detailed logging to troubleshoot sync issues:

```csharp
void OnEnable()
{
    CloudServices.OnUserChange += (result, error) =>
    {
        if (error != null)
        {
            Debug.LogError($"User change error: {error.Description}");
        }
        else
        {
            Debug.Log($"User: {result.User?.UserId}, Status: {result.User?.AccountStatus}");
        }
    };

    CloudServices.OnSynchronizeComplete += (result) =>
    {
        Debug.Log($"Sync complete - Success: {result.Success}");
    };

    CloudServices.OnSavedDataChange += (result) =>
    {
        Debug.Log($"Data changed - Reason: {result.ChangeReason}, Keys: {string.Join(", ", result.ChangedKeys ?? new string[0])}");
    };
}
```

{% hint style="success" %}
If your implementation works in the demo scene but fails in your project, compare event registration, sync timing, and conflict resolution logic between the two.
{% endhint %}
