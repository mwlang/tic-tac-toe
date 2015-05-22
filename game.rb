module TicTacDoe
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

  class NovicePlayer < Player
    def play
      position = current_board.open_positions.shuffle.pop
      current_board.play self, position
    end    
  end

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

  class Board
    attr_reader :positions
    attr_reader :player1, :player2, :current_player, :winning_player, :losing_player

    def initialize(player1, player2)
      @positions = Array.new(9.times.map{|i| Empty.new i + 1})
      @player1, @player2 = [player1, player2].shuffle
      @player1.marker = 'X'
      @player2.marker = 'O'
      @current_player = @player1
    end
  
    def draw_divider
      puts ['-' * 3, '+', '-' * 3, '+', '-' * 3].join
    end
  
    def draw_row row
      puts row.map{|cell| cell.to_s }.join("|")
    end

    def open_positions
      positions.select{|cell| cell.kind_of? Empty}.map(&:position)
    end
  
    def turn
      POSITIONS - open_positions.count
    end
  
    def draw
      puts 
      positions.each_slice(3).each_with_index do |row, index|
        draw_divider unless index == 0
        draw_row row
      end
      puts 
    end
  
    def play player, position
      raise "Not Your Turn!" unless player == @current_player
      # puts "#{player.name} plays position #{position}"
      begin
        @positions[position-1] = player
      rescue
        raise position.class.to_s.inspect
      end
      @current_player = @current_player == player1 ? player2 : player1
    end

    def record_draw
      @player1.draw!
      @player2.draw!
    end
    
    def record_win winner
      @winning_player = winner
      @winning_player.won!
      @losing_player = (winner == player1 ? player2 : player1)
      @losing_player.lost!
    end
  
    def game_won?
      WINS.each do |cells|
        combo = cells.map{|cell| positions[cell]}
        combo.select{ |position| position.is_a? Player }
        return combo.first if combo.count == 3 && combo.uniq.size == 1
      end
      return false
    end

    def game_draw?
      open_positions.empty? && !game_won?
    end
  
    def game_over?
      game_won? || game_draw?
    end
  end

  class Game
    attr_reader :board
  
    def initialize player1, player2
      @board = Board.new player1, player2
      puts "player 1: #{board.player1.name} playing as #{board.player1.marker}"
      puts "player 2: #{board.player2.name} playing as #{board.player2.marker}"
      player1.start! @board
      player2.start! @board
    end
  
    def play!
      while not board.game_over? do 
        "It's #{board.current_player.name}'s turn!"
        board.current_player.play
      end

      if winner = board.game_won?
        board.record_win winner
        puts "The game was won by #{board.winning_player.name}"
      else
        board.record_draw
        puts "The game was a draw"
      end
      board.draw
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
  skilled_computer.past_sequences.each do |moves|
    # puts [moves.result, moves.turns].inspect
  end
end