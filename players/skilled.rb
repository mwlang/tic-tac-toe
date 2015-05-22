module TicTacToe
  class SkilledPlayer < Player
    def random_turn
      current_board.open_positions.shuffle.pop
    end
  
    def next_turn
      turns_so_far = @current_sequence.moves.map(&:turn)
      return random_turn if turns_so_far.size < 2
  
      sequence = games_won.detect{|moves| moves.next_turn turns_so_far, current_board.open_positions }
      sequence ||= games_drawn.detect{|moves| moves.next_turn turns_so_far, current_board.open_positions }

      return random_turn unless sequence
      sequence.next_turn(turns_so_far, current_board.open_positions)
    end
  
    def play
      @current_sequence.play current_board, next_turn
      current_board.play self, next_turn
    end    
  end
end