# Lulzbot klipper macros and settings

Here is where the configuration files of stock Lulzbot machines are maintained. Updates to lulzbot.cfg will be maintained by the Lulzbot team and will take effect as long as the following line is located in printer.cfg.

```
[include lulzbot/include_files.cfg]
```

## Setup for AMOS

To setup lulzbot.cfg updates, run the following

```sh
cd ~
git clone https://github.com/lulzbot3d/lulzbot-config.git
cd lulzbot-config/
git switch AMOS_develop
ln -sf ~/lulzbot-config/lulzbot ~/printer_data/config/lulzbot
ln -sf ~/lulzbot-config/.theme ~/printer_data/config/.theme
```
### Add updater section

The last thing to add is the moonraker updater call out. This will keep you updated when new releases are avalible to load in.

Locate moonraker.conf on your machine and add the following...

```ini
[update_manager lulzbot-config]
type: git_repo
primary_branch: AMOS_develop
path: ~/lulzbot-config
origin: https://github.com/lulzbot3d/lulzbot-config.git
managed_services: klipper
```

### How to customize your settings

If you chose to customize your machine, copy the contents of lulzbot.cfg to printer.cfg and future updates will no longer overwrite your customized printer.

If you wish to customize just one section of any of the config files in the lulzbot folder you may copy just that section of the config file into printer.cfg, somewhere below the includes at the top, and make changes there.

This form of updates is inspired by the Mainsail-Crew with [mainsail.cfg](https://github.com/mainsail-crew/mainsail-config) updates.
