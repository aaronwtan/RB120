require 'yaml'
require 'io/console'

MESSAGES = YAML.load_file('twentyone.yml')

module Utility
  def self.prompt(msg)
    puts ">> #{msg}"
  end

  def self.messages(msg)
    MESSAGES[msg]
  end

  def self.formatted_prompt(msg, **args)
    prompt(format(messages(msg), **args))
  end

  def self.formatted_message(msg, **args)
    format(messages(msg), **args)
  end

  def self.join_or(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first.to_s
    when 2 then arr.join(" #{word} ")
    else
      word_and_last_element = ["#{word} #{arr[-1]}"]
      (arr[0...-1] + word_and_last_element).join(delimiter)
    end
  end

  def self.answered_yes?
    loop do
      answer = gets.chomp.strip.downcase
      valid_responses = Utility.messages('valid_yes_or_no_responses')
      yes_response = Utility.messages('yes_responses')
      return yes_response.include?(answer) if valid_responses.include?(answer)

      Utility.formatted_prompt('invalid_yes_or_no')
    end
  end

  def self.clear_screen
    system 'clear'
  end

  def self.long_pause
    pause
  end

  def self.short_pause
    pause(1.3)
  end

  def self.pause(duration = 2)
    sleep(duration)
  end

  def self.valid_num_str?(str, sign = :+)
    case sign
    when :+ then str =~ /^ *\d+ *$/ && str.to_i.positive?
    when :- then str =~ /^ *\d+ *$/ && str.to_i.negative?
    end
  end

  def self.pluralize(str, num)
    num == 0 || num > 1 ? "#{str}s" : str
  end
end

module BannerDisplayable
  def display_title_banner(width, title)
    width = [width, title.length + 2].max
    puts header(width)
    puts body_with_borders(width, ['', title, ''], :center)
    puts footer(width)
    puts ''
  end

  def display_banner_with_borders(width, body_lines_arr,
                                  align = :left, title = nil)
    puts header(width, title)
    puts body_with_borders(width, body_lines_arr, align)
    puts footer(width)
  end

  def display_banner_without_borders(width, body_lines_arr, title = nil)
    puts header(width, title)
    puts body_lines_arr
    puts footer(width)
  end

  def header(width, title = nil)
    return footer(width) unless title

    "+#{" #{title} ".center(width - 2, '-')}+"
  end

  def body_with_borders(width, body_lines_arr, align)
    body_lines_arr.map do |body_line|
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
  HIDDEN_LINE_SEGMENT = "|#{'*' * INNER_WIDTH}|"

  def initialize(rank, suit, hidden: false)
    @rank = rank
    @suit = suit
    @hidden = hidden
  end

  def self.display(cards)
    puts build_display_lines(cards)
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
    hidden? ? HIDDEN_LINE_SEGMENT : "|#{rank.ljust(INNER_WIDTH)}|"
  end

  def lower_rank_line
    hidden? ? HIDDEN_LINE_SEGMENT : "|#{rank.rjust(INNER_WIDTH)}|"
  end

  def suit_line
    hidden? ? HIDDEN_LINE_SEGMENT : "|#{suit.center(INNER_WIDTH)}|"
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
    ('2'..'10').include?(rank)
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
  def display_total
    total_str = cards.any?(&:hidden?) ? '???' : total
    puts "#{name.upcase}'S TOTAL: #{total_str}"
  end

  def display_hand
    Card.display(cards)
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

  attr_reader :score

  def initialize(deck)
    set_name
    @deck = deck
    @cards = []
    @score = 0
  end

  def to_s
    name
  end

  def reset
    self.cards = []
  end

  def increment_score
    self.score += 1
  end

  def draw_card
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
  attr_writer :score
end

class Player < Participant
  def display_turn_start_message
    Utility.formatted_prompt('player_turn', name: name)
  end

  def choose_hit_or_stay
    loop do
      Utility.formatted_prompt('hit_or_stay')
      answer = gets.chomp.downcase
      valid_responses = Utility.messages('valid_hit_or_stay_responses')

      return answer if valid_responses.include?(answer)

      Utility.formatted_prompt('invalid_hit_or_stay')
    end
  end

  private

  def set_name
    answer = ''

    loop do
      Utility.formatted_prompt('ask_name')
      answer = gets.chomp.strip
      break unless answer.empty?

      Utility.formatted_prompt('invalid_name')
    end

    self.name = answer
  end
end

class Dealer < Participant
  COMPUTER_NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']
  STAY_CONDITION = 17

  def display_turn_start_message
    Utility.formatted_prompt('dealer_turn', name: name)
    Utility.long_pause
  end

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
  include BannerDisplayable

  GAME_TITLE = 'TWENTY-ONE'
  WELCOME_TITLE_WIDTH = 30
  GAME_TITLE_WIDTH = 20
  SCOREBOARD_WIDTH = 19

  def display_welcome_message
    welcome_message = Utility.formatted_message('welcome_message',
                                                title: GAME_TITLE)
    display_title_banner(WELCOME_TITLE_WIDTH, welcome_message)
    Utility.long_pause
  end

  def display_goodbye_message
    Utility.formatted_prompt('goodbye')
  end

  def display_rules
    loop do
      Utility.clear_screen
      puts Utility.messages('rules_pt1')
      ask_player_ready

      Utility.clear_screen
      puts Utility.messages('rules_pt2')

      Utility.formatted_prompt('ask_rules_again')

      return unless Utility.answered_yes?
    end
  end

  def display_scoreboard
    scores_text_arr = ["#{player}: #{player.score}",
                       "#{dealer}: #{dealer.score}"]
    header_text = Utility.formatted_message('round_header', round: round)
    display_banner_without_borders(SCOREBOARD_WIDTH,
                                   scores_text_arr, header_text)
  end

  def display_final_win_condition
    puts Utility.formatted_message('final_win_condition',
                                   final_win_condition: final_win_condition)
    puts ''
  end

  def display_game(msg_key, **args)
    display_title_banner(GAME_TITLE_WIDTH, GAME_TITLE)
    display_scoreboard
    display_final_win_condition
    dealer.display_info
    player.display_info
    return if msg_key.nil?

    Utility.formatted_prompt(msg_key, **args)
    Utility.short_pause
  end

  def clear_screen_and_display_game(msg_key = nil, **args)
    Utility.clear_screen
    display_game(msg_key, **args)
  end

  def display_round_result(winner, loser)
    clear_screen_and_display_game

    if someone_busted?
      Utility.formatted_prompt('someone_bust', loser: loser, winner: winner)
    elsif winner
      Utility.formatted_prompt('winner', winner: winner, loser: loser,
                                         winner_score: winner.total,
                                         loser_score: loser.total)
    else
      Utility.formatted_prompt('push')
    end

    Utility.long_pause
  end

  def determine_and_display_round_result
    winner, loser = determine_round_result
    winner&.increment_score
    display_round_result(winner, loser)
  end

  def determine_and_display_final_result
    total_games = Utility.pluralize('game', final_win_condition)
    total_rounds = Utility.pluralize('round', round)
    clear_screen_and_display_game('final_result',
                                  final_winner: determine_final_winner,
                                  final_win_condition: final_win_condition,
                                  total_games: total_games,
                                  round: round,
                                  total_rounds: total_rounds)
  end
end

module TwentyOneAskable
  def ask_final_win_condition
    Utility.formatted_prompt('ask_win_condition')

    loop do
      answer = gets.chomp
      if ('1'..'10').include?(answer)
        self.final_win_condition = answer.to_i
        return
      end

      Utility.formatted_prompt('invalid_win_condition')
    end
  end

  def ask_rules
    Utility.clear_screen
    Utility.formatted_prompt('ask_rules')

    display_rules if Utility.answered_yes?
    Utility.formatted_prompt('start_game')
  end

  def ask_player_ready
    Utility.formatted_prompt('ready')
    $stdin.getch
  end

  def play_again?
    Utility.formatted_prompt('ask_play_again')
    Utility.answered_yes?
  end
end

class TwentyOne
  include TwentyOneDisplay, TwentyOneAskable, Utility

  def initialize
    Utility.clear_screen
    display_welcome_message
    reset_game
  end

  def start
    loop do
      play_game
      break unless play_again?

      reset_game
    end

    display_goodbye_message
  end

  private

  attr_accessor :deck, :player, :dealer, :final_win_condition, :round

  def deal_initial_cards_and_hide_dealer_hole_card
    deal_initial_cards
    dealer.hide_hole_card
  end

  def deal_initial_cards
    2.times { [player, dealer].each(&:draw_card) }
  end

  def play_player_turn
    clear_screen_and_display_game
    player.display_turn_start_message

    loop do
      choice = player.choose_hit_or_stay
      break if Utility.messages('stay_responses').include?(choice)

      player.draw_card
      clear_screen_and_display_game('hit', name: player)
      return if player.busted?
    end

    clear_screen_and_display_game('stay', name: player)
  end

  def play_dealer_turn
    dealer.reveal_hole_card
    clear_screen_and_display_game
    dealer.display_turn_start_message

    while dealer.total < Dealer::STAY_CONDITION
      dealer.draw_card
      clear_screen_and_display_game('hit', name: dealer)
      return if dealer.busted?
    end

    clear_screen_and_display_game('stay', name: dealer)
  end

  def someone_busted?
    player.busted? || dealer.busted?
  end

  def determine_round_winner
    return player if dealer.busted?
    return dealer if player.busted?

    if player.beats?(dealer)
      player
    elsif dealer.beats?(player)
      dealer
    end
  end

  def determine_round_loser
    determine_round_winner == player ? dealer : player
  end

  def determine_round_result
    [determine_round_winner, determine_round_loser]
  end

  def reset_round
    self.round += 1
    self.deck = Deck.new
    player.reset
    dealer.reset
  end

  def play_round
    deal_initial_cards_and_hide_dealer_hole_card
    play_player_turn
    play_dealer_turn unless player.busted?
    determine_and_display_round_result
  end

  def someone_won_game?
    player.score >= final_win_condition || dealer.score >= final_win_condition
  end

  def determine_final_winner
    player.score >= final_win_condition ? player : dealer
  end

  def reset_game
    Utility.clear_screen
    self.deck = Deck.new
    self.player = Player.new(deck)
    self.dealer = Dealer.new(deck)
    self.round = 1
    ask_final_win_condition
    ask_rules
    ask_player_ready
  end

  def play_game
    loop do
      play_round
      break if someone_won_game?

      reset_round
    end

    determine_and_display_final_result
  end
end

game = TwentyOne.new
game.start
