require_relative 'game'
require_relative 'board'
require_relative 'players/player'
require_relative 'players/novice'
require_relative 'players/skilled'

module TicTacToe
  POSITIONS = 9
  
  WINS = [
    [0,1,2], [3,4,5], [6,7,8], 
    [0,3,6], [1,4,7], [2,5,8], 
    [1,4,8], [2,4,6]
  ]

  class Empty
    attr_reader :position
    def initialize position
      @position = position
    end
    def to_s
      " #{position} "
    end
  end

  class Move
    attr_reader :board
    attr_reader :turn
  
    def initialize board, turn
      @board = board
      @turn = turn
    end
  end

  class MoveSequence
    attr_reader :moves
    attr_reader :result
  
    def initialize board
      @moves = []
    end
  
    def turns
      @moves.map(&:turn)
    end
    
    def play board, position
      @moves << Move.new(board, board.turn)
    end

    def won!
      @result = :won
    end

    def lost!
      @result = :lost
    end
  
    def draw!
      @result = :draw
    end

    def sequence
      @moves.map(&:turn)
    end
    
    def <=> other
      self.sequence <=> other.sequence
    end
    
    def next_turn turns_so_far, open_positions
      future_turns = Array sequence.slice(turns_so_far.size, POSITIONS)
      return if future_turns.empty? || (future_turns & open_positions) != future_turns

      turns = sequence.slice(0, turns_so_far.size)
      turn = future_turns.first

      if turns == turns_so_far && open_positions.include?(turn)
        puts "picking #{@result} turn #{turn} for #{turns_so_far.inspect}"
        return turn 
      end
      
      return nil
    end
  end

  novice_computer = NovicePlayer.new("Novice") 
  skilled_computer = SkilledPlayer.new("Skilled")

  300.times do 
    game = Game.new novice_computer, skilled_computer
    game.play!
  end

  novice_computer.print_results
  skilled_computer.print_results
  skilled_computer.past_sequences.sort.each do |moves|
    puts [moves.result, moves.turns].inspect
  end
end