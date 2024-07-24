# If we have this class:
class Game
  def play
    "Start the game!"
  end
end

# And another class:
class Bingo < Game
  def rules_of_play
    #rules of play
  end
end

bingo = Bingo.new
puts bingo.play
# What can we add to the Bingo class to allow it
# to inherit the play method from the Game class?
