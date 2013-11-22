module VerifyInFiles

  # Single rule to be checked against an input string.
  # A given pattern is expected NOT to exist in a specified string.
  class Not < Rule

    # Initialize rule with default that pattern is NOT expected
    def initialize( pattern_ = "" )
      self.pattern = pattern_
      self.should_exist = false
      self.result = false
    end

    # Check each string in string array against rule
    def check_array( lines )
      status = true
      lines.each { |line| status = false unless check_string(line) }
      return status
    end

  end
end
