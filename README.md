fluent-plugin-top
===

Fluentd input plugin for top command.

## Configuration
    <source>
      type top
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

<!--== Examples-->

<!--TODO: write here-->

== Copyright

Copyright:: Copyright (c) 2016 IZAWA Tetsu (@moccos)

License:: Apache License, Version 2.0
