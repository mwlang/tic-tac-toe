module TicTacToe
  class Board
    attr_reader :positions
    attr_reader :player1, :player2, :current_player, :winning_player, :losing_player
    attr_reader :last_play
  
    def initialize player1, player2
      @positions = Array.new(9.times.map{|i| Empty.new i + 1})
      @player1, @player2 = [player1, player2].shuffle
      @player1.marker = 'X'
      @player2.marker = 'O'
      @current_player = @player1
      @last_play = nil
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
        @last_play = position
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
end