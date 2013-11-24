module VerifyInFiles

  # Single rule to be checked against an input string.
  # A given pattern is expected to either exist or not exist
  # in a specified string.
  # The default behavior is that the specified pattern
  # should exist.
  class Rule
    @@DEBUG = false
    attr_accessor :pattern, :result

    def initialize( pattern_ = "" )
      self.pattern = pattern_
      self.result = false
    end

    # Return true if input is a String; Else, print error and return false
    def validate_string( str )
      if str.kind_of?(String)
        return true
      else
        puts "#{self.class}:check_string: Error: Input must be a string."
        return false
      end
    end

    # Check if a single string matches the required rules
    def check_string( str )
      result = false
      return result unless validate_string(str)

      if str.include?( self.pattern )
        result = true
      end
      return result
    end

    # Check each string in string array against rule
    def check_array( lines )
      status = false
      lines.each { |line| status = true if check_string(line) }
      return status
    end

    # Takes input text and check against rule
    def run( lines )
      # Check if this rule already evaluated to true
      return if self.result == true
      # Check if input is empty
      return if self.pattern == ""

      if lines.kind_of?(String)
        self.result = check_string( lines )
      elsif lines.kind_of?(Array)
        self.result = check_array( lines )
      else
        puts "#{self.class}:run: Received invalid input of type: #{lines.class}"
        return false
      end

      puts "#{self.result.to_s.upcase}: #{self.class}: #{self.pattern}" if @@DEBUG == true
    end

    def to_s
      "Rule: #{pattern}"
    end

  end
end
