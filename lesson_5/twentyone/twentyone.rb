require 'pry'
require 'yaml'

MESSAGES = YAML.load_file('twentyone.yml')

module Utility
  def prompt(msg)
    if MESSAGES.key?(msg)
      puts ">> #{MESSAGES[msg]}"
    else
      puts ">> #{msg}"
    end
  end

  def join_or(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first.to_s
    when 2 then arr.join(" #{word} ")
    else
      word_and_last_element = ["#{word} #{arr[-1]}"]
      (arr[0...-1] + word_and_last_element).join(delimiter)
    end
  end

  def answered_yes?
    loop do
      answer = gets.chomp.strip.downcase
      return %w(y yes).include?(answer) if %w(y yes n no).include?(answer)

      prompt('invalid_yes_or_no')
    end
  end

  def clear_screen
    system 'clear'
  end

  def pause(duration = 1.5)
    sleep(duration)
  end

  def valid_num_str?(str, sign = :+)
    case sign
    when :+ then str =~ /^ *\d+ *$/ && str.to_i.positive?
    when :- then str =~ /^ *\d+ *$/ && str.to_i.negative?
    end
  end
end

module BannerDisplayable
  def display_title_banner(width, title)
    width = [width, title.length + 2].max
    puts header(width)
    puts body_with_borders(width, ['', title, ''], :center)
    puts footer(width)
  end

  def display_banner_with_borders(width, body_lines, align = :left, title = nil)
    puts header(width, title)
    puts body_with_borders(width, body_lines, align)
    puts footer(width)
  end

  def display_banner_without_borders(width, body_lines, title = nil)
    puts header(width, title)
    puts body_lines
    puts footer(width)
  end

  def header(width, title = nil)
    return footer(width) unless title

    "+#{" #{title} ".center(width - 2, '-')}+"
  end

  def body_with_borders(width, body_lines, align)
    body_lines.map do |body_line|
      case align
      when :left   then "|#{body_line.ljust(width - 2)}|"
      when :right  then "|#{body_line.rjust(width - 2)}|"
      when :center then "|#{body_line.center(width - 2)}|"
      end
    end
  end

  def footer(width)
    "+#{'-' * (width - 2)}+"
  end
end

module Hand
  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

class Participant
  include Hand

  attr_accessor :cards

  def initialize
    @cards = []
  end

  def reset
    self.cards = []
  end

  private
end

class Player < Participant
  private
end

class Dealer < Participant
  private
end

class Deck
  RANKS = ('2'..'10').to_a + %w(J Q K A)
  SUITS = %w(D C H S)

  def initialize
    @cards = []
    RANKS.each { |rank| SUITS.each { |suit| cards << Card.new(rank, suit) } }
    cards.shuffle!
  end

  def deal_one_card
    cards.pop
  end

  # private

  attr_reader :cards
end

class Card

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  private

  def rank
    case @rank
    when 'J' then 'Jack'
    when 'Q' then 'Queen'
    when 'K' then 'King'
    when 'A' then 'Ace'
    else          @rank
    end
  end

  def suit
    case @suit
    when 'D' then 'Diamonds'
    when 'C' then 'Clubs'
    when 'H' then 'Hearts'
    when 'S' then 'Spades'
    end
  end
end

class TwentyOne
  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    deal_cards
    show_initial_cards
    # player_turn
    # dealer_turn
    # show_result
  end

  private

  attr_accessor :deck, :player, :dealer

  def reset
    self.deck = Deck.new
    player.reset
    dealer.reset
  end

  def deal_cards
    2.times do
      player.cards << deck.deal_one_card
      dealer.cards << deck.deal_one_card
    end
  end

  def show_initial_cards
    puts 'DEALER CARDS'
    puts dealer.cards.first
    puts 'PLAYER CARDS'
    player.cards.each { |card| puts card }
  end

  def player_turn
  end
end

game = TwentyOne.new
game.start
