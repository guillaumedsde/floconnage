{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      preConfig = builtins.readFile "${pkgs.arkenfox-userjs}/user.js";
      settings = {
        "privacy.resistFingerprinting.letterboxing" = false;
        "webgl.disabled" = false;
        "keyword.enabled" = true;
        "network.dns.disableIPv6" = false;
        "browser.tabs.firefox-view" = false;
        "browser.newtabpage.enabled" = true;
        "browser.sessionstore.resume_from_crash" = false;
        "browser.startup.page" = 1;
        "browser.chrome.site_icons" = true;
        "signon.firefoxRelay.feature" = "disabled";
        "browser.backup.enabled" = false;
        "browser.backup.restore.enabled" = false;
        "browser.backup.archive.enabled" = false;
        "browser.urlbar.trustPanel.breachAlerts" = false;
        "browser.urlbar.trustPanel.breachAlerts.featureGate" = false;
      };
    };
    nativeMessagingHosts = with pkgs; [
      keepassxc
    ];
    policies = {
      AIControls.Default.Value = "blocked";
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundAppUpdate = false;
      DefaultSerialGuardSetting = 2;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
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
        Category = "standard";
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
        Weather = false;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
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
          default_area = "menupanel";
        };
        "keepassxc-browser@keepassxc.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
          private_browsing = true;
          default_area = "menupanel";
        };
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
        };
      };
    };
  };
}
