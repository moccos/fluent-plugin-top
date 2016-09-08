require 'helper'

class TopInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    tag test.top
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::InputTestDriver.new(Fluent::TopInput).configure(conf)
  end

  # TODO: implement effective test
	def test_run
    d = create_driver(%[
      tag test.${hostname}.top
      interval 1
      mem_percent 0.5
      extra_switch -S -w 100
    ])
    d.run
    sleep(2.4)
    es = d.emits
    p es
	end

end

