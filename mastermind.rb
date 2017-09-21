require 'sinatra'
require './helpers.rb'
require 'byebug' if development?

enable :sessions

get '/' do
    
    init if session[:game].nil?
    
    code_key = get_code_key
    game_keys = get_game_keys

    erb :codebreaker, :locals => { :code => session[:secret], :code_key => code_key, :game_keys => game_keys }
end

post '/' do
    
    check_guess(params)
    
    if game_over? 
        redirect to('/gameover')
    else
        redirect to('/')
    end
end

get '/gameover' do

    message  = get_gameover_message
    
    erb :gameover, :locals => { :message => message }
    
end

get '/reset' do
    
    end_game

    redirect to('/')
    
end
