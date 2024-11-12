# FAQ

## Why text is not getting added to facebook sharing dialog?

As per [facebook policy](https://developers.facebook.com/docs/apps/review/prefill/), it's not allowed to pre-fill the sharing dialog with text. User needs to manually enter the text.

## When to use Share Sheet?

Share sheet is a more generic way of sharing and is useful if you want your user to share your content to more services of their choice.

Based on the content being shared, the services in share sheet will get populated.

## Is there a way to detect if the user actually shared the content?

However, on iOS you can get the result code in the callback to check if it's a successful share or not.\
But on Android, it's not possible to detect the action result as the status is not provided by services sharing the content.





