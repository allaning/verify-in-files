require_relative 'helper'

module VerifyInFiles
  class Not
    module TestNot

      class TestNot < Test::Unit::TestCase
        def setup
          @not_rule = Not.new
        end

        def test_create_not_rule
          assert_equal("", @not_rule.pattern)
          assert_equal(false, @not_rule.result)
        end

        def test_single_not_rule_true
          text = "somewhere over the rainbow"

          @not_rule.pattern = "hello"
          @not_rule.run( text )
          assert_equal(true, @not_rule.result)

          @not_rule.pattern = "there"
          @not_rule.result = false
          @not_rule.run( text )
          assert_equal(true, @not_rule.result)
        end

        def test_single_not_rule_false
          text = "lorem ipsum"
          @not_rule.pattern = "lorem"
          @not_rule.run( text )
          assert_equal(false, @not_rule.result)

          @not_rule.pattern = "ipsum"
          @not_rule.result = false
          @not_rule.run( text )
          assert_equal(false, @not_rule.result)
        end

      end
    end
  end
end

