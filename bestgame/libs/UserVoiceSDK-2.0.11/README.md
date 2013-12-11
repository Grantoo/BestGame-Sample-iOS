Overview
--------

UserVoice for iOS allows you to embed UserVoice directly in your iPhone or iPad app.

![Tour](https://www.uservoice.com/assets/img/ios/ios-animation.gif)

You will need to have a UserVoice account (free) for it to connect to. Go to [uservoice.com/ios](http://uservoice.com/ios) to sign up.

Binary builds of the SDK are available for download.
* Current release: [2.0.11](http://sdk-downloads.uservoice.com/ios/UserVoiceSDK-2.0.11.tar.gz)

We also have an [example app](https://github.com/uservoice/uservoice-iphone-example) on GitHub that demonstrates how to build and integrate the SDK.

Installation
------------

* Download the latest build.
* Drag `UVHeaders`, `UVResources`, and `libUserVoice.a` into your project.
  * When adding the folders, make sure you have "Create groups for any added folders" selected rather than "Create folder references for any added folders".
* Note that the `.h` files in  `UVHeaders` do not need to be added to your target.
* Add QuartzCore and SystemConfiguration frameworks to your project.

See [DEV.md](https://github.com/uservoice/uservoice-iphone-sdk/blob/master/DEV.md) if you want to build the SDK yourself.

Note: If you opt to compile pull the UserVoice source into your application rather than using `libUserVoice.a`, and your project uses ARC, you will need to set `-fno-objc-arc` for all of the UserVoice source files. We are not currently using ARC, although we are planning to migrate to it eventually.

Obtain Key And Secret
---------------------

* If you don't already have a UserVoice account then go get one for free at [uservoice.com/ios](http://uservoice.com/ios).
* Go to the admin console (yourdomain.uservoice.com/admin) of your UserVoice account, navigate to `Settings` and click the `Channels` tab.
* Add an iOS App (if one doesn't already exist).
* Copy the generated `Secret` and `API key`.

API
---

Once you have completed these steps, you are ready to launch the UserVoice UI
from your code. Import `UserVoice.h` and create a `UVConfig` using one of the
following options.

### Configuration

**1. Standard Login:** This is the most basic option, which will allow users to
either sign in, or create a UserVoice account, from inside the UserVoice UI.
This is ideal if your app does not have any information about the user.

    UVConfig *config = [UVConfig configWithSite:@"YOUR_USERVOICE_URL"
                                         andKey:@"YOUR_KEY"
                                      andSecret:@"YOUR_SECRET"];

**2. SSO for local users:** This will find or create a new user by passing a
name, email, and unique id. However, it will only find users that were
previously created using this method. It will not allow you to log the user in
as an existing UserVoice account. This is ideal if you only want to use
UserVoice with your iOS app.

    UVConfig *config = [UVConfig configWithSite:@"YOUR_USERVOICE_URL"
                                         andKey:@"YOUR_KEY"
                                      andSecret:@"YOUR_SECRET"
                                       andEmail:@"USER_EMAIL"
                                 andDisplayName:@"USER_DISPLAY_NAME"
                                        andGUID:@"GUID"];

**3. UserVoice SSO:** This is the most flexible option. It allows you to log
the user in using a UserVoice SSO token. This is ideal if you are planning to
use single signon with UserVoice across multiple platforms. We recommend you
encrypt the token on your servers and pass it to the iOS app.

    UVConfig *config = [UVConfig configWithSite:@"YOUR_USERVOICE_URL"
                                         andKey:@"YOUR_KEY"
                                      andSecret:@"YOUR_SECRET",
                                    andSSOToken:@"SOME_BIG_LONG_SSO_TOKEN"];

### Custom Fields

You can set custom field values on the `UVConfig` object. These will be used
associated with any tickets the user creates during their session. You can
also use this to set default values for custom fields on the contact form.

Note: You must first configure these fields in the UserVoice admin console.
If you pass fields that are not recognized by the server, they will be ignored.

    config.customFields = @{@"Key" : @"Value"};

### Specify a help topic (optional)

You can specify a help topic by id, which affects two things:

 1. That topics articles will be displayed directly on the portal screen.
 2. Only artiles in that topic will show up as instant answers.

<pre>
config.topicId = 123;
</pre>

### Toggle features

You can turn off certain features of the SDK if you do not want to use them. By
default, all features are enabled if they are available on your account.

**1. Turn off browsing the forum.** The user will still be able to post ideas, and view ideas that they find by searching.

    config.showForum = NO;

**2. Turn off posting ideas.** The user will still be able to browse and search existing ideas.

    config.showPostIdea = NO;

**3. Turn off the contact form.**

    config.showContactUs = NO;

**4. Turn of the knowledge base.** This only affects the knowledge base browser on the portal screen. Instant answers will still include articles.

    config.showKnowledgeBase = NO;

If you deep-link to an area that is turned off (such as the contact form), it
will still work. Turning off the feature only prevents it from being accessible
anywhere in the UserVoice UI.

### Invocation (Deep Linking)

There are 4 options for how to launch UserVoice from within your app:

**1. Standard UserVoice Interface:** This launches the UserVoice for iOS portal page where the user can browse suggestions, contact you or browse the knowledgebase. This is the full experience of everything the SDK can do.
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self andConfig:config];

**2. Direct link to contact form:** Launches user directly into the contact form, with Instant Answers, experience. Useful to link to from error or setup pages in your app.

    [UserVoice presentUserVoiceContactUsFormForParentViewController:self andConfig:config];
    
**3. Direct link to feedback forum:** Launches the user directly into the feedback forum where they can browse, vote on or give their own feedback. Useful for linking from a "Give us your ideas?" prompt from within your app.

    [UserVoice presentUserVoiceForumForParentViewController:self andConfig:config];

**4. Direct link to idea form:** Launches user directly into the idea form, with Instant Answers, experience.

    [UserVoice presentUserVoiceNewIdeaFormForParentViewController:self andConfig:config];

### Customizing Colors

You can also customize the appearance of the UserVoice user interface by
creating a custom stylesheet.

    #import "UVStyleSheet.h"

    @interface MyStyleSheet : UVStyleSheet

    @end

    @implementation MyStyleSheet
    
    - (UIColor *)backgroundColor {
        return [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f];
    }

    @end

    [UVStyleSheet setStyleSheet:[[MyStyleSheet alloc] init]];

### User Language

The library will detect and display in the language the device is set to provided that language is supported by the SDK ([see currently supported languages](https://github.com/uservoice/uservoice-iphone-sdk#translations).).

Feedback
--------

You can share feedback on the [UserVoice for iOS forum](http://feedback.uservoice.com/forums/64519-iphone-sdk-feedback).

FAQs
--------

**What if I only want to collect feedback? What if I only want a contact form?**
Don’t worry. UserVoice is a modular system and you can link to only the parts of the SDK you want to use. Check out how you can configure [invocation](https://github.com/uservoice/uservoice-iphone-sdk#invocation).

**Why would I use this over a Mail link?**
There are a lot of reasons why UserVoice for iOS is superior to a Mail link:

* It doesn’t take your users out of your app.
* It’s a more efficient way to scale customer support and engagement:
  * UserVoice automatically suggests articles and forum posts that help solve users’ issues before they contact you. We call it Instant Answers and it can reduce your support load by up to 40%.
  * We've shown it can reduce junk emails (people clicking send to get out of the email app) by up to 74%.
  * You can setup custom fields to ask custom questions and pass in environment information (account IDs) that help your agents answer questions faster, reducing the back and forth between agents and customers.
* By having a dedicated space for users to give feedback and vote up other users’ ideas, not only will you get more feedback (and more prioritized feedback), but you’ll also reduce the number of feature requests that end up in your support queue.

**What if I have a web app as well?**
No problemo! Every UserVoice account comes with a yourname.uservoice.com site and web widgets so you can administer both your mobile and web users from your UserVoice admin console.

**What about users who still send in email for support?**
UserVoice can handle that as well. Simply setup your existing support email forward to your UserVoice tickets email address (tickets@yourdomain.uservoice.com).

**Does it pass device ids or anything that would get me in trouble with Apple?**
Nope. UserVoice for iOS follows all of Apple’s policies to make sure you can confidently include our SDK in your app.

**Can I customize the look and feel to match my app?**
Yes. You can customize the colors of the UserVoice modal dialogs by creating your own stylesheet. Check out the [customization ] (https://github.com/uservoice/uservoice-iphone-sdk#customizing-colors) for more info.

If you have any other questions please contact support@uservoice.com.

Translations
------------

Currently the UI is available in English, French, German, Dutch, Italian, and Traditional Chinese.
We are using [Twine](https://github.com/mobiata/twine) to manage the translations.

To contribute to the translations, follow these steps:

* Fork the project on Github
* Edit the `strings.txt` file
* Commit your changes and open a pull request

If you want to go the extra mile and test your translations, do the following:

* If you are adding a language:
  * `mkdir Resources/YOURLOCALE.lproj`
  * `touch Resources/YOURLOCALE.lproj/UserVoice.strings`
* Install the `twine` gem
* Run `./update_strings.sh` to generate the strings files
* Run the example app (or your own app) to see how things look in the UI
* Make note of any layout issues in your pull request so that we can look at it
  and figure out what to do.

Some strings that show up in the SDK come directly from the UserVoice API. If a
translation is missing for a string that does not appear in the SDK codebase,
you will need to contribute to the main [UserVoice translation
site](http://translate.uservoice.com/).

iOS Versions
------------

* Full support for iOS 5.0+
* For iOS 4.3 we accept patches, but don't guarantee support
* Earlier versions of iOS are not supported
* Builds are provided for armv7--there is no armv6 device that runs a supported version of iOS
* In general, the plan is to keep in step with public releases of Xcode

Contributors
------------

Special thanks to:

* [netbe](https://github.com/netbe) for the French translation
* [Piero87](https://github.com/Piero87) for the Italian translation
* [zetachang](https://github.com/zetachang) for the Traditional Chinese translation
* [nvh](https://github.com/nvh) for the Dutch translation
* [vinzenzweber](https://github.com/vinzenzweber) and [Blockhaus Media](http://www.blockhaus-media.com/) for the German translation
* Everyone else who [reported bugs or made pull requests](https://github.com/uservoice/uservoice-iphone-sdk/issues?state=closed)!

License
-------

Copyright 2010 UserVoice Inc. 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/f5b60bff0fbee98bc0e43f57eb49576f "githalytics.com")](http://githalytics.com/uservoice/uservoice-iphone-sdk)
