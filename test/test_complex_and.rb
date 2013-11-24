require_relative 'helper'

module VerifyInFiles
  class And
    module TestComplexAnd

      class TestAnd < Test::Unit::TestCase
        def setup
          @top = And.new
          @tier2 = And.new
          @tier3 = And.new
          @tier4 = And.new
          @tier5 = And.new
        end

        def create_five_valid_tiers
          # First tier
          @top.rules << Rule.new( "ipsum" )
          # Second tier
          @tier2.rules << Rule.new( "tempor" )
          @top.rules << @tier2
          # Third tier
          @tier3.rules << Rule.new( "Donec" )
          @tier2.rules << @tier3
          # Add fourth tier
          @tier4.rules << Rule.new( "sem" )
          @tier3.rules << @tier4
          # Add fifth tier
          @tier5.rules << Rule.new( "magna" )
          @tier4.rules << @tier5
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

          # Add second child
          child2 = And.new
          child2.rules << Rule.new( "erat" )
          child2.rules << Rule.new( "risus" )
          @top.rules << child2
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

          # Add second child
          child2 = And.new
          child2.rules << Rule.new( "dictum" )
          child2.rules << Rule.new( "neque" )
          @top.rules << child2
          assert_equal(true, @top.result)

          # Add invalid to second tier
          child.rules << Rule.new( "blah blah blah" )
          # Check results
          @top.run( lines )
          assert_equal(false, @top.result)
        end

        def test_two_tier_wide
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          # First tier
          @top.rules << Rule.new( "gravida" )

          # Add to second tier
          child1 = And.new
          child1.rules << Rule.new( "vulputate" )
          @top.rules << child1
          child2 = And.new
          child2.rules << Rule.new( "congue" )
          @top.rules << child2
          child3 = And.new
          child3.rules << Rule.new( "felis" )
          @top.rules << child3
          child4 = And.new
          child4.rules << Rule.new( "aliquet" )
          @top.rules << child4
          child5 = And.new
          child5.rules << Rule.new( "commodo" )
          @top.rules << child5
          child6 = And.new
          child6.rules << Rule.new( "nisl" )
          @top.rules << child6
          child7 = And.new
          child7.rules << Rule.new( "abitur" )
          @top.rules << child7
          child8 = And.new
          child8.rules << Rule.new( "laoreet" )
          @top.rules << child8
          child9 = And.new
          child9.rules << Rule.new( "magna" )
          @top.rules << child9
          child10 = And.new
          child10.rules << Rule.new( "orci" )
          @top.rules << child10

          # Check results
          @top.run( lines )
          assert_equal(true, @top.result)

          # Add invalid, then valid
          child11 = And.new
          child11.rules << Rule.new( "foo bar" )
          @top.rules << child11
          child12 = And.new
          child12.rules << Rule.new( "eget" )
          @top.rules << child12

          # Check results
          @top.run( lines )
          assert_equal(false, @top.result)
        end

        def test_three_tier_till_fail_on_third
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          # First tier
          @top.rules << Rule.new( "ipsum" )
          # Second tier
          child1 = And.new
          child1.rules << Rule.new( "tempor" )
          @top.rules << child1
          # Third tier
          child2 = And.new
          child2.rules << Rule.new( "Donec" )
          child1.rules << child2
          # Check results
          @top.run( lines )
          assert_equal(true, @top.result)

          # Add invalid to third tier
          child2b = And.new
          child2b.rules << Rule.new( "Happy Birthday" )
          child1.rules << child2b
          # Check results
          @top.run( lines )
          assert_equal(false, @top.result)
        end

        def test_five_tier_till_fail_on_third
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          create_five_valid_tiers
          # Check results
          @top.run( lines )
          assert_equal(true, @top.result)

          # Add invalid to third tier
          tier3b = And.new
          tier3b.rules << Rule.new( "googleplex" )
          @tier2.rules << tier3b
          # Check results
          @top.run( lines )
          assert_equal(false, @top.result)
        end

        def test_five_tier_till_fail_on_fifth
          lines = Util.get_file_as_array( $LOREM_IPSUM )

          create_five_valid_tiers

          # Add invalid to fifth tier
          tier5b = And.new
          tier5b.rules << Rule.new( "Happy Birthday" )
          @tier4.rules << tier5b
          # Check results
          @top.run( lines )
          assert_equal(false, @top.result)
        end

      end
    end
  end
end

