# SUSE Localization Pack

**Extends and localizes the Rancher UI with additional languages for global operations teams.**

### Overview
Rancher ships in English and Simplified Chinese. The SUSE Localization Pack adds Spanish, French, Brazilian Portuguese, and Traditional Chinese, so operators can manage their clusters in the language they work in every day. That means fewer misread prompts on critical actions and a Rancher UI that feels native to teams around the world.

Documentation for SUSE Localization Pack can be found [**here**](https://documentation.suse.com/cloudnative/rancher-manager/latest/en/rancher-admin/users/settings/user-preferences.html).

This extension is **experimental** and available to Rancher Prime customers.

### Core Architecture
The extension contains no workloads or backend services. When the Rancher UI loads, it registers each translation catalog with the UI's internationalization layer, and Rancher offers the new languages in its language picker next to the built-in ones. Any string a catalog does not yet cover falls back to English, so the interface stays fully usable.

### Key Technical Features
* **Four Additional Languages**: Español, Français, Português (Brasil), and 繁體中文 (Traditional Chinese), each covering the full Rancher UI.
* **Per-User Selection**: Every user picks their own language in **Preferences**; installing the pack changes nothing for users who stay in English.
* **Safe Fallback**: Strings not yet translated appear in English instead of as missing labels, so new Rancher features remain usable from day one.
* **Validated Translations**: Every language is checked automatically against the Rancher UI's English source for missing keys, broken placeholders, and altered markup.

### Target Use Cases
* **Global Operations Teams**: Giving regional operators in Latin America, Europe, and Asia-Pacific a Rancher UI in their own language.
* **Faster Onboarding**: Helping administrators who are less fluent in English learn Rancher without a language barrier.

### Deployment Path
* **Prerequisites**: Rancher Prime subscription.
* **First Step**: Open the user menu, select **Preferences**, and choose a language under **Language**.
