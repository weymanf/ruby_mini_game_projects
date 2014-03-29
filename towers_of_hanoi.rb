class Towers
  def initialize
    arr1 = [1,2,3,4]
    arr2 = []
    arr3 = []
    @board = [arr1, arr2, arr3]
  end

  def valid_number?(num)
    (1..3).include?(num)
  end

  def valid_move?(from, to)
    return false if @board[from - 1].empty?
    return true if @board[to - 1].empty?
    @board[from - 1].first < @board[to - 1].first
  end

  def get_input(message)
    puts message
    input = gets.chomp.to_i

    if valid_number? input
      return input
    else
      puts "invalid number"
      return get_input(message)
    end
  end

  def get_valid_move
    from = get_input("choose from tower")
    to = get_input("choose to tower")
    if valid_move?(from, to)
      return [from, to]
    else
      puts "invalid move"
      return get_valid_move
    end
  end

  def play
    until won?
      p @board
      from, to = get_valid_move
      @board[to - 1].unshift(@board[from - 1].shift)
    end
    "You Win"
  end

  def won?
    @board[2] == [1,2,3,4]
  end

end