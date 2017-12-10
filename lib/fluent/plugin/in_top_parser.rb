module Fluent
  class TopInputParser
    ### state
    STATE_HEADER  = 1
    STATE_PROCESS = 2

    @@PS_INFO = Struct.new(:pid, :user, :res, :cpu, :mem, :cmd, :args)

    def initialize()
      reset_state
    end

    def parse(line)
      case @state
      when STATE_HEADER then
        return parse_header line
      else
        return parse_process line
      end
    end

    private
    def reset_state()
      @state = STATE_HEADER
    end

    def parse_header(line)
      #  PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
      #    1 root      20   0   38004   5992   3916 S  0.0  0.6   0:03.43 systemd

      ss = line.split("\s")
      @state = STATE_PROCESS if ss[0] == "PID"
      return false, nil
    end

    def parse_process(line)
      ss = line.split("\s")
      if !is_number?(ss[0]) then
        reset_state
        return parse_header(line)
      end
      begin
        pid, user, _pr, _ni, _virt, res, _shr, _s, cpu, mem, _time, cmd = ss
        args = ss.drop(12)
        return true, @@PS_INFO.new(pid.to_i, user, parse_unit(res), cpu.to_f, mem.to_f, cmd, args)
      rescue => e
        $log.warn "parse error #{e.to_s}: " + line
        reset_state
        return false, nil
      end
    end

    def is_number?(s)
      begin
        Float(s)
        true
      rescue
        false
      end
    end

    def parse_unit(s)
      begin 
        case s[-1].downcase
        when "g"  # Giga-byte
          (s[0, s.length-1].to_f * 1024 * 1024).to_i
        when "m"  # Mega-byte
          (s[0, s.length-1].to_f * 1024).to_i
        else
          s.to_i
        end
      rescue
        $log.warn "Memory unit parse error: " + s
        -1
      end
    end
  end
end
