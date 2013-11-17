module VerifyInFiles

  # Single rule to be checked against an input string.
  # A given pattern is expected to either exist or not exist
  # in a specified string.
  # The default behavior is that the specified pattern
  # should exist.
  class Rule
    attr_accessor :pattern, :should_exist, :result

    def initialize( pattern_ = "", should_exist_ = true )
      self.pattern = pattern_
      self.should_exist = should_exist_
      self.result = false
    end

    # Takes input string and checks if all rules are true
    def run( text )
      # Check if this rule already evaluated to true
      return if self.result == true
      # Check if input is empty
      return if self.pattern == ""

      if self.should_exist
        self.result = true if text.include?( self.pattern )
      else
        self.result = true unless text.include?( self.pattern )
      end
    end

  end
end
