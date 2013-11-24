require_relative 'helper'

module VerifyInFiles
  class Check
    module TestComplexChecks

      class TestAnd < Test::Unit::TestCase
        def setup
          @top = And.new
          @tier2and = And.new
          @tier2or = Or.new
        end

        def create_valid_tiers
          @top.rules << @tier2and
          @top.rules << @tier2or

          # tier2and rules (And)
          tier2and1 = Has.new( "consectetur" )
          tier2and2 = Has.new( "officia" )
          tier2and3 = Has.new( "euismod" )
          tier2and4 = Not.new( "doppleganger" )
          @tier2and.rules << tier2and1
          @tier2and.rules << tier2and2
          @tier2and.rules << tier2and3
          @tier2and.rules << tier2and4

          # tier2or rules (Or)
          tier2or1 = Has.new( "heffalumps" )
          tier2or2 = Not.new( "woozels" ) # True
          tier2or3 = Not.new( "Aliquam" )
          @tier2or.rules << tier2or1
          @tier2or.rules << tier2or2
          @tier2or.rules << tier2or3
        end

        def test_fail_on_and
          lines = Util.get_file_as_array( $LOREM_IPSUM )
          create_valid_tiers

          # Check results
          @top.run( lines )
          assert_equal(true, @top.result)

          # Add fail case to And leg
          tier2and5 = Has.new( "lkajsdklnmasdlkfj" )
          @tier2and.rules << tier2and5
          # Check results
          @top.run( lines )
          assert_equal(false, @top.result)
        end

      end
    end
  end
end

