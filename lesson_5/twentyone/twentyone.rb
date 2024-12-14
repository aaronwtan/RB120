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

  def to_s # NOTE: change implementation later to more intuitive graphical display of card
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

  def suit
    SUIT_NAMES[@suit]
  end

  private

  attr_accessor :hidden
end

class NumberCard < Card
  def value
    rank.to_i
  end

  private

  attr_reader :rank
end

class FaceCard < Card
  RANK_NAMES = %w(J Q K).zip(%w(Jack Queen King)).to_h

  def rank
    RANK_NAMES[@rank]
  end

  def value
    10
  end
end

class AceCard < Card
  def rank
    'Ace'
  end

  def value
    11
  end
end

class Deck
  RANKS = ('2'..'10').to_a + %w(J Q K A)
  SUITS = %w(D C H S)

  def initialize
    @cards = []
    initialize_cards
    cards.shuffle!
  end

  def initialize_cards
    RANKS.each do |rank|
      SUITS.each do |suit|
        cards << NumberCard.new(rank, suit) if number?(rank)
        cards << FaceCard.new(rank, suit) if face?(rank)
        cards << AceCard.new(rank, suit) if ace?(rank)
      end
    end
  end

  def deal_one_card
    cards.pop
  end

  private

  def number?(rank)
    ('2'..'10').to_a.include?(rank)
  end

  def face?(rank)
    %w(J Q K).include?(rank)
  end

  def ace?(rank)
    rank == 'A'
  end

  attr_reader :cards
end

module ParticipantDisplay
  def display_turn_start_message
    if is_a?(Player)
      prompt("#{name}, it's your turn.")
    elsif is_a?(Dealer)
      prompt("It's Dealer #{name}'s turn.")
    end
  end

  def display_hit_message
    prompt("#{name} hit!")
  end

  def display_stay_message
    prompt("#{name} stays!")
  end
end

module Hand
  BUST_CONDITION = 21

  def display_hand
    total_str = cards.any?(&:hidden?) ? '???' : total
    puts "#{name.upcase}'S TOTAL: #{total_str}"
    cards.each { |card| prompt(card) }
    puts ''
  end

  def add_card(new_card)
    cards << new_card
  end

  def hit
    display_hit_message
    deal_one_card_from_deck_to_hand
    display_hand
    pause if is_a?(Dealer)
  end

  def stay
    display_stay_message
    display_hand
  end

  def busted?
    total > BUST_CONDITION
  end

  def total
    total = cards.sum(&:value)
    num_of_aces = cards.count { |card| card.is_a?(AceCard) }
    num_of_aces.times { total -= 10 if total > BUST_CONDITION }
    total
  end
end

class Participant
  include Hand, ParticipantDisplay, Utility

  def initialize(deck)
    set_name
    @deck = deck
    @cards = []
  end

  def to_s
    name
  end

  def reset
    self.cards = []
  end

  def deal_one_card_from_deck_to_hand
    add_card(deck.deal_one_card)
  end

  def beats?(other_player)
    total > other_player.total
  end

  def ties_with?(other_player)
    total == other_player.total
  end

  private

  attr_accessor :name, :deck, :cards
end

class Player < Participant
  def choose_hit_or_stay
    loop do
      prompt('hit_or_stay')
      answer = gets.chomp

      return answer if %w(h hit s stay).include?(answer)

      prompt('invalid_hit_or_stay')
    end
  end

  def play_turn
    display_turn_start_message

    loop do
      choice = choose_hit_or_stay
      break if %w(s stay).include?(choice)

      hit
      return if busted?
    end

    stay
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
  STAY_CONDITION = 17

  def hide_hole_card
    hole_card.hide
  end

  def reveal_hole_card
    hole_card.reveal
  end

  def play_turn
    display_turn_start_message
    hit while total < STAY_CONDITION
    stay unless busted?
  end

  private

  def set_name
    self.name = COMPUTER_NAMES.sample
  end

  def hole_card
    cards[1]
  end
end

module TwentyOneDisplay
  def display_all_cards
    dealer.display_hand
    player.display_hand
  end

  def display_result
    display_all_cards
    prompt(determine_result_msg_key)
  end
end

class TwentyOne
  include TwentyOneDisplay, Utility

  def initialize
    @deck = Deck.new
    @player = Player.new(deck)
    @dealer = Dealer.new(deck)
  end

  def start
    deal_initial_cards_and_hide_dealer_hole_card
    display_all_cards
    player.play_turn
    dealer.play_turn unless player.busted?
    display_result
  end

  private

  attr_accessor :deck, :player, :dealer

  def reset
    self.deck = Deck.new
    player.reset
    dealer.reset
  end

  def deal_initial_cards_and_hide_dealer_hole_card
    deal_initial_cards
    dealer.hide_hole_card
  end

  def deal_initial_cards
    2.times { [player, dealer].each(&:deal_one_card_from_deck_to_hand) }
  end

  def someone_busted?
    player.busted? || dealer.busted?
  end

  def determine_result_msg_key
    return 'player_bust' if player.busted?
    return 'dealer_bust' if dealer.busted?
    return 'player_wins' if player.beats?(dealer)
    return 'dealer_wins' if dealer.beats?(player)
    return 'push'        if player.ties_with?(dealer)
  end
end

game = TwentyOne.new
game.start
