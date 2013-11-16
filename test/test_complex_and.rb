require_relative 'helper'

module VerifyInFiles
  class And
    module TestComplexAnd
      $LOREM_IPSUM = "test/data/lorem_ipsum.txt"

      class TestAnd < Test::Unit::TestCase
        def setup
          @top = And.new
        end

        def test_two_tier_till_fail_on_first
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          # First tier
          @top.rules << Rule.new( "esse" )
          @top.rules << Rule.new( "elit" )
          # Second tier
          child = And.new
          child.rules << Rule.new( "lacus" )
          child.rules << Rule.new( "arcu" )
          child.rules << Rule.new( "augue" )
          @top.rules << child
          # Check results
          @top.run( lines )
          assert_equal(true, @top.result)

          # Add to first tier
          @top.rules << Rule.new( "nulla" )
          @top.rules << Rule.new( "Cras" )
          # Add to second tier
          child.rules << Rule.new( "Etiam" )
          child.rules << Rule.new( "quam" )
          # Check results
          @top.run( lines )
          assert_equal(true, @top.result)

          # Add invalid to second tier
          @top.rules << Rule.new( "blah blah blah" )
          # Check results
          @top.run( lines )
          assert_equal(false, @top.result)
        end

        def test_two_tier_till_fail_on_second
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          # First tier
          @top.rules << Rule.new( "ipsum" )
          @top.rules << Rule.new( "gravida" )
          # Second tier
          child = And.new
          child.rules << Rule.new( "tempor" )
          child.rules << Rule.new( "consequat" )
          child.rules << Rule.new( "fermentum" )
          @top.rules << child
          # Check results
          @top.run( lines )
          assert_equal(true, @top.result)

          # Add to first tier
          @top.rules << Rule.new( "sapien" )
          @top.rules << Rule.new( "Integer" )
          # Add to second tier
          child.rules << Rule.new( "eget" )
          child.rules << Rule.new( "mollis" )
          # Check results
          @top.run( lines )
          assert_equal(true, @top.result)

          # Add to second tier
          child.rules << Rule.new( "varius" )
          child.rules << Rule.new( "nostrud" )
          # Check results
          @top.run( lines )
          assert_equal(true, @top.result)

          # Add invalid to second tier
          child.rules << Rule.new( "blah blah blah" )
          # Check results
          @top.run( lines )
          assert_equal(false, @top.result)
        end

      end
    end
  end
end

