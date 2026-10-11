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
        # Firefox ships its own "Startpage" engine and drops custom
        # search.json engines that share its name, so use a distinct
        # name/id for ours.
        default = "Startpage (prfe)";
        order = [ "Startpage (prfe)" ];
        engines = {
          "Startpage (prfe)" = {
            urls = [{
              # /do/mypage.pl only loads the preferences encoded in `prfe`
              # (it ignores the query); /sp/search is the real search endpoint
              # and honors both `query` and `prfe`.
              # Per Startpage's own recommendation, `query` comes first and the
              # preferences token is appended after it.
              template = "https://www.startpage.com/sp/search";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
                {
                  name = "prfe";
                  value = "a15b3f89097cfab398a42c911ba5ef3d8d7989e3688b4a1184a3b68f3c9943e2328a8d056dcdc7e7fbcd63e7e6e9827ce6c17eddec951c868f410a299dc1025542db22baa06e51454ef4e2cf437e405a";
                }
              ];
            }];
            icon = "https://www.startpage.com/favicon.ico";
            definedAliases = [ "@sp" ];
          };
          # Hide all built-in engines.
          # Firefox now ships its own "Startpage" engine (id: startpage,
          # q + segment=startpage.apex.desktop params, no prfe); hide it so
          # only our prfe-enabled engine above is used.
          startpage.metaData.hidden = true;
          google.metaData.hidden = true;
          perplexity.metaData.hidden = true;
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
