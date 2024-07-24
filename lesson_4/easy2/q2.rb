# We have an Oracle class and a RoadTrip class
# that inherits from the Oracle class.
class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

# What is the result of the following:
trip = RoadTrip.new
p trip.predict_the_future
# Since the RoadTrip class inherits from the Oracle class and has
# its own #choices instance method defined, RoadTrip objects will
# invoke RoadTrip#choices instead and override Oracle#choices
# when the #predict_the_future instance method is called.
# Oracle#predict_the_future is still available to the RoadTrip object
# assigned to trip because RoadTrip inherits from Oracle,
# but since #predict_the future is called on an instance of RoadTrip
# the strings used to evaluate choices.sample will be taken from
# the array returned by the RoadTrip#choices method rather
# than Oracle#choices as before
