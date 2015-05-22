module TicTacToe
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
end

