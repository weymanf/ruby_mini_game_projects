class Game
  def initialize
    @code = Code.new
  end

  def play
    until @code.win?
      puts "Choose your guess."
      @code.parse(gets.chomp)
      correct_color_wrong_position = @code.check_colors - @code.check_order
      puts "You have #{correct_color_wrong_position} right colors in the wrong position"
      puts "You have #{@code.check_order} right colors in the right spot"
    end
    puts "You win."
  end
end

class Code
  attr_accessor :the_code, :player_code

  def initialize
    @the_code = []
    @player_code = []
    4.times { @the_code << random }
  end

  def parse(player_guess)
    @player_code = player_guess.split("")
  end

  def random
    ['R', 'G', 'B', 'Y', 'O', 'P'].sample
  end

  def check_order
    correct_positions = 0
    the_code.each_with_index do |computer_color, code_position|
      correct_positions += 1 if computer_color == player_code[code_position]
    end
    correct_positions
  end

  def check_colors
    correct_color = 0
    right_hash = make_color_hash(the_code)
    guess_hash = make_color_hash(player_code)
    right_hash.each do |color, count|
      if guess_hash[color] > count
        correct_color += count
      else
        correct_color += guess_hash[color]
      end
    end
    correct_color
  end

  def make_color_hash(the_code)
    color_hash = Hash.new(0)
    the_code.each do | color |
      color_hash[color] += 1
    end

    color_hash
  end

  def win?
    the_code == player_code
  end
end

