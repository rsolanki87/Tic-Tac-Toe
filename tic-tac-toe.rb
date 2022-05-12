class Game
    attr_accessor :board, :winner, :game_over

    def initialize(player1, player2)
        @board = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
        @game_over = false
        @winner = nil
        @player1 = player1
        @player2 = player2
        @play = play
    end

    def play
        player = @player1
        free_spaces = [1, 2, 3, 4, 5, 6, 7, 8, 9]

        until game_over
            display_board
            puts "#{player.name}: Please choose one of the available free spaces on the board."

            position = gets.chomp.to_i
            if free_spaces.include?(position)
                free_spaces.delete(position)
                @board[position - 1] = player.game_piece

                winner_check(player)
                tie_check(free_spaces)

                player == @player1 ? player = @player2 : player = @player1
            end
        end
        display_winner
    end

    def tie_check(free_spaces)
        @game_over = true if free_spaces.empty?
    end

    def winner_check(player)
        winning_combinations = [
            [0, 1, 2], 
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ]

        winning_combinations.each do |combinations|
            arr = []
            combinations.each do |position|
                arr << @board[position]
            end

            if arr.join =~ /#{player.game_piece}{3}/
                @winner = player
                @game_over = true
            end
        end
    end

    def display_winner
        @display_board = display_board
        unless @winner.nil?
            puts "#{winner.name} is the winner."
        else
            puts "It's a tie game."
        end

        puts "Would you like to play again? [Y/N]"
        if gets.chomp.upcase == 'Y'
            game = Game.new(@player1, @player2)
        else
            display_board
            puts "Thanks for playing!"
        end
    end

    def display_board
        clear
        puts "#{board[0]} | #{board[1]} | #{board[2]}"
        puts "---+---+---"
        puts "#{board[3]} | #{board[4]} | #{board[5]}"
        puts "---+---+---"
        puts "#{board[6]} | #{board[7]} | #{board[8]}"
    end
end

class Player
    attr_accessor :name, :game_piece

    @@other_game_piece = ""

    def initialize(player_number)
        set_player_name(player_number)
        set_game_piece
    end

    def set_player_name(player_number)
        puts "Player #{player_number}: What is your name?"
        @name = gets.chomp.capitalize
    end

    def set_game_piece
        piece_set = false

        until piece_set
            puts "#{@name}: Choose any letter to represent your game piece."
            puts "It cannot be #{@@other_game_piece}" if @@other_game_piece != ""
            @game_piece = gets.chomp.upcase

            if @game_piece =~ /^[A-Z]\b/ && @game_piece != @@other_game_piece
                @@other_game_piece = @game_piece
                piece_set = true
            else
                puts "Invalid game piece, please choose a single letter."
            end
        end
    end
end

def clear
    print "\e[2J\e[H"
end

player1 = Player.new(1)
player2 = Player.new(2)
game = Game.new(player1, player2)