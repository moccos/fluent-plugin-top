require 'fluent/input'
require 'fluent/mixin/rewrite_tag_name'

module Fluent
  class TopInput < Fluent::Input
    Fluent::Plugin.register_input('top', self)
    config_param :tag, :string
    config_param :interval, :float, :default => 10.0
    config_param :get_command_line, :bool, :default => true
    include Fluent::Mixin::RewriteTagName

    def configure(conf)
      super
    end

    def start
      super
			# TODO: run top command here
    end

    def shutdown
    end
  end
end
