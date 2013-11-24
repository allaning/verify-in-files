module VerifyInFiles

  # Single rule to be checked against an input string.
  # A given pattern is expected NOT to exist in a specified string.
  class Not < Rule

    # Initialize rule with default that pattern is NOT expected
    def initialize( pattern_ = "" )
      self.pattern = pattern_
      self.result = false
    end

    # Check if a single string matches the required rules
    def check_string( str )
      result = false
      return result unless validate_string(str)

      unless str.include?( self.pattern )
        result = true
      end
      return result
    end

    # Check each string in string array against rule
    def check_array( lines )
      status = true
      lines.each { |line| status = false unless check_string(line) }
      return status
    end

    def to_s
      "Not: #{pattern}"
    end

  end
end
