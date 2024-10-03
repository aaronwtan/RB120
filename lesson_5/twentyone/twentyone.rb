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

class Card
  SUIT_NAMES = { 'D' => 'Diamonds', 'C' => 'Clubs',
                 'H' => 'Hearts', 'S' => 'Spades' }

  def initialize(rank, suit, hidden: false)
    @rank = rank
    @suit = suit
    @hidden = hidden
  end

  def to_s
    hidden ? '???' : "#{rank} of #{suit}"
  end

  def hidden?
    hidden
  end

  def hide
    self.hidden = true
  end

  def reveal
    self.hidden = false
  end

  def value
    if face?
      10
    elsif ace?
      11
    else
      rank.to_i
    end
  end

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
    SUIT_NAMES[@suit]
  end

  def face?
    rank == 'Jack' || rank == 'Queen' || rank == 'King'
  end

  def ace?
    rank == 'Ace'
  end

  private

  attr_accessor :hidden
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

  private

  attr_reader :cards
end

module Hand
  BUST_CONDITION = 21

  def display_hand
    total_str = cards.any?(&:hidden?) ? '???' : total.to_s
    puts "#{name.upcase}'S TOTAL: #{total_str}"
    cards.each { |card| prompt(card) }
    puts ''
  end

  def add_card(new_card)
    cards << new_card
  end

  def hit
  end

  def stay
  end

  def busted?
    total > BUST_CONDITION
  end

  def total
    total = cards.sum(&:value)
    cards.count(&:ace?).times { total -= 10 if total > BUST_CONDITION }
    total
  end
end

module ParticipantDisplay
  def display_turn_start_message
    prompt("#{name}, it's your turn.")
  end
end

class Participant
  include Hand, Utility

  attr_reader :name, :cards

  def initialize
    set_name
    @cards = []
  end

  def reset
    self.cards = []
  end

  private

  attr_writer :name, :cards
end

class Player < Participant
  def play_turn

  end

  private

  def set_name
    answer = ''

    loop do
      prompt('ask_name')
      answer = gets.chomp.strip
      break unless answer.empty?

      prompt('invalid_name')
    end

    self.name = answer
  end
end

class Dealer < Participant
  COMPUTER_NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def hide_hole_card
    hole_card.hide
  end

  def reveal_hole_card
    hole_card.reveal
  end

  def play_turn

  end

  private

  def set_name
    self.name = COMPUTER_NAMES.sample
  end

  def hole_card
    cards.last
  end
end

module TwentyOneDisplay
  def display_all_cards
    dealer.display_hand
    player.display_hand
  end
end

class TwentyOne
  include TwentyOneDisplay, Utility

  DEALER_STAY_CONDITION = 17

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    deal_initial_cards
    display_all_cards
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

  def deal_initial_cards
    2.times do
      deal_one_card_from_deck_to(player)
      deal_one_card_from_deck_to(dealer)
    end

    dealer.hide_hole_card
  end

  def deal_one_card_from_deck_to(participant)
    participant.add_card(deck.deal_one_card)
  end

  def player_turn
  end
end

game = TwentyOne.new
game.start
