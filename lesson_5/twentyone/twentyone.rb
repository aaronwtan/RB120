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

  def pause(duration = 2)
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
  INNER_WIDTH = 5

  def initialize(rank, suit, hidden: false)
    @rank = rank
    @suit = suit
    @hidden = hidden
  end

  def self.build_display_lines(cards)
    edge_lines = cards.map(&:edge_line).join
    upper_rank_lines = cards.map(&:upper_rank_line).join
    suit_lines = cards.map(&:suit_line).join
    lower_rank_lines = cards.map(&:lower_rank_line).join

    [edge_lines, upper_rank_lines, suit_lines, lower_rank_lines, edge_lines]
  end

  def edge_line
    "+#{'-' * INNER_WIDTH}+"
  end

  def upper_rank_line
    hidden? ? "|#{'*' * INNER_WIDTH}|" : "|#{rank.ljust(INNER_WIDTH)}|"
  end

  def lower_rank_line
    hidden? ? "|#{'*' * INNER_WIDTH}|" : "|#{rank.rjust(INNER_WIDTH)}|"
  end

  def suit_line
    hidden? ? "|#{'*' * INNER_WIDTH}|" : "|#{suit.center(INNER_WIDTH)}|"
  end

  def to_s
    hidden? ? '???' : "#{rank} of #{suit}"
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
    if number?
      rank.to_i
    elsif face?
      10
    elsif ace?
      11
    end
  end

  def number?
    ('2'..'10').to_a.include?(rank)
  end

  def face?
    %w(J Q K).include?(rank)
  end

  def ace?
    rank == 'A'
  end

  private

  attr_accessor :hidden
  attr_reader :rank, :suit
end

class Deck
  RANKS = ('2'..'10').to_a + %w(J Q K A)
  SUITS = %w(♦ ♣ ♥ ♠)

  def initialize
    @cards = []
    initialize_cards
    cards.shuffle!
  end

  def initialize_cards
    RANKS.each do |rank|
      SUITS.each { |suit| cards << Card.new(rank, suit) }
    end
  end

  def deal_one_card
    cards.pop
  end

  private

  attr_reader :cards
end

module ParticipantDisplay
  def display_turn_start_message
    if is_a?(Player)
      prompt("#{name}, it's your turn.")
    elsif is_a?(Dealer)
      prompt("It's Dealer #{name}'s turn. Revealing hole card...")
    end

    pause
  end

  def display_total
    total_str = cards.any?(&:hidden?) ? '???' : total
    puts "#{name.upcase}'S TOTAL: #{total_str}"
  end

  def display_hand
    puts Card.build_display_lines(cards)
    puts ''
  end

  def display_info
    display_total
    display_hand
  end
end

module Hand
  BUST_CONDITION = 21

  def add_card(new_card)
    cards << new_card
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

  private

  def set_name
    self.name = COMPUTER_NAMES.sample
  end

  def hole_card
    cards[1]
  end
end

module TwentyOneDisplay
  def display_game(msg_key)
    dealer.display_info
    player.display_info
    return if msg_key.nil?

    prompt(msg_key)
    pause
  end

  def clear_screen_and_display_game(msg_key = nil)
    clear_screen
    display_game(msg_key)
  end

  def determine_and_display_result
    clear_screen_and_display_game
    winner, loser = determine_result

    if someone_busted?
      prompt("#{loser} bust. #{winner} wins!")
    elsif winner
      prompt("#{winner}'s score of #{winner.total} beats " \
             "#{loser}'s score of #{loser.total}. #{winner} wins!")
    else
      prompt('push')
    end
  end
end

class TwentyOne
  include TwentyOneDisplay, Utility

  def initialize
    clear_screen
    @deck = Deck.new
    @player = Player.new(deck)
    @dealer = Dealer.new(deck)
    deal_initial_cards_and_hide_dealer_hole_card
  end

  def start
    play_player_turn
    play_dealer_turn unless player.busted?
    determine_and_display_result
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

  def play_player_turn
    clear_screen_and_display_game

    loop do
      choice = player.choose_hit_or_stay
      break if %w(s stay).include?(choice)

      player.deal_one_card_from_deck_to_hand
      clear_screen_and_display_game("#{player} hit!")
      return if player.busted?
    end

    clear_screen_and_display_game("#{player} stays!")
  end

  def play_dealer_turn
    dealer.reveal_hole_card
    clear_screen_and_display_game
    dealer.display_turn_start_message

    while dealer.total < Dealer::STAY_CONDITION
      dealer.deal_one_card_from_deck_to_hand
      clear_screen_and_display_game("#{dealer} hit!")
    end

    clear_screen_and_display_game("#{dealer} stays!") unless dealer.busted?
  end

  def determine_winner
    return player if dealer.busted?
    return dealer if player.busted?

    if player.beats?(dealer)
      player
    elsif dealer.beats?(player)
      dealer
    end
  end

  def determine_loser
    determine_winner == player ? dealer : player
  end

  def determine_result
    [determine_winner, determine_loser]
  end
end

game = TwentyOne.new
game.start
