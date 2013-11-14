require_relative 'helper'

module VerifyInFiles
  class Check
    module TestCheck
      $LOREM_IPSUM = "test/data/lorem_ipsum.txt"

      class TestCheck < Test::Unit::TestCase
        def setup
          @check = Check.new
        end

        def test_create_check
          assert_equal([], @check.rules)
          assert_equal(false, @check.result)
        end

        def test_single_check_invalid
          # Call with emptry string
          @check.run( "" )
          assert_equal(false, @check.result)

          lines = Util.get_file_as_array( $LOREM_IPSUM )

          # Call without any rules defined
          @check.run( lines )
          assert_equal(false, @check.result)
        end

        def test_single_check_valid_found
          @check.rules << Rule.new( "hello" )
          @check.run( "hello there" )
          assert_equal(true, @check.result)

          lines = Util.get_file_as_array( $LOREM_IPSUM )

          @check = Check.new
          @check.rules << Rule.new( "ipsum" )
          @check.run( lines )
          assert_equal(true, @check.result)

          @check = Check.new
          @check.rules << Rule.new( "tempor" )
          @check.run( lines )
          assert_equal(true, @check.result)
        end

        def test_single_check_not_found
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          @check.rules << Rule.new( "should not be found" )
          @check.run( lines )
          assert_equal(false, @check.result)
        end

        def test_single_check_should_not_exist
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          @check.rules << Rule.new( "should not be found", false )
          @check.run( lines )
          assert_equal(true, @check.result)
        end

      end
    end
  end
end

