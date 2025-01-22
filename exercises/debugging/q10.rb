# We discovered Gary Bernhardt's repository for finding out
# whether something rocks or not, and decided to adapt it
# for a simple example.

class AuthenticationError < StandardError; end

# A mock search engine
# that returns a random number instead of an actual count.
class SearchEngine
  def self.count(query, api_key)
    unless valid?(api_key)
      raise AuthenticationError, 'API key is not valid.'
    end

    rand(200_000)
  end

  private

  def self.valid?(key)
    key == 'LS1A'
  end
end

module DoesItRock
  API_KEY = 'invalid_key'

  class NoScore; end

  class Score
    def self.for_term(term)
      positive = SearchEngine.count(%{"#{term} rocks"}, API_KEY)
      negative = SearchEngine.count(%{"#{term} is not fun"}, API_KEY)

      (positive * 100) / (positive + negative)
    rescue ZeroDivisionError
      NoScore.new
    end
  end

  def self.find_out(term)
    score = Score.for_term(term)

    case score
    when NoScore
      "No idea about #{term}..."
    when 0...40
      "#{term} is not fun."
    when 40...60
      "#{term} seems to be ok..."
    else
      "#{term} rocks!"
    end
  rescue StandardError => e
    e.message
  end
end

# Example (your output may differ)

puts DoesItRock.find_out('Sushi')       # Sushi seems to be ok...
puts DoesItRock.find_out('Rain')        # Rain is not fun.
puts DoesItRock.find_out('Bug hunting') # Bug hunting rocks!

# In order to test the case when authentication fails, we can simply set API_KEY
# to any string other than the correct key. Now, when using a wrong API key,
# we want our mock search engine to raise an AuthenticationError,
# and we want the find_out method to catch this error
# and print its error message API key is not valid.

# Is this what you expect to happen given the code?

# And why do we always get the following output instead?

# Sushi rocks!
# Rain rocks!
# Bug hunting rocks!

# When an invalid API_KEY is given and an AuthenticationError is raised
# in the DoesItRock::Score::for_term class method, the method's rescue clause
# returns the NoScore class, which is assigned to the score local variable
# in DoesItRock::find_out and used in the following case statement. The case
# statement uses the #=== method to compare each when clause, which will
# evaluate to false for the first when clause because the NoScore class
# is not an instance of the NoScore class. This can be fixed by instead
# returning a NoScore instance in the rescue clause of 
# DoesItRock::Score::for_term. Furthermore, the rescue clause in
# DoesItRock::find_out is never reached because the exception was already
# rescued in DoesItRock::Score::for_term, so the expected message cannot
# be output. This can be fixed by changing exception that the
# DoesItRock::Score::for_term catches to something more appropriate
# and specific, such as a ZeroDivisionError
