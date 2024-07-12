# Complete this program so that it produces the expected output:
class Book
  attr_reader :author, :title

  def initialize(author, title)
    @author = author
    @title = title
  end

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new("Neil Stephenson", "Snow Crash")
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

# The author of "Snow Crash" is Neil Stephenson.
# book = "Snow Crash", by Neil Stephenson.

# Further Exploration
# What are the differences between attr_reader, attr_writer, and attr_accessor?
# Why did we use attr_reader instead of one of the other two?
# Would it be okay to use one of the others? Why or why not?
# attr_reader creates a getter method, attr_writer a setter method,
# and attr_accessor both. For this exercise, using attr_accessor would also work
# 
# Instead of attr_reader, suppose you had added the following methods to this class:
# def title
#   @title
# end

# def author
#   @author
# end

# This would have equivalent behavior to using attr_reader because attr_reader
# is shorthand for creating these getter methods. Writing the code in this way, though,
# does allow for more flexibility in case additional functionalality needed to be added
# beyond simple getting
