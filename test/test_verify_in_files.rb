require_relative 'helper'

module VerifyInFiles
  class Verifier
    module TestVerify

      class TestVerify< Test::Unit::TestCase

        def test_parse_yaml
          vif = Verifier.new
          top = vif.read_checks_and_rules "test/data/simple_rules.yaml"
          assert_not_equal( nil, top )
          puts top

          lines = Util.get_file_as_array( $LOREM_IPSUM )
          top.run( lines )
          assert_equal(true, top.result)
        end

      end

    end
  end
end
