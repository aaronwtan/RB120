# You are given the following code:
class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

# What is the result of executing the following code:
oracle = Oracle.new
oracle.predict_the_future
# The Oracle object oracle calls the instance method #predict_the_future
# which will return the string "You will " concatenated with the return of
# choices.sample, which will be a random string sampled from the array
# returned from calling the #choices instance method
