About
=====
This plugin captures the FreeBSD gstat output and parses it.

Requirements
============
The Exec user for the plugin must have sudo access to this script. This can be done by a simple entry in the sudoers file.
```
    username ALL = (root) NOPASSWD: /usr/sbin/gstat
```

Installation
============

1. Add the content from the file `types.db` into your `types.db` or point to this `types.db` from inside the collectd config. Note that the collectd config can take multiple `TypesDB` entries.

```
    ...
    PluginDir   "${exec_prefix}/lib/collectd"
    TypesDB     "/usr/local/share/collectd/types.db"
    TypesDB	    "/usr/local/share/collectd-plugins/iostat/types.db"
    ...
```

2. Add the `iostat.conf.example` content to your collectd config.

Configuration of the Plugin
=============
the `Exec` command in the Plugin configuration accepts none, one or multiple arguments for devices to collect. The arguments are POSIX regexp.

No parameter will collect all available statistics, also such as fd0, cd0 etc.

```
    Exec "user" "../iostat.sh" "da" "pass"	
```
will collect *da* and *pass* devices, including partitions

```
    Exec "user" "../iostat.sh" "da[0-9]+$"
```
will only collect all "da" devices without partitions.


