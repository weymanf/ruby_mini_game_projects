class Board

  attr_accessor :grid, :p1_box, :p2_box, :win_configs
  def initialize
    @grid = {}
    ('a'..'c').each do |x|
      (1..3).each do |y|
        @grid[x + y.to_s] = " "
      end
    end
    @win_configs = [
      ["a1", "a2", "a3"],
      ["b1", "b2", "b3"],
      ["c1", "c2", "c3"],
      ["a1", "b1", "c1"],
      ["a2", "b2", "c2"],
      ["a3", "b3", "c3"],
      ["a1", "b2", "c3"],
      ["a3", "b2", "c1"]
    ]
    @p1_box = []
    @p2_box = []
  end

  def won?
    !!winner
  end

  def winner
    @grid.each do |pos, xo|
      unless xo == " "
        xo == "x" ? p1_box << pos : p2_box << pos
      end
    end
    @win_configs.each do |win_combo|
      return "Player One Wins!" if (win_combo & p1_box).length == 3
      return "Player Two Wins!" if (win_combo & p2_box).length == 3
    end
    return false
  end

  def empty?(pos)
    @grid[pos] == " "
  end

  def place_mark(pos, mark)
    @grid[pos] = mark
  end
end


class Game
  def initialize(player1, player2)
    @p1 = player1
    @p2 = player2
    @board = Board.new
  end

  def show
    ('a'..'c').each do |letter|
      (1..3).each do |number|
        print "#{@board.grid[letter + number.to_s]} | "
      end
      print "\n"
    end
  end

  def play
    show
    until @board.won?

      @board.place_mark(@p1.move(@board), @p1.mark)

      show
      break if @board.won?
      @board.place_mark(@p2.move(@board), @p2.mark)
      show
    end
    @board.winner
  end


end

class Player

  attr_accessor :mark

  def initialize(mark)
    @mark = mark
  end
end


class HumanPlayer < Player
  def move(board)
    ch = gets.chomp.downcase
    if ch.match(/[a-c][1-3]/)
      return ch
    else
      self.move
    end
  end
end

class ComputerPlayer < Player
  def move(board)
    grid = board.grid
    configs = board.win_configs

    configs.each do |config|
      return (config - (config & board.p2_box)).first if (config & board.p2_box).length == 2
    end

    (grid.keys - board.p1_box - board.p2_box).sample
  end
end