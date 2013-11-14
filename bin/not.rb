module VerifyInFiles

  # Single rule to be checked against an input string.
  # A given pattern is expected NOT to exist in a specified string.
  class Not < Rule

    def initialize( pattern_ = "" )
      self.pattern = pattern_
      self.should_exist = false
      self.result = false
    end

    # Takes input string and checks if rule is true
    def run( text )
      return !super( text )
    end

  end
end
