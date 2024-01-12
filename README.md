# Lulzbot klipper macros and settings

Here is where the configuration files of stock Lulzbot machines are maintained. Updates to lulzbot.cfg will be maintained by the Lulzbot team and will take effect as long as the following line is located in printer.cfg.

```
[include lulzbot.cfg]
```

# Setup

to setup lulzbot.cfg updates, run the following

```sh
cd ~
git clone https://github.com/lulzbot3d/lulzbot-config.git
ln -sf ~/lulzbot-config/lulzbot.cfg ~/printer_data/config/lulzbot.cfg
ln -sf ~/lulzbot-config/.macro.cfg ~/printer_data/config/.macro.cfg
ln -sf ~/lulzbot-config/.tool_heads.cfg ~/printer_data/config/.tool_heads.cfg
```

This will clone the lulzbot-config repository to your machine and then create a lulzbot.cfg file which will be used for all future updates.

### How to customize your settings

If you chose to customize your machine, copy the contents of lulzbot.cfg to printer.cfg and future updates will no longer overwrite your customized printer.


This form of updates is inspired by the Mainsail-Crew with [mainsail.cfg](https://github.com/mainsail-crew/mainsail-config) updates.
