fluent-plugin-top
===

Fluentd input plugin for top command.

If you focus on system metrics rather than each process,
you should use [dstat plugin](https://github.com/shun0102/fluent-plugin-dstat).

## Configuration
    <source>
      @type top
      tag local.top       # *required*
      interval 30         # default: 10.0
      command_line true   # default: true
      extra_switch -w 200 # default: ""
      cpu_percent 50      # default: nil
    </source>

* **tag**: Output tag. [required]
* **interval**: Refresh interval in sec.
* **command_line**: Get command line (/usr/bin/ruby foo.rb -v) instead of simple name (ruby).
* **extra_switch**: Extra command line switch for top command.
* **cpu_percent**: Threshold - CPU usage (percent).
* **mem_percent**: Threshold - Memory usage (percent).
* **mem**: Threshold - Memory usage in megabytes.

At least one threshold parameter should be specified.
Otherwise, this plugin does not output anything.
If you specify multiple threshold parameters, they are "OR"ed.

<!--== Examples-->

<!--TODO: write here-->

## Copyright

Copyright (c) 2016 Tetsu Izawa (@moccos)

Apache License, Version 2.0
