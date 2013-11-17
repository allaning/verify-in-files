require_relative 'helper'

module VerifyInFiles
  class Or
    module TestComplexOr
      $LOREM_IPSUM = "test/data/lorem_ipsum.txt"

      class TestAnd < Test::Unit::TestCase
        def setup
          @top = Or.new
          @tier2 = Or.new
          @tier3 = Or.new
          @tier4 = Or.new
          @tier5 = Or.new
        end

        def create_five_invalid_tiers
          # First tier
          @top.rules << Rule.new( "Ruby" )
          # Second tier
          @tier2.rules << Rule.new( "Java" )
          @top.rules << @tier2
          # Third tier
          @tier3.rules << Rule.new( "CPlusPlus" )
          @tier2.rules << @tier3
          # Add fourth tier
          @tier4.rules << Rule.new( "Python" )
          @tier3.rules << @tier4
          # Add fifth tier
          @tier5.rules << Rule.new( "Javascript" )
          @tier4.rules << @tier5
        end

        def test_five_tiers_fail_on_third
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          create_five_invalid_tiers
          # Check results
          @top.run( lines )
          assert_equal(false, @top.result)

          # Add valid rule to third tier
          tier3b = Rule.new( "tempor" )
          @tier2.rules << tier3b
          # Check results
          @top.run( lines )
          assert_equal(true, @top.result)
        end

      end
    end
  end
end

