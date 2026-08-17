# Lulzbot klipper macros and settings

Here is where the configuration files of stock LulzBot machines are maintained.

Updates to lulzbot.cfg will be maintained by the LulzBot team and will take effect as long as the following line is located in printer.cfg.


```ini
[include lulzbot/include_files.cfg]
```

### How to customize your settings

If you chose to customize your machine, copy the contents of lulzbot.cfg to printer.cfg and future updates will no longer overwrite your customized printer.
If you wish to customize just one section of any of these config files you may copy that section from lulzbot.cfg to printer.cfg and make changes there.

### Branch Usage

- main: Not used currently for any LulzBot printer.
- mini3_stable: Production LulzBot Mini3 printers should be on this branch.
- develop: Used for R&D development of LulzBot Mini3 configurations.
- AMOS_main: Main branch for the LulzBot version of the AMOS printer.
- AMOS_develop: Used for R&D development of the LulzBot version of the AMOS printer.
- Symlink_folder: An old branch used when developing the symbolic link configuration method. Should not be used anymore. Will not receive updates.
- Mini3_config: An old branch some early Mini3 printers were on. Should not be used anymore. Will not receive updates.
