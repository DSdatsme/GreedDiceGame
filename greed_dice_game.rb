
### Tweakable variables as per desired problem statement.

# score required to enter final round.
END_GAME_SCORE= 3000

# score required from a player to start accumulating points.
FIRST_TURN_MIN_SCORE = 300

# minimum number of players required to start the game.
MIN_PLAYERS_REQUIRED = 2

# score for three 1's.
SCORE_FOR_ONES_TRIPLET = 1000

# score muktipler for triplet for numbers other than 1.
SCORE_FOR_OTHER_NUMBERS_TRIPLET = 100

# score for single occurance of 1.
SCORE_FOR_SINGLE_ONE =100

# score for single occurance of 5.
SCORE_FOR_SINGLE_FIVE = 50


class Game
    # contains methods and vars which holds the state if the game.
    
    def initialize(number_of_players)
        @number_of_players = set_number_of_players(number_of_players)
        @score = Array.new(number_of_players, 0)    # for storing total score of all players inn that gaming session
    end

    # getter for all score
    def get_all_score
        @score
    end
    
    # setter for number_of_players
    def set_number_of_players(number_of_players)
        @number_of_players = number_of_players
    end

    # getter for number_of_players
    def get_number_of_players
        @number_of_players
    end

    # method to roll the dice randomly
    def roll_dice(n=5)
        set = []
        n.times { set.push rand(1..6) }
        set
    end

    # gets you the score for a particular player
    def get_total_score_for_player(player_id)
        @score[player_id]
    end

    # core scoring mechanism
    def score_calculator(dice_heads)
        turn_score = 0
        non_scoring_counter = 0
        dice_heads.each do |dice_value|
            if dice_heads.count(dice_value) >= 3
                # score for all numbers with occurance of atleast thrice
                if dice_value == 1
                    # special case defined for head value '1'
                    turn_score += SCORE_FOR_ONES_TRIPLET
                else
                    # generic for all other numbers
                    turn_score += dice_value * SCORE_FOR_OTHER_NUMBERS_TRIPLET
                    if dice_value != 5 then non_scoring_counter -= 3 end
                end
                # 
            end
            if dice_value == 1 or dice_value == 5
                if dice_value == 1
                    turn_score += (dice_heads.count(dice_value) % 3) * SCORE_FOR_SINGLE_ONE
                else
                    turn_score += (dice_heads.count(dice_value) % 3) * SCORE_FOR_SINGLE_FIVE
                end
            else
                non_scoring_counter += 1
            end
            
            # FIXME: Below line doesnt work. Figure out why?
            # dice_heads.delete(dice_value) #on value [1, 2, 1, 2, 5]
            dice_heads -= [dice_value]
        end
        return turn_score, non_scoring_counter
    end

    def take_turn(player_id, turn_size=5)
=begin
        INFO: 
        
        INPUT:
        
        OUTPUT:
        returns the score player got in current turn
=end

        temp_player_dice_result = roll_dice(turn_size)
        puts "Player #{player_id + 1} rolls: #{temp_player_dice_result.join(",")}"
        
        temp_player_dice_score, non_scoring_dice = score_calculator(temp_player_dice_result)
        puts "Score in this round: #{temp_player_dice_score}"

        # @score[player_id] += temp_player_dice_score
        puts "Total score: #{@score[player_id]}"

        if temp_player_dice_score == 0
            raise "Player lost the score for this turn!"
        else
            if non_scoring_dice > 0
                user_selection = ''
                
                until user_selection == 'y' or user_selection == 'n'
                print "Do you want to roll the non-scoring #{non_scoring_dice} dices?(y/n): "
                user_selection = gets.chomp!.downcase
                end
                
                if user_selection == 'y'
                    temp_player_dice_score += take_turn(player_id, non_scoring_dice)
                elsif user_selection == 'n'
                    return temp_player_dice_score
                end
            else
                return temp_player_dice_score
            end
        end
    end
=begin
=end  
    def main_game
        
        # init required variables
        is_completed = false
        is_final_round = false
        turn_counter = 1
        is_in_the_game = Array.new(@number_of_players, false) # flag to check if player has scored 300/+ for the first time
        
        until is_completed
            
            if is_final_round then puts "Final round" else puts "Turn: #{turn_counter}" end
            puts "--------"
            
            @number_of_players.times {
                |player_id|
                if (@score.each_with_index.max[1] != player_id and is_final_round) or not is_final_round
                    begin
                        turn_score = take_turn(player_id)
                    rescue
                        turn_score = 0
                    end
                    # change the flag to true when a player scores 300 or above for the first time.
                    if not is_in_the_game[player_id] and turn_score >= FIRST_TURN_MIN_SCORE
                        is_in_the_game[player_id] = true
                    end
                    if turn_score != 0 and is_in_the_game[player_id]
                        @score[player_id] += turn_score
                    end
                end
                puts ""
            }

            turn_counter += 1
            
            if is_final_round
                is_completed = true
            end
            
            if @score.max >= END_GAME_SCORE
                is_final_round = true
            end
        
        
        end # of until
    end # of main_game
end # of class

# variable use to test your scoring mechanism mannualy
want_to_test = false


if not want_to_test
    print "Enter number of players: "
    game_object = Game.new(gets.to_i)

    if game_object.get_number_of_players >= MIN_PLAYERS_REQUIRED
        puts "starting the game"
        game_object.main_game
        puts "final scores are:"
        puts game_object.get_all_score
        #TODO: handle draw situation
        puts "Winner of this game is: Player #{game_object.get_all_score.each_with_index.max[1] + 1}"

    else
        puts "Insufficient players to start the game ):"
    end
else
    # Testing code here
    game_object = Game.new(2)
    puts game_object.score_calculator([5,4,2,4,4])


# puts game_object.get_number_of_players
# x =game_object.roll_dice()
# puts "dice role gave #{x}"

# puts "final score: #{game_object.score_calculator(x)}"
end