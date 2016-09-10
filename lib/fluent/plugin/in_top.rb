require 'thread'
require 'fluent/input'
require 'fluent/mixin/rewrite_tag_name'
require_relative 'in_top_parser'

module Fluent
  class TopInput < Fluent::Input
    INTERVAL_MIN = 0.5 # avoid too short interval

    Fluent::Plugin.register_input('top', self)
    desc "Top command. Don't forget to specify batch switch (-b)."
    config_param :top, :string, :default => "top -b"
    desc 'Output tag.'
    config_param :tag, :string

    ### Command line options
    desc 'Refresh interval. (top -d)'
    config_param :interval, :float, :default => 10.0
    desc 'Get command line. (top -c)'
    config_param :command_line, :bool, :default => true
    desc 'Extra command line args for top command.'
    config_param :extra_switch, :string, :default => ""

    ### Conditions
    desc "Threshold - CPU usage (percent)."
    config_param :cpu_percent, :float, :default => nil
    desc "Threshold - Memory usage (percent)."
    config_param :mem_percent, :float, :default => nil
    desc "Threshold - Memory usage in megabytes."
    config_param :mem, :integer, :default => nil

    ### Future works
    #config_param :cpu_rank, :integer, :default => nil
    #config_param :pid, :array, :default => []
    #config_param :pid_file, :array, :default => []
    #config_param :pid_file_watch_interval, :int, :default => 30

    desc 'Command line and args. This overrides other settings.'
    config_param :test_cmd, :string, :default => nil

    # for fluent-mixin-rewrite-tag-name
    include Fluent::Mixin::RewriteTagName
    desc 'Command to get hostname. Typically it is "hostname" or "hostname -s".'
    config_param :hostname_command, :string, :default => "hostname"

    def configure(conf)
      super
      interval = @interval > INTERVAL_MIN ? @interval : INTERVAL_MIN
      @top_command =
        if @test_cmd then
          @test_cmd
        else
          "#{@top} -d #{interval} #{@command_line ? "-c" : ""} #{@extra_switch}"
        end
    end

    def start
      super
      @top_thread = Thread.new do
        begin
          run_top()
        rescue => e
          puts e.to_s
        end
      end
    end

    def shutdown
      super
      $log.trace "Shutdown top command thread."
      @top_thread.kill if @top_thread
    end

    private
    def run_top
      $log.trace "Top command thread is running: " + @top_command
			IO.popen(@top_command, "r") {|io|
        parser = Fluent::TopInputParser.new()
				io.each {|line|
          result, ps = parser.parse(line)
          if result && check_ps_info(ps) then
            ps.args = ps.args.join(' ')
            emit_message(@tag, ps)
          end
				}
			}
      $log.warn "Exit top command thread. (reached EOF)"
    end

    def check_ps_info(ps)
      # For now, all conditions are "OR"ed
      case
      when @cpu_percent && ps.cpu >= @cpu_percent
        true
      when @mem_percent && ps.mem >= @mem_percent
        true
      when @mem && ps.res >= @mem * 1024 # megabytes
        true
      else
        false
      end
    end

    def emit_message(tag, message)
      time = Engine.now
      # for fluent-mixin-rewrite-tag-name
      emit_tag = tag.dup
      filter_record(emit_tag, time, message)
      router.emit(emit_tag, time, message)
    end
  end
end
