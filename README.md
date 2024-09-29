# koha-plugin-pomodoro

This project is just a demo for my koha-plugin scaffolding tool [pders01/koha-plugin](https://github.com/pders01/koha-plugin) at the moment.

It does work, though 😃


## Badges

[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)


## Installation

### Plugins within Koha

Koha's Plugin System allows for you to add additional tools and reports to Koha that are specific to your library.
Plugins are installed by uploading KPZ ( Koha Plugin Zip ) packages.
A KPZ file is just a zip file containing the perl files, template files, and any other files necessary to make the plugin work.

The plugin system needs to be turned on by a system administrator.

To set up the Koha plugin system you must first make some changes to your install.

* Change `<enable_plugins>0<enable_plugins>` to `<enable_plugins>1</enable_plugins>` in your koha-conf.xml file
* Confirm that the path to `<pluginsdir>` exists, is correct, and is writable by the web server
* Restart your webserver

Once set up is complete you will need to alter your UseKohaPlugins system preference. On the Tools page you will see the Tools Plugins and on the Reports page you will see the Reports Plugins.

### KPZ

You can download the kpz file [here](https://github.com/pders01/koha-plugin-pomodoro/releases).

### Note

For this one to work, you'll need to restart plack:
```console
$ koha-plack --restart <INSTANCE>
```

## License

[GPL v3](https://github.com/pders01/koha-plugin?tab=GPL-3.0-1-ov-file#readme)
