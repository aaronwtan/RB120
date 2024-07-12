# Behold this incomplete class for constructing boxed banners.
class Banner
  WIDTH_WARNING_MSG = 'WARNING: Banner width outside of allowable range. Using default width.'
  TERMINAL_WIDTH = 80

  def initialize(message, width = nil)
    @message = message
    @width = width ? width : message.length + 4
    @wrapped_text_length = [[@width, max_width].max, TERMINAL_WIDTH].min - 4
    @width_warning = true if !width.nil? && (width < max_width || width > TERMINAL_WIDTH)
  end

  def to_s
    output_arr = [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule]
    output_arr.unshift(WIDTH_WARNING_MSG) if @width_warning
    output_arr.join("\n")
  end

  private

  attr_reader :message, :wrapped_text_length

  def horizontal_rule
    "+-#{'-' * wrapped_text_length}-+"
  end

  def empty_line
    "| #{' ' * wrapped_text_length} |"
  end

  def message_line
    if message.length > wrapped_text_length
      wrap_text(message)
    else
      "| #{message.center(wrapped_text_length)} |"
    end
  end

  def wrap_text(text)
    text += ' '
    wrapped_text_lines = []
    i = 0

    while i < text.length - 1
      slice_length = text[i..i + wrapped_text_length].rindex(' ')
      wrapped_text_slice = text.slice(i, slice_length)
      wrapped_text_lines << "| #{wrapped_text_slice.center(wrapped_text_length)} |"
      i += slice_length + 1
    end

    wrapped_text_lines
  end

  def max_width
    return 0 if message.empty?

    message.split.max_by(&:size).size + 4
  end
end

# Complete this class so that the test cases shown below work as intended.
# You are free to add any methods or instance variables you need.
# However, do not make the implementation details public.

# You may assume that the input will always fit in your terminal window.

# Test Cases
banner = Banner.new('To boldly go where no one has gone before.')
puts banner
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+

banner = Banner.new('')
puts banner
# +--+
# |  |
# |  |
# |  |
# +--+

# Further Exploration
# Modify this class so new will optionally let you specify a fixed banner width
# at the time the Banner object is created. The message in the banner
# should be centered within the banner of that width. Decide for yourself
# how you want to handle widths that are either too narrow or too wide.

banner = Banner.new('To boldly go where no one has gone before.', 60)
puts banner

banner = Banner.new('To boldly go where no one has gone before.', 80)
puts banner

banner = Banner.new('To boldly go where no one has gone before.', 100)
puts banner

banner = Banner.new('To boldly go where no one has gone before.', 12)
puts banner

message1 = 'hello world!'
banner1 = Banner.new(message1)
puts banner1

message2 = 'Lorem ipsum dolor sit amet, ipsum turpis inceptos volutpat.'
banner2 = Banner.new(message2)
puts banner2

long_message = ' Et luctus ac elit quam pellentesque mauris, velit integer bibendum'
long_message += 'tincidunt aliquam at, dignissim quis ante turpis ultricies augue quis.'
long_banner = Banner.new(long_message)
puts long_banner

width1 = 100
long_banner1 = Banner.new(long_message, width1)
puts "Width: #{width1}"
puts long_banner1

width2 = 30
long_banner2 = Banner.new(long_message, width2)
puts "Width: #{width2}"
puts long_banner2

width3 = 22
long_banner3 = Banner.new(long_message, width3)
puts "Width: #{width3}"
puts long_banner3

width4 = 20
long_banner4 = Banner.new(long_message, width4)
puts "Width: #{width4}"
puts long_banner4

width5 = 10
long_banner5 = Banner.new(long_message, width5)
puts "Width: #{width5}"
puts long_banner5
