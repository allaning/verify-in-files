require_relative 'helper'

module VerifyInFiles
  class Has
    module TestHas

      class TestHas < Test::Unit::TestCase
        def setup
          @has_rule = Has.new
        end

        def test_create_has_rule
          assert_equal("", @has_rule.pattern)
          assert_equal(true, @has_rule.should_exist)
          assert_equal(false, @has_rule.result)
        end

        def test_single_has_rule_true
          text = "lorem ipsum"
          @has_rule.pattern = "lorem"
          @has_rule.run( text )
          assert_equal(true, @has_rule.result)

          @has_rule.pattern = "ipsum"
          @has_rule.run( text )
          assert_equal(true, @has_rule.result)
        end

        def test_single_has_rule_false
          text = "somewhere over the rainbow"

          @has_rule.pattern = "hello"
          @has_rule.run( text )
          assert_equal(false, @has_rule.result)

          @has_rule.pattern = "there"
          @has_rule.run( text )
          assert_equal(false, @has_rule.result)
        end

      end
    end
  end
end

