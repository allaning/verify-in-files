module VerifyInFiles

  # Each instance represents a check that should be done on an input file.
  # A check must contain one or more rules (e.g. the input file must contain
  # string A or string B).  If all rules are true, then the result is true.
  class Check
    attr_accessor :rules, :result

    def initialize
      self.rules = []
      self.result = false
    end

    def reset_rule_results
      rules.each { |rule| rule.result = false }
    end

    # Takes input string array and checks if all rules are true
    def run( lines )
      unless lines.kind_of?(Array)
        puts "run: Error: Input must be an array of strings."
        return false
      end
      unless rules.size > 0
        puts "run: Error: No rules defined."
        return false
      end

      # Check unfulfilled rules against input text
      reset_rule_results
      lines.each do |line|
        rules.each do |rule|
          # Run rules that did not already pass
          if rule.result == false
            rule.run( line )
          end
        end
      end

      # Check results
      self.result = true
      rules.each { |rule| self.result = false unless rule.result == true }
    end

  end
end
