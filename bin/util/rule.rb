module VerifyInFiles

  # Single rule to be checked against an input string.
  # A given pattern is expected to either exist or not exist
  # in a specified string.
  # The default behavior is that the specified pattern
  # should exist.
  class Rule
    @@DEBUG = false
    attr_accessor :pattern, :should_exist, :result

    def initialize( pattern_ = "", should_exist_ = true )
      self.pattern = pattern_
      self.should_exist = should_exist_
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
      return false unless validate_string(str)

      if self.should_exist
        return true if str.include?( self.pattern )
      else
        return true unless str.include?( self.pattern )
      end
      return false
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

  end
end
