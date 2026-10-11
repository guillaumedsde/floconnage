{ pkgs, lib, ... }: {
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
        # Arkenfox disables spell checking (layout.spellcheckDefault = 0);
        # re-enable it for both multi-line and single-line inputs.
        "layout.spellcheckDefault" = 2;
        "signon.firefoxRelay.feature" = "disabled";
        "browser.backup.enabled" = false;
        "browser.backup.restore.enabled" = false;
        "browser.backup.archive.enabled" = false;
        "browser.urlbar.trustPanel.breachAlerts" = false;
        "browser.urlbar.trustPanel.breachAlerts.featureGate" = false;
      };
      search = {
        force = true;
        default = "Startpage";
        order = [
          "Startpage"
          "google"
        ];
        engines = {
          "Startpage" = {
            urls = [{
              template = "https://www.startpage.com/do/mypage.pl";
              params = [
                {
                  name = "prfe";
                  value = "f07607ab47866cc1dab2a9fd34fab2a84372edc66436030710b03db339dd39170a7f517debea64dca5e839aa0b3f535f1b5fe7b55e1aeee8c36b52b3612c71ab7d4ee7418a70afa653269c09c6267612";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }];
            icon = "https://www.startpage.com/favicon.ico";
            definedAliases = [ "@sp" ];
          };
          # Hide all built-in engines except Google.
          bing.metaData.hidden = true;
          ddg.metaData.hidden = true;
          ebay.metaData.hidden = true;
          amazondotcom-us.metaData.hidden = true;
          wikipedia.metaData.hidden = true;
          wikipedia-fr.metaData.hidden = true;
          qwant.metaData.hidden = true;
          ecosia.metaData.hidden = true;
          reddit.metaData.hidden = true;
          youtube.metaData.hidden = true;
        };
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
      "3rdparty".Extensions."keepassxc-browser@keepassxc.org" = {
        settings = {
          autoRetrieveCredentials = false;
          showLoginNotifications = false;
          defaultPasswordManager = true;
          passkeys = lib.mkDefault true;
        };
      };
    };
  };
}
