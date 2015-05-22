module TicTacToe
  class NovicePlayer < Player
    def play
      position = current_board.open_positions.shuffle.pop
      current_board.play self, position
    end    
  end
end