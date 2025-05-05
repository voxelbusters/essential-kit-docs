---
description: Improvements and other changes in Version3 compared to Version 2
---

# Version 3 vs Version 2

## Improvements

#### Free Ads Kit (v1)

Get a <mark style="background-color:green;">free copy</mark> of [Ads Kit](https://link.voxelbusters.com/ads-kit) with V3. Ads Kit offer single api for adding any supported ad network. It has no-code work flow too and very limited api calls for supporting different ad types.

#### Complete Custom Implementation

We started V3 in the thought of including Unity IAP for subscriptions. But, we scrapped it and implemented our own for below reasons

* Unity IAP's workflow is quite different from our simple workflow
* We don't want our users to have any analytics dependency
* Not sure when Unity's Store Kit 2 implementation on iOS will be done as its the latest recommended billing framework

Now we have zero dependencies despite added new features. Have a look at our [release notes](release-notes.md) on what has changed and what's new!

#### New Features

We added four main new features **App Shortcuts**, **App Updater, Task Services(Background Processing)** and **Subscriptions** with multi-offer support along with serval other enhancements in terms of feature functionalities.

Added tvOS and Android PC(In progress) support.

#### Better Error Handling

V3 now sends error codes along with the error message for all features. This helps in communicating and debugging the errors easily.

#### Latest Compatibility

V3 is currently compatible with Android API 35 and iOS 18\* (18 in progress, tested till iOS 17)

{% hint style="success" %}
Billing Services on iOS uses **Store Kit 2** and latest **Google Billing Client** **v7** (at the time of this writing), **Unity 6** compatible
{% endhint %}

#### Intuitive API (based on lots of feedback)

We refactored each and every feature's api to adapt to the feedback we got for V2 (since 2020).

#### Fail Fast Approach

V3 throws errors at build time if any expected configuration is not setup correctly. This can save lots of time (actually for us too ;) - as customer setup issues are difficult for our support team to debug)

#### Follows Latest Recommended Guidelines

V3 aims to follow latest native recommended guidelines and implemented accordingly where ever applicable (Photo picker, Store Kit 2, Permission-less access etc...)



You can check the complete [release notes](release-notes.md) here for the list of all changes in V3.

