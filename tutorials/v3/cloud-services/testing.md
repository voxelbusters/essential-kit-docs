# Testing

You need to test the following scenarios under Cloud Services.

* Once after re-installing the app, the data needs to be retained post first sync
* Data should exist on other devices for the same account once a synchronize is successful

{% hint style="success" %}
Cloud Services testing needs to be performed on real mobile hardware device
{% endhint %}

### Testing data post re-install

1. Call Synchronize for the first time of launch and it prompts a login if required to connect user profile.
2. Set a key value and note the details
3. Wait for synchronize or call Synchronize manually
4. Uninstall the app
5. Install the app again
6. Call Synchronize
7. Get the key value set in step 2
8. Check data in **step 2** and **step 7** and they should **match.**

### Data existence on other devices

1. Call Synchronize for the first time of launch and it prompts a login if required to connect user profile.
2. Set a key value and note the details
3. Wait for synchronize or call Synchronize manually
4. Jump to another device with **same user account** (**iCloud** on iOS, **Google Play** on Android)
5. Call Synchronize
6. Get the value for key set in step 2
7. Check data in **step 2** and **step 7** and they should **match**.

{% hint style="success" %}
On Android, we always consider the data copy which has the longest play time for conflict resolution in case of any conflicts.
{% endhint %}

{% hint style="danger" %}
Make sure while testing, you use same user account on testing devices. As the feature relies internally on iCloud and Google play services, for sync it needs common account which is quite expected.
{% endhint %}
