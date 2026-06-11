{ lib, pkgs, ... }: {
  programs.firefox = {
    enable = true;

    profiles.default = {
      extraConfig = lib.strings.concatLines [
        # Arkenfox
        (builtins.readFile "${pkgs.arkenfox-userjs}/user.js")
        ''
          user_pref("privacy.resistFingerprinting.letterboxing", false);
          user_pref("webgl.disabled", false);
          user_pref("keyword.enabled", true);
          user_pref("network.dns.disableIPv6", false);
          user_pref("browser.tabs.firefox-view", false);
        ''
      ];
    };
    policies = {
      AIControls = {
        Default.Value = "blocked";
        Translations.Value = "blocked";
        PDFAltText.Value = "blocked";
        SmartTabGroups.Value = "blocked";
        LinkPreviewKeyPoints.Value = "blocked";
        SidebarChatbot.Value = "blocked";
        SmartWindow.Value = "blocked";
      };
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundAppUpdate = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisableRemoteImprovements = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "always";
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        SuspectedFingerprinting = true;
        Category = "strict";
        BaselineExceptions = true;
        ConvenienceExceptions = true;
      };
      FirefoxHome = {
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        Stories = false;
        SponsoredPocket = false;
        SponsoredStories = false;
        Snippets = false;
      };
      FirefoxSuggest.WebSuggestions = false;
      GenerativeAI = {
        Enabled = false;
        Chatbot = false;
        LinkPreviews = false;
        TabGroups = false;
      };
      HttpsOnlyMode = "force_enabled";
      IPProtectionAvailable = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      RequestedLocales = [
        "en-US"
        "fr"
      ];
      SanitizeOnShutdown = {
        Cookies = true;
        History = true;
      };
      SearchEngines.PreventInstalls = true;
      SearchSuggestEnabled = false;
      ShowHomeButton = false;
      SkipTermsOfUse = true;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = false;
        MoreFromMozilla = false;
        FirefoxLabs = false;
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };
        "keepassxc-browser@keepassxc.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
          private_browsing = true;
        };
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
        };
      };
    };
  };
}
