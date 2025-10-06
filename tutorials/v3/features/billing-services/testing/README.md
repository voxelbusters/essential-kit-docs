# Testing

Use these guides to validate Billing Services end-to-end before release. Start with your platform quickstart, then follow the tips for common purchase edge cases.

{% content-ref url="testing-ios.md" %}
[Test on iOS](testing-ios.md)
{% endcontent-ref %}

{% content-ref url="testing-android.md" %}
[Test on Android](testing-android.md)
{% endcontent-ref %}

- Create sandbox/tester accounts that match your store configuration
- Verify consumables, non-consumables, and subscription renewals
- Exercise restore flows and interrupted purchases
- Repeat validation after changing product metadata in stores

{% hint style="info" %}
Need a working baseline? Run `Assets/Plugins/VoxelBusters/EssentialKit/Examples/Scenes/BillingServicesDemo.unity` to compare results against the sample implementation.
{% endhint %}
