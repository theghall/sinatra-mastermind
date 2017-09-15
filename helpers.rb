PEGS = %w(BK BU GN RD WH YW)

def init
    init_secret
    
    init_game_session
    
    init_guesses
    
    init_code_key
    
    init_game_keys
end

def init_secret
    session[:secret] = gen_code
end

def init_game_session
    session["game"] = ''
end

def init_guesses
    session[:guesses] = 0
end

def init_code_key
    session[:code_key] = %w(EM EM EM EM)
end

def init_game_keys
    session[:game_keys] = ''
end

def end_game
    session.clear
end

def get_code_key
    session[:code_key]
end

def gen_code
    code = []
    
    4.times do 
        code << PEGS[rand(6)]
    end
    
    code
end

def build_guess(params)
    guess = []
    
    params.each_key do |k|
        break if k == 'captures'
        guess << params[k]
    end
    
    guess
end

def get_secret
    session[:secret]
end

def get_game_keys
    session[:game_keys]
end

def gen_code_key(guess)
    wh_key = []
    bk_key = []
    
    secret = get_secret
    
    # Don't match keys with guesses
    guess.each_with_index do |p, i|
        if p == secret[i]
            wh_key << 'WH'
        elsif secret.include?(p)
            bk_key << 'BK'
        end
    end
    
    code_key = wh_key + bk_key
    
    (4-code_key.length).times do
        code_key << 'EM'
    end
    
    session[:code_key] = code_key
end

def increment_guesses
    session[:guesses] += 1
end

def add_game_keys(code_key)
    session[:game_keys] << '<br>' unless session[:game_keys].empty?
    session[:game_keys] << code_key.join(' ')
end

def check_guess(params)
    increment_guesses
    
    guess = build_guess(params)
    
    gen_code_key(guess)  
    
    add_game_keys(get_code_key)
end

def correct_guess?
    get_code_key.join.scan(/WH/).count == 4
end

def max_guesses?
    session[:guesses] == 10
end

def game_over?
    # only check max_guesses if not correct guess
    correct_guess? || max_guesses?
end

def get_gameover_message
    if correct_guess?
        "You guessed the correct key #{session[:secret].join(' ')}!"
    else
        "You did not get the correct code in 10 turns"
    end
end