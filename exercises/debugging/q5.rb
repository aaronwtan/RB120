# You started writing a very basic class for handling files. However,
# when you begin to write some simple test code, you get a NameError.
# The error message complains of an uninitialized constant File::FORMAT.

# What is the problem and what are possible ways to fix it?

class File
  attr_accessor :name, :byte_content

  def initialize(name)
    @name = name
  end

  alias_method :read,  :byte_content
  alias_method :write, :byte_content=

  def copy(target_file_name)
    target_file = self.class.new(target_file_name)
    target_file.write(read)

    target_file
  end

  def to_s
    "#{name}.#{self.class::FORMAT}"
  end
end

class MarkdownFile < File
  FORMAT = :md
end

class VectorGraphicsFile < File
  FORMAT = :svg
end

class MP3File < File
  FORMAT = :mp3
end

# Test

blog_post = MarkdownFile.new('Adventures_in_OOP_Land')
blog_post.write('Content will be added soon!'.bytes)

copy_of_blog_post = blog_post.copy('Same_Adventures_in_OOP_Land')

puts copy_of_blog_post.is_a? MarkdownFile     # true
puts copy_of_blog_post.read == blog_post.read # true

puts blog_post

# Calling puts on blog_post will call #to_s defined in the File
# superclass since none was defined in the MarkdownFile class.
# File#to_s references the FORMAT constant, which is not within lexical
# scope since it is not defined in the File class where it is referenced.
# To fix this, File#to_s can instead explicitly reference the specific class
# of the instance calling the method using self.class, then using
# the namespace resolution operator to reference the correct
# FORMAT constant
