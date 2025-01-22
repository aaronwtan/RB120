# A circular buffer is a collection of objects stored in a buffer
# that is treated as though it is connected end-to-end in a circle.
# When an object is added to this circular buffer, it is added
# to the position that immediately follows the most recently added object,
# while removing an object always removes the object that has been
# in the buffer the longest.

# This works as long as there are empty spots in the buffer.
# If the buffer becomes full, adding a new object to the buffer requires
# getting rid of an existing object; with a circular buffer,
# the object that has been in the buffer the longest is discarded
# and replaced by the new object.

# Assuming we have a circular buffer with room for 3 objects,
# the circular buffer looks and acts like this:
# P1	P2	P3	Comments
#             All positions are initially empty
# 1			      Add 1 to the buffer
# 1	  2		    Add 2 to the buffer
#     2		    Remove oldest item from the buffer (1)
#     2	  3	  Add 3 to the buffer
# 4	  2	  3	  Add 4 to the buffer, buffer is now full
# 4		    3	  Remove oldest item from the buffer (2)
# 4	  5	  3	  Add 5 to the buffer, buffer is full again
# 4	  5	  6	  Add 6 to the buffer, replaces oldest element (3)
# 7 	5	  6	  Add 7 to the buffer, replaces oldest element (4)
# 7		    6	  Remove oldest item from the buffer (5)
# 7			      Remove oldest item from the buffer (6)
#             Remove oldest item from the buffer (7)
#             Remove non-existent item from the buffer (nil)

# Your task is to write a CircularBuffer class that implements a circular buffer
# for arbitrary objects. The class should obtain the buffer size
# with an argument provided to CircularBuffer::new,
# and should provide the following methods:

# - put to add an object to the buffer
# - get to remove (and return) the oldest object in the buffer. It should return
#   nil if the buffer is empty.

# You may assume that none of the values stored in the buffer are nil
# (however, nil may be used to designate empty spots in the buffer).

=begin
P
input: buffer size
output: circular buffer object

E
[nil, nil, nil] write idx: 0    , read idx: 0
[1, nil, nil]   write idx: 1 put, read idx: 0
[1, 2, nil]     write idx: 2 put, read idx: 0
[nil, 2, nil]   write idx: 2 get, read idx: 1
[nil, 2, 3]     write idx: 0 put, read idx: 1
[4, 2, 3]       write idx: 1 put, read idx: 1 (full)
[4, nil, 3]     write idx: 1 get, read idx: 2
[4, 5, 3]       write idx: 2 put, read idx: 2 (full)
[4, 5, 6]       write idx: 0 put, read idx: 0 (full)
[7, 5, 6]       write idx: 1 put, read idx: 1 (full)
[7, nil, 6]     write idx: 1 get, read idx: 2
[7, nil, nil]   write idx: 1 get, read idx: 0
[nil, nil, nil] write idx: 1 get, read idx: nil

D
- Array can keep track of objects and indices
- Need to increment index that keeps track of position
to add next object
- Need to keep track of index to retrieve object
to return and delete from buffer

A

C
=end

# class CircularBuffer
#   def initialize(size)
#     @size = size
#     @buffer = Array.new(size)
#     @write_idx = 0
#     @read_idx = 0
#   end

#   def put(object)
#     self.read_idx = (read_idx + 1) % size unless buffer[write_idx].nil?

#     buffer[write_idx] = object
#     self.write_idx = (write_idx + 1) % size
#   end

#   def get
#     value = buffer[read_idx]
#     buffer[read_idx] = nil
#     self.read_idx = (read_idx + 1) % size unless value.nil?
#     value
#   end

#   private

#   attr_accessor :write_idx, :read_idx
#   attr_reader :size, :buffer
# end

# Further Exploration
class CircularBuffer
  def initialize(max_size)
    @max_size = max_size
    @buffer = Array.new
  end

  def put(object)
    get if full?
    buffer.push(object)
  end

  def get
    buffer.shift
  end

  private

  attr_reader :max_size, :buffer

  def full?
    buffer.size == max_size
  end
end

# Examples:
buffer = CircularBuffer.new(3)
puts buffer.get == nil

buffer.put(1)
buffer.put(2)
puts buffer.get == 1

buffer.put(3)
buffer.put(4)
puts buffer.get == 2

buffer.put(5)
buffer.put(6)
buffer.put(7)
puts buffer.get == 5
puts buffer.get == 6
puts buffer.get == 7
puts buffer.get == nil

buffer = CircularBuffer.new(4)
puts buffer.get == nil

buffer.put(1)
buffer.put(2)
puts buffer.get == 1

buffer.put(3)
buffer.put(4)
puts buffer.get == 2

buffer.put(5)
buffer.put(6)
buffer.put(7)
puts buffer.get == 4
puts buffer.get == 5
puts buffer.get == 6
puts buffer.get == 7
puts buffer.get == nil

# The above code should display true 15 times.
