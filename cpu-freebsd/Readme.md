About
=====
This plugin captures various CPU Information (temperature, clockspeed) from FreeBSD sysctl variables.

Requirements
============
The Exec user for the plugin must have sudo access to this script. This can be done by a simple entry in the sudoers file.
```
    username ALL = (root) NOPASSWD: /sbin/sysctl
```

The *coretemp* module for FreeBSD must be loaded.
You can load the coretemp module at runtime with:
```
    $ kldload coretemp
```
To have *coretemp* load on each reboot, you should add the following entry to the `/boot/loader.conf` file:
```
    coretemp_load="YES"`
```

Installation
============

Add the `cpu.conf.example` content to your collectd config.

Configuration of the Plugin
=============

No further configuration is needed.