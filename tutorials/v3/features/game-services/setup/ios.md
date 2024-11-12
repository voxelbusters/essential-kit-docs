# iOS

Plugin internally uses Game Center to provide game services funtionality.

> Game Center is an Apple service that provides social gaming functionality to games. Game Center allows users to track their scores on a leaderboard, view achievement progress.

Adding support for certain Game Center features, like leaderboards and achievements, requires you to provide additional assets and metadata. Some examples include achievement images and descriptions, as well as leaderboard artwork. You provide and manage all of these within your App Store Connect account.

In App Store Connect, [add an app to your account](https://help.apple.com/app-store-connect/#/dev2cd126805) that matches the bundle ID in Xcode, then configure Game Center components such as leaderboards, achievements.

## Configure leaderboards <a href="#dev32b7a345f" id="dev32b7a345f"></a>

1. Open [Appstore connect](https://appstoreconnect.apple.com/)
2. From My Apps, select the app you wish to enable for Game Center.
3. In the toolbar, click Features. The page opens with the Game Center tab selected.
4. Click the add button (+) in the Leaderboards section.
5. Select Choose next to Classic Leaderboard.
6. Input your leaderboard metadata. For more information, see [Leaderboard properties](https://help.apple.com/app-store-connect/#/dev2cc707039?sub=devf6a794ff1).
   * Leaderboard Reference Name
   * Leaderboard ID
   * Score Format
   * Score Submission Type
   * Sort Order
   * Score Range (Optional)
7. Under Leaderboard Localization, add one or more languages by clicking Add Language.
8.  Enter the required information:

    * In the dialog that appears, choose a language from the Language menu.
    * In the Name field, enter a localized reference name for the leaderboard. For example, if you choose Finnish from the Language menu, enter the Finnish name for the leaderboard in the Name field.
    * Choose a localized score format from the Score Format menu, then enter the singular and plural version of your score format suffix. If Score Format Suffix Plural doesn’t appear, it’s not needed for the selected language. Additionally, if you want a space to appear between the score and the suffix, you can enter a space followed by the suffix text.
    * Optionally, you can click Choose File to add a localized image for your leaderboard.
    * Click Save. To add additional language support for your leaderboards, repeat the above steps for each language.

    8\. Click Save.

{% hint style="success" %}
The Leaderboard ID you set while creating the Leaderboard meta data on Appstore connect will be the **platform Id** for iOS platform on [Essential Kit Settings](./#properties).
{% endhint %}

## Configure achievements <a href="#dev2f1b0df32" id="dev2f1b0df32"></a>

1. Open [Appstore connect](https://appstoreconnect.apple.com/)
2. From My Apps, select your app.
3. In the toolbar, click Features. The page opens with the Game Center tab selected.
4. Click the add button (+) under the Achievements section.
5. Input your achievement metadata. For more information, see [Achievement properties](https://help.apple.com/app-store-connect/#/dev928049713?sub=dev95e709d24).
   * Achievement Reference Name
   * Achievement ID
   * Point Value
   * Hidden: Select Yes if you want the achievement to be hidden until the user earns it; otherwise, select No.
   * Achievable More Than Once: Select Yes if the user can earn the achievement multiple times; otherwise, select No.
6. Add one or more language in the Achievement Localization section by clicking Add Language.
7. Enter your [Achievement language properties](https://help.apple.com/app-store-connect/#/dev928049713?sub=deve0ca0402a):
   * In the dialog that appears, choose a language from the Language menu.
   * Title: Enter a localized name for the achievement.
   * Pre-earned Description: Enter a localized description of the achievement.
   * Earned Description: Enter a localized description of the achievement.
   * Add a localized image by selecting Choose File.
   * Click Save. To add additional language support for your achievements, repeat the above steps for each language.
8. Click Save.

{% hint style="success" %}
The Achievement ID you set while creating the Achievement meta data on Appstore connect will be the platform Id for iOS on [Essential Kit Settings](./#properties).
{% endhint %}

