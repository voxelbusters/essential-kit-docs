# Cloud Services - PlayMaker

Store and sync key-value data across devices using platform cloud storage.

## Actions (9)
- Write/read: `CloudServicesSetValue`, `CloudServicesGetValue` (supports Bool/Int/Float/String/ByteArray)
- Existence: `CloudServicesHasKey` (checks current snapshot)
- Sync: `CloudServicesSynchronize` (fires `successEvent` / `failureEvent`)
- Change listener: `CloudServicesOnSavedDataChange` (persistent; fires `dataChangedEvent`)
- Change helper: `CloudServicesGetChangedKeyInfo` (reads cached changed keys by index)
- Conflict helper: `CloudServicesGetCloudAndLocalCacheValues` (reads both cloud + local cache value for a key)
- User listener: `CloudServicesOnUserChange` (persistent; fires account status events)
- Delete: `CloudServicesRemoveKey`, `CloudServicesRemoveAllKeys`

## Key patterns
- **SetValue/GetValue are synchronous**. Use `CloudServicesSynchronize` when you want to push/pull changes and get a completion event.
- **Listener actions should stay active**:
  - `CloudServicesOnSavedDataChange` receives remote changes and provides `changedKeys` + `changeReason`.
  - `CloudServicesOnUserChange` reports account availability (signed in/out/restricted).

## Common flows
- Save: `SetValue` (one or more keys) → `Synchronize`
- Load with defaults: `HasKey` → `GetValue` (else keep local default)
- Multi-device: keep `OnSavedDataChange` active → on `dataChangedEvent`, loop keys and `GetValue`
- Reset: `RemoveKey`/`RemoveAllKeys` → `Synchronize`

## Use cases
Start here: `use-cases/README.md`
