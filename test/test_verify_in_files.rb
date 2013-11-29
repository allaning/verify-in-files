require_relative 'helper'

module VerifyInFiles
  class Verifier
    module TestVerify

      class TestVerify < Test::Unit::TestCase

        def test_parse_json
          vif = Verifier.new
          top = vif.read_checks_and_rules "test/data/simple_rules.json"
          assert_not_equal( nil, top )

          lines = Util.get_file_as_array( $LOREM_IPSUM )
          top.run( lines )
          assert_equal(true, top.result)
        end

        def test_parse_yaml
          vif = Verifier.new
          top = vif.read_checks_and_rules "test/data/simple_rules.yml"
          assert_not_equal( nil, top )

          lines = Util.get_file_as_array( $LOREM_IPSUM )
          top.run( lines )
          assert_equal(true, top.result)

          top.rules << Not.new("ohayoogozaimasu")
          top.run( lines )
          assert_equal(true, top.result)

          top.rules << Has.new("felis")
          top.run( lines )
          assert_equal(true, top.result)

          top.rules << Not.new("gravida")
          top.run( lines )
          assert_equal(false, top.result)
        end

      end

    end
  end
end
