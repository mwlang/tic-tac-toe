module TicTacToe
  class Player 
    attr_reader :name
    attr_accessor :marker

    attr_reader :past_boards
    attr_reader :current_board

    attr_reader :past_sequences
    attr_reader :current_sequence
  
    def initialize name
      @name = name
      @past_boards = []
      @past_sequences = []
    end

    def games_won
      @past_sequences.select{|pm| pm.result == :won}
    end
  
    def games_lost
      @past_sequences.select{|pm| pm.result == :lost}
    end
  
    def games_drawn
      @past_sequences.select{|pm| pm.result == :draw}
    end

    def print_results
      puts "#{name}\twon: #{games_won.count}\tlost: #{games_lost.count}\tdraw: #{games_drawn.count}"
    end
  
    def to_s
      " #{marker} "
    end

    def start! board
      @past_boards << board
      @current_board = board
      @current_sequence = MoveSequence.new(board)
      @past_sequences << @current_sequence
    end
  
    def won!
      @current_sequence.won!
    end

    def lost!
      @current_sequence.lost!
    end

    def draw!
      @current_sequence.draw!
    end
    
    def inspect
      "#<Player::#{self.object_id} @name=#{self.name}>"
    end
  end
end
