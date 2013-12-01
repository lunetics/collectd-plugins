About
=====
This plugin captures various sensor informations from the `ipmitool sensor` output.

Requirements
============
The Exec user for the plugin must have sudo access to this script. This can be done by a simple entry in the sudoers file.
```
    username ALL = (root) NOPASSWD: /usr/local/sbin/ipmitool
```

The package/port "sysutils/ipmitool" must be installed prior to use.

Installation
============

Add the `cpu.conf.example` content to your collectd config.

Configuration of the Plugin
=============

No further configuration is needed.