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

	def test_run
    d = create_driver(%[
      tag test.${hostname}.top
      interval 1
      mem_percent 0.5
      extra_switch -S -w 100
    ])
    d.run
    sleep(1.5)
	end

  def test_parse
    d = create_driver(%[
      tag test.${hostname}.top
      interval 1
      mem_percent 0.1
      test_cmd cat ./test/top_output_sample_1
    ])
    d.run
    sleep(0.5)

    es = d.emits
    assert(es.length > 0)

    # TODO: check result
    #es.take(3).each {|e|
      #p e
    #}
  end
end
