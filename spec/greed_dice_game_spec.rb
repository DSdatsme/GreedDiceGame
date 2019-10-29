require 'rspec'
require './greed_dice_game.rb'

RSpec.describe 'Player' do
    
    it "getting & setting in_the_game" do
        player_object = Player.new

        expect(player_object.get_is_in_the_game).to eql(false)
        player_object.set_is_in_the_game(true)
        expect(player_object.get_is_in_the_game).to eql(true)
    end

    it "get & update player score" do
        player_object = Player.new

        expect(player_object.get_player_score).to eql(0)
        player_object.set_player_score(10292022393)
        expect(player_object.get_player_score).to eql(10292022393)
    end
end

RSpec.describe 'Game' do
    # it "testing take_turn method" do
    #     game_object = Game.new(2)
    #     # allow(game_object).to receive(:gets).and_return('n')
    #     # game_object.stub(gets:).and_return("n")
    #     allow(STDIN).to receive(:gets).and_return("n")
    #     expect(game_object.take_turn(0)).to eql(100)
    # end

    it "score calculator test" do
        game_object = Game.new(1)

        expect(game_object.score_calculator([1, 2, 1, 2, 5])).to eql([250,2])
        expect(game_object.score_calculator([1, 1, 1, 1, 1])).to eql([1200,0])
        expect(game_object.score_calculator([2, 3, 4, 2, 6])).to eql([0,5])
    end

    it "dice roll validation" do
        game_object = Game.new(1)

        expect(game_object.roll_dice(3).length).to eql(3)
        expect(game_object.roll_dice().length).to eql(5)
    end

    it "get number of players" do
        game_object = Game.new(123456)
        expect(game_object.get_number_of_players).to eql(123456)

        game_object = Game.new(4)
        expect(game_object.get_number_of_players).to eql(4)
    end

    it "get all score" do
        game_object = Game.new(7)
        expect(game_object.get_all_score.length).to eql(7)
        expect(game_object.get_all_score).to eql([0,0,0,0,0,0,0])
    end

end