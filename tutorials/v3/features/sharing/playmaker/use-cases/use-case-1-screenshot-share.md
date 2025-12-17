# Screenshot Share (Share Sheet)

## Goal
Share text/URL and optionally a screenshot/image using the native share sheet.

## Actions used
- `ShareSheetShow`
- `ShareSheetGetError` (optional)

## Variables
- `text` (String)
- `url` (String)

## Flow
1. State: `ShowShareSheet`
   - Action: `ShareSheetShow`
   - Provide at least one content type:
     - `text` and/or `url`
     - `addScreenshot = true` (optional)
     - `image` (Texture2D) (optional)
   - Events:
     - `closedWithDoneEvent` → Done
     - `closedWithCancelledEvent` → Cancelled
     - `closedWithUnknownEvent` → Unknown (optional handling)
     - `closedWithFailedEvent` → `ShareSheetGetError` (optional) then show error

## Notes
- `ShareSheetResultCode.Unknown` can happen on platforms where the OS cannot report the final user action.
