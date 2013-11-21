require_relative 'helper'

module VerifyInFiles
  class Rule
    module TestRule

      class TestRule < Test::Unit::TestCase
        def setup
          @rule = Rule.new
        end

        def test_create_rule
          assert_equal("", @rule.pattern)
          assert_equal(true, @rule.should_exist)
          assert_equal(false, @rule.result)
        end

        def test_single_rule_true
          text = "lorem ipsum"
          @rule.pattern = "lorem"
          @rule.run( text )
          assert_equal(true, @rule.result)

          @rule.pattern = "ipsum"
          @rule.result = false
          @rule.run( text )
          assert_equal(true, @rule.result)
        end

        def test_single_rule_false
          text = "somewhere over the rainbow"

          @rule.pattern = "hello"
          @rule.run( text )
          assert_equal(false, @rule.result)

          @rule.pattern = "there"
          @rule.result = false
          @rule.run( text )
          assert_equal(false, @rule.result)
        end

      end
    end
  end
end

