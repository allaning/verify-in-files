module VerifyInFiles

  # Single rule to be checked against an input string.
  # A given pattern is expected to exist in a specified string.
  class Has < Rule

    def initialize( pattern_ = "" )
      self.pattern = pattern_
      self.should_exist = true
      self.result = false
    end

  end
end
