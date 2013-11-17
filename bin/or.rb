module VerifyInFiles

  # Similar to a boolean-OR, all checks within this class
  # must equate to true for result to be true.
  class Or < Check

    # Check if at least one rule was true
    def check_results
      self.result = false
      rules.each { |rule| self.result = true if rule.result == true }
    end

  end
end
