# Introduction

> Want to know which games are using Essential Kit? Click [here](https://42matters.com/sdks/ios/voxelbusters-essential-kit).

[**Essential Kit**](https://link.voxelbusters.com/essentialkit) (V3) a true cross platform tool for Unity which provides unique and unified way to access native functionality on mobile platforms.

> Supported platforms : **iOS 15+ (till iOS 18)** | **Android 21+ (till API 35) | tvOS (Beta)**

> **450+** 🌟🌟🌟🌟🌟 | Used by **25,000+ developers** world-wide

> As promised, all customers get [Ads Kit](https://link.voxelbusters.com/ads-kit) for Free - No Code Required!



![](https://api.essentialkit.voxelbusters.com/v3/cover.png)

***

### **Important links**

[Unity Forum Thread](https://link.voxelbusters.com/essential-kit-unity-forum) | [Tutorials](plugin-overview/settings.md) | [Support](https://link.voxelbusters.com/essential-kit-support)



### **Highlights**

• **Unified** API design | **Never write** code **per platform**

• **Easy** installation

• No **knowledge** of native platform **services is required**

• **Simulate** most feature **behavior in the** Editor

• Generate Android **manifest** and **permissions** **as per** feature **usage**

• Automatically adds required **capabilities** on iOS and tvOS

• Only **select features** you need

• Complete **ASMDEF**

• Full **source code** is included

• Detailed **tutorials** with native platform setup

• **Unity cloud build** and batch mode compatible

• Actively supported **since 2015**

### **Feature set**

• Address Book - Access contacts of the user

• App Shortcuts - Utility for adding dynamic shortcuts to app icon for quick access of content

• App Updater - Prompt version updates to user

• Billing - Privacy First In-App purchases (Consumables/Non-Consumables/Subscriptions)

• Cloud Services - Save data in the cloud (iCloud & Saved Games)

• Deep Link Services (New!) - Connect your content/screen with a url

• Game Services - Leaderboards, Achievements done right

• Mail Sharing - Share data through mail

• Message Sharing - Share data as messages

• Media Library Services - Select, Capture, Save media content (Gallery/Camera)

• Native UI Popups (Alert Dialog, Date/Time Picker (New!) - Native alerts

• Network Connectivity - Check network connection

• Local Notification System - Schedule notifications

• Push Notification System - Receive remote notifications

• Rate My App - Get ratings

• Social Sharing (Facebook, Twitter, WhatsApp) - Share to social media

• Share Sheet - Share images and urls

• Task Services - Allows to run app in background

• WebView - Access browser within Unity



{% hint style="warning" %}
tvOS platform doesn't support features like Address Book, App Shortcuts, Media Library, Web View, Date Picker and Sharing - As these are natively not supported or allowed by tvOS platform.&#x20;



However, rest of the features are supported and unsupported features has null implementations ready.
{% endhint %}

### Feature Details and Game-Centric Use Cases

\
📇 Address Book Access : Fetch device contacts using filters (e.g., only contacts with email or phone), with support for pagination.

* Invite-a-friend features using player contact lists
* Send rewards when friends install the game
* Matchmaking or co-op party suggestions from contact book
* Create guilds or teams from real-world friends
* Share referral codes through known contacts



⚡ Creating Dynamic App Shortcuts: Add or remove custom app icon shortcuts that deep link into specific app content.

* Shortcut to “Daily Rewards” or time-limited challenges
* Instant launch into multiplayer mode or last level
* Quick open for character customization or guild chat
* One-tap entry into co-op events or clan war
* Feature newly unlocked mode directly from home screen



🔄 App Updater Integration: Detect if a newer version of the app is available and prompt players (optional or forced).

* Enforce version upgrade before online play
* Prompt update after login during major patches
* Soft update for minor UI improvements
* Support content version compatibility for multiplayer
* Announce and enforce seasonal updates or new maps



💰 In-App Purchases (Billing Services / IAP): Uses StoreKit 2 (iOS, tvOS) and Google Billing 7.x (Android). Supports consumables, non-consumables, subscriptions with multiple offers.

* Selling skins, coins, or ad-free upgrades
* Battle pass or season ticket subscriptions
* Restore purchases after reinstall
* Time-limited offers during events
* One-time purchase for special characters



☁️ Cloud Save for Unity Mobile Games: Cross-device player data sync using iCloud (iOS, tvOS) and Google Play Saved Games (Android).

* Sync progress across devices
* Cloud backup for offline/online games
* Allow iPhone users to switch to iPad
* Resume levels across reinstalls
* Support shared progress in family account scenarios\


🔗 Deep Link Handling in Unity: Support Universal Links and App Links with payload delivery.

* Invite links to a specific level or match
* Launch into in-game promotions or reward flows
* Enable streamers to share join links
* Referral codes encoded in deep links
* Return players to last session with context



🏆 Game Center & Google Play Game Services Integration: Full support for leaderboards, achievements, and player login.

* Show global leaderboards with score filters
* Progress-based achievements to reward milestones
* Weekly reset leaderboards for retention
* Friends-only scores for casual competition
* Reward unlocks tied to achievements



🎥 Unity Media Picker & Capture Integration: Select or capture media (images, videos) for gameplay, avatars, or sharing.

* Avatar creation using player camera
* Screenshot sharing of in-game achievements
* Photo-based puzzle or AR game mechanics
* Record short clips for social bragging
* Use photos as level textures or objects



🗓️ Native UI Dialogs and Pickers in Unity: Use platform-native alerts, confirmations, and pickers (date/time).

* Choose time for battle match scheduling
* Pick a farming cycle (plant/harvest dates)
* Alert players for irreversible choices
* Confirm restart of tough levels
* Plan weekly events with calendar picker\


🌐 Network Connectivity Monitor: Monitor real-time online status with event callbacks.

* Auto-pause online matches on disconnect
* Save offline and sync when online returns
* Delay IAP flow until stable connection
* Notify users about server reconnection
* Warn during multiplayer lobbies\


🔔 Push & Local Notifications: Schedule notifications with calendar/time triggers, repeat, and reboot persistence.

* Daily login reminder at 9AM
* Notify when energy refills
* Remind of upcoming boss fight
* Push promo offers near expiration
* Alert for ranked match open window\


⭐ App Rating Prompt: Native rating dialog, optional pre-check logic (e.g., after positive event).

* After completing a hard level
* After a streak of wins
* After purchase or reward unlock
* Periodic prompt after active sessions
* Trigger based on happy in-game behavior\


📤 Social Sharing Support: Native OS share sheet with support for media, text, and urls.

* Share win screen or high score
* Post screenshots to Instagram or Twitter
* Send in-game messages via WhatsApp\


🔄 Background Task Execution: Execute important background tasks even when the game is minimized or the device is locked. Supports time-limited operations to keep your game state up-to-date without requiring the app to be active.

* Synchronize player progress with backend
* Persist crafting/building timers in real-time even when the player switches apps.
* Upload player session data (kills, score, XP) in battle royale games when the app is backgrounded during match exit.
* Queue asset preloading or downloads (e.g., upcoming event content) while the game is backgrounded.
* Perform final save encryption or checkpoint sync before app sent to background.

\
⚙️ Utilities – Settings & Store Links: Quickly open app settings or direct users to your store page.

* Open app permissions for camera/mic
* Take users to update/download page
* Link to companion app or spin-off game\


🌍 Web View Integration: Load local or remote webpages inside your game with messaging and JS support.

* Show patch notes or event calendars
* Link to player profile on community hub
* Host user-generated levels in HTML
* Run surveys or feedback forms
* Display marketplace listings or DLC\


**Note**

• Plugin doesn't include Facebook SDK.

• Works with Unity Cloud Build.

• You need to add "com.unity.nuget.**newtonsoft**-json": "2.0.0" or higher in Packages/manifest.json

### Why Choose Us?

* Custom-coded and privacy-first: We don’t rely on third-party plugins, ensuring full control over your product’s functionality and privacy.
* Fast updates: We’re often the first to integrate updates for native libraries (e.g., StoreKit 2, Billing Client V6, V7).
* Extensive automation: Includes features like manifest generation, dependency handling, and build post-processing.
* Future plans: We’re working on open-sourcing major parts of the plugin to avoid vendor lock-in and ensure long-term flexibility.

***

**If you are upgrading from version 2.x, please follow** [**this guide**](whats-new-in-v3/upgrade-from-v2.md)**.**

**Third Party Plugins Compatibility**

• Plays nicely with [Anti-Cheat Toolkit](https://assetstore.unity.com/packages/slug/202695)

***

### **Our other products**

[Cross Platform **Screen Recorder Kit**](http://u3d.as/1nN3)

[**Easy ML Kit**](https://u3d.as/2PMe)

[**Ads Kit**](https://www.github.com/voxelbusters/ads-kit) **(Free & Open Source)**

[**Permissions Kit**](https://www.github.com/permissions-kit) **(Free & Open Source)**

[Reporting Kit](https://u3d.as/2Q6p)

[Cross Platform **Snapchat Kit**](http://u3d.as/1gWc)

[Cross Platform **Story Kit(Instagram)**](http://u3d.as/1pMn)

***

### Upgrade Strategy & Pricing Overview

We provide ongoing updates to ensure the plugin stays in line with evolving platform guidelines, OS requirements, and industry standards. To keep the product latest and supported, we charge a minimal upgrade fee for each major version release.

Upgrade Pricing History:

1. **V1 (Released 2015, Deprecated 2020)**&#x20;
   1. Lifespan: 5 years of support and free upgrades&#x20;
   2. Upgrade to V2: <=$50&#x20;
   3. [V2 vs V1](https://assetstore.essentialkit.voxelbusters.com/v2/version-2-vs-version-1)&#x20;
   4. Approx. cost breakdown: $10 per year based on the 5-year lifespan of V1.
2. **V2 (Released 2020, Deprecated 2024)**
   1. Lifespan: 4 years of support and free upgrades&#x20;
   2. Upgrade to V3: <=$40&#x20;
   3. [V3 vs V2](https://assetstore.essentialkit.voxelbusters.com/whats-new-in-v3/version-3-vs-version-2)&#x20;
   4. Approx. cost breakdown: \~$10 per year based on the 4-year lifespan of V2.

#### How the Upgrade Fee Works:

* The $10-$15 per year is an average upgrade cost for the lifespan of each major version.
* For example, when upgrading from V1 to V2, the $50 upgrade fee covers the full 5-year lifespan of V1 + additional features in V2, averaging $10 per year.
* When upgrading from V2 to V3, the $40 upgrade fee covers the 4-year lifespan of V2, averaging $10 per year.

***



