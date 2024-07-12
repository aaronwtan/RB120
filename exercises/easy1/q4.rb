# Complete this program so that it produces the expected output:
class Book
  attr_accessor :author, :title

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new
book.author = "Neil Stephenson"
book.title = "Snow Crash"
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

# Expected output:
# The author of "Snow Crash" is Neil Stephenson.
# book = "Snow Crash", by Neil Stephenson.

# Further Exploration
# What do you think of this way of creating and initializing Book objects? (The two steps are separate.)
# Would it be better to create and initialize at the same time like in the previous exercise?
# What potential problems, if any, are introduced by separating the steps?
# Creating and initializing at the same time is usually more advantageous because
# this encapsulates behavior into the Book objects instead of having them be more disjointed.
# This makes it far easier to maintain and also serves as a way of organizing otherwise
# random lines of code
