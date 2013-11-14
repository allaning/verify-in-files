require_relative 'helper'

module VerifyInFiles
  class And
    module TestAnd
      $LOREM_IPSUM = "test/data/lorem_ipsum.txt"

      class TestAnd < Test::Unit::TestCase
        def setup
          @and = And.new
        end

        def test_create_and
          assert_equal([], @and.rules)
          assert_equal(false, @and.result)
        end

        def test_single_and_invalid
          # Call with string instead of string array
          @and.run( "" )
          assert_equal(false, @and.result)

          lines = Util.get_file_as_array( $LOREM_IPSUM )

          # Call without any rules defined
          @and.run( lines )
          assert_equal(false, @and.result)
        end

        def test_single_and_valid_found
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          @and.rules << Rule.new( "ipsum" )
          @and.run( lines )
          assert_equal(true, @and.result)

          @and = And.new
          @and.rules << Rule.new( "tempor" )
          @and.run( lines )
          assert_equal(true, @and.result)
        end

        def test_single_and_not_found
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          @and.rules << Rule.new( "should not be found" )
          @and.run( lines )
          assert_equal(false, @and.result)
        end

        def test_double_and_valid_found
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          @and.rules << Rule.new( "ipsum" )
          @and.rules << Rule.new( "gravida" )
          @and.run( lines )
          assert_equal(true, @and.result)

          @and = And.new
          @and.rules << Rule.new( "tempor" )
          @and.rules << Rule.new( "felis" )
          @and.run( lines )
          assert_equal(true, @and.result)
        end

        def test_double_and_valid_not_found
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          @and.rules << Rule.new( "ipsum" )
          @and.rules << Rule.new( "not so ipsum" )
          @and.run( lines )
          assert_equal(false, @and.result)

          @and = And.new
          @and.rules << Rule.new( "tempor" )
          @and.rules << Rule.new( "untemporumandum" )
          @and.run( lines )
          assert_equal(false, @and.result)
        end

      end
    end
  end
end

