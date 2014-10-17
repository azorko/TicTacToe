require 'byebug'

class Board
  
  def initialize
     @board = Array.new(3) {Array.new(3)}
  end
  
  def won?
    return true if  @board[0][0] == @board[0][1] && @board[0][1] == @board[0][2] && !@board[0][1].nil? ||
     @board[1][0] == @board[1][1] && @board[1][1] == @board[1][2] && !@board[1][1].nil? ||
     @board[2][0] == @board[2][1] && @board[2][1] == @board[2][2] && !@board[2][1].nil? ||
     @board[0][0] == @board[1][0] && @board[1][0] == @board[2][0] && !@board[1][0].nil? ||
     @board[0][1] == @board[1][1] && @board[1][1] == @board[2][1] && !@board[1][1].nil? ||
      @board[0][2] == @board[1][2] && @board[1][2] == @board[2][2] && !@board[1][2].nil? ||
      @board[0][0] == @board[1][1] && @board[1][1] == @board[2][2] && !@board[1][1].nil? ||
      @board[2][0] == @board[1][1] && @board[1][1] == @board[0][2] && !@board[1][1].nil?
    false
  end

  def get_mark(pos)
    @board[pos[0]][pos[1]]
  end
  
  def empty?(pos)
    @board[pos[0]][pos[1]].nil?
  end
  
  def place_mark(pos, mark)
    @board[pos[0]][pos[1]] = mark
  end
  
  def display
    (0..2).each do |row|
      puts
      (0..2).each do |col|
        if @board[row][col].nil?
          print '_ '
        else
          print @board[row][col] + ' '
        end
      end
    end
    puts
  end
  
end



class Game
  
  def play
    board = Board.new
    puts "Human player move first, you are X."
    loop do
      board.display
      begin
        puts "Please input row and column number of move (0 - 2)"
        move = gets.chomp.scan(/\d/).map!(&:to_i)
        raise ArgumentError.new 'Please input 2 integers, try again!' if move.size != 2
        raise ArgumentError.new 'Please input integers from 0 - 2, try again!' if move.any? { |el| !(0..2).to_a.include?(el) }
      rescue ArgumentError => e
        puts e.message
        retry
      end
      board.place_mark(move, "x") if board.empty?(move)
      if board.won?
        p 'Human player won!'
        break
      end
      board.place_mark(comp_move(board), 'o')
      if board.won?
        p 'Computer player won!'
        break
      end
    end
  end
  
  def comp_move(board)
    winning_pos = [[[0, 0], [0, 1], [0, 2]],
          [[1, 0], [1, 1], [1, 2]],
          [[2, 0], [2, 1], [2, 2]],
          [[0, 0], [1, 0], [2, 0]],
          [[0, 1], [1, 1], [2, 1]],
          [[0, 2], [1, 2], [2, 2]],
          [[0, 0], [1, 1], [2, 2]],
          [[2, 0], [1, 1], [0, 2]]]
    i = 0
    empty = nil
    winning_pos.each do |combo|
      combo.each do |pos|
        i += 1 if board.get_mark(pos) == "o"
        empty = pos if board.empty?(pos)
      end
      return empty if (i == 2 && !empty.nil?)
    end
    random_move(board)
  end
  
  def random_move(board)
    move = []
    while true
      move = [rand(3), rand(3)]
      break if board.empty?(move)
    end
    move
  end
end

game = Game.new
game.play