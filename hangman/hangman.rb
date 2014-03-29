#!/usr/bin/env ruby

class Hangman

  def initialize(guesser,checker)

    @guessing_player = guesser
    @checking_player = checker
    @mystery_word = Array.new(@checking_player.pick_secret_word, nil)
    @guessing_player.receive_secret_length(@mystery_word.length)
  end

  def play
    until win?
      show_word
      guessed_letter = @guessing_player.guess
      correct_letters = @checking_player.handle_guess_response(guessed_letter)
      update_game(correct_letters)
      @guessing_player.handle_feedback(correct_letters)
      # p @guessing_player.possible_words
    end
    puts "Someone has won." # each player has its own message
  end

  def win?
    !@mystery_word.include?(nil)
  end

  def update_game(correct_letters)
    unless correct_letters.empty?
      letter = correct_letters[0]
      correct_letters[1..-1].map(&:to_i).each do |index|
        @mystery_word[index] = letter
      end
    end

  end

  def show_word
    @mystery_word.each { |letter| print letter.nil? ? '_' : letter }
    puts
  end

end

class Player
  def pick_secret_word
  end

  def receive_secret_length(num)
  end

  def guess
  end

  def check_guess
  end

  def handle_guess_response(guess)
  end

end

class HumanPlayer < Player
  def pick_secret_word
    gets.chomp.to_i # length
  end

  def receive_secret_length(length)
    # what/??
  end

  def guess
    gets.chomp
  end

  def handle_guess_response(guess)
    gets.chomp.split(/ /)
    # assume user inputs, e.g. "a 1 4" if the letter a appears at indices 1 and 4
    # if the letter doesn't appear at all, type the letter and hit return
  end

  def handle_feedback(_)
  end



end

class ComputerPlayer < Player

  attr_accessor :checked_letters, :possible_words

  def initialize
    @guessed_letters = []

  end

  def pick_secret_word
    @word = File.readlines("dictionary.txt").map(&:chomp).sample
    # tell the other player how long the word is
    @word.length
  end

  def receive_secret_length(length)
    words = File.readlines("dictionary.txt").map(&:chomp)
    @possible_words = words.select { |word| word.length == length}
  end

  def guess
    letter = (("a".."z").to_a - @guessed_letters).sample
    @guessed_letters << letter
    puts letter
    letter
  end

  def handle_guess_response(guess)
    handled_response = [guess]
    @word.split("").each_with_index do |letter, index|
      handled_response << index if letter == guess
    end
    handled_response
  end

  def handle_feedback(response)
    letter = response.shift
    response.map(&:to_i).each do |index|
      @possible_words.select! { |word| word[index] == letter }
    end
  end



end


class Jarvis < ComputerPlayer

  def guess
    letter = (all_valid_letters - @guessed_letters).sample
    @guessed_letters << letter
    puts letter
    letter
  end

  def all_valid_letters
    @possible_words.join.split("").uniq
  end

  def handle_feedback(response)
    letter = response.shift
    response.map(&:to_i).each do |index|
      @possible_words.select! { |word| word[index] == letter }
    end
    if response.empty?
      @possible_words.reject! { |word| word.include?(letter) }
    end
  end

end

=begin
if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    guesser = HumanPlayer.new
    checker = ComputerPlayer.new
  elsif ARGV.first == 'jarvis'
    guesser = Jarvis.new
    checker = HumanPlayer.new
  else
    guesser = ComputerPlayer.new
    checker = HumanPlayer.new
  end
  Hangman.new(guesser, checker).play
end
=end