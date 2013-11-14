module VerifyInFiles

  # Each instance represents a check that should be done on an input file.
  # A check must contain one or more rules (e.g. the input file must contain
  # string A or string B).
  # Default behavior requires that all rules be true for the result to be true.
  class Check
    attr_accessor :rules, :result

    def initialize
      self.rules = []
      self.result = false
    end

    def clear_all_rules
      rules = []
    end

    def reset_rule_results
      rules.each { |rule| rule.result = false }
    end

    # Check if a single string matches the required rules
    def check_string( str )
      unless str.kind_of?(String)
        puts "check_string: Error: Input must be a string."
        return false
      end

      rules.each do |rule|
        # Run rules that did not already pass
        if rule.result == false
          rule.run( str )
        end
      end
    end

    # Takes input string or string array and checks if all rules are true
    def run( lines )
      unless rules.size > 0
        puts "run: Error: No rules defined."
        return false
      end

      # Check unfulfilled rules against input text
      if lines.kind_of?(String)
        check_string( lines )
      elsif lines.kind_of?(Array)
        reset_rule_results
        lines.each { |line| check_string( line ) }
      else
        puts "run: Received invalid input of type: #{lines.class?}"
        return false
      end

      # Check results
      self.result = true
      rules.each { |rule| self.result = false unless rule.result == true }
    end

  end
end
