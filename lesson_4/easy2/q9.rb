# If we have this class:
class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end
# What would happen if we added a play method to the Bingo class,
# keeping in mind that there is already a method of this name in the Game class
# that the Bingo class inherits from.
# The Bingo's #play method would override the one in the Game class, so
# that any Bingo object that calls #play would use Bingo#play instead
# of Game#play
