require 'yaml'

class Game

	def pick_word
		dictionary = File.readlines('5desk.txt')
		dictionary_size = dictionary.length
		word_found = false
		until word_found
			index = Random.new.rand(dictionary_size)
			if (5..12).include?(dictionary[index].length)
				word = dictionary[index]
				word_found = true
			end
		end
		word.downcase
	end

	def draw_hangman(stage)
		puts case stage
		when 0
			''
		when 1
			%q(________)
		when 2
			%q(   |
   |
   |
   | 
   |     
   |
___|\___)
		when 3
			%q(   ________
   |
   |
   |
   | 
   |     
   |
___|\___)
		when 4
			%q(   ________
   |      |
   |
   |
   | 
   |     
   |
___|\___)
		when 5
			%q(   ________
   |/     |
   |      O
   |
   |
   |
   |
___|\___)
		when 6
			%q(   ________
   |/     |
   |      O
   |     \+/
   |
   |
   |
___|\___)
		when 7
			%q(   ________
   |/     |
   |      O
   |     \+/
   |      |
   |     / \
   |
___|\___)
		end
	end

	def draw_word_so_far
		letters_not_guessed = ('a'..'z').to_a
		if @guessed_letters
			@guessed_letters.each do |letter|
				letters_not_guessed.delete(letter)
			end
		end
		disguised_word = @word.split(//).join(' ')
		letters_not_guessed.each do |letter|
			disguised_word.gsub!(letter, '_')
		end
		disguised_word
	end

	def check_entry(guess)
		if guess.length != 1
			puts "That's not a single letter"
			false
		elsif @guessed_letters.include?(guess.downcase)
			puts "You already guessed that"
		elsif ('a'..'z').to_a.include?(guess.downcase)
			true
		elsif guess == '1'
			true
		else
			false
		end
	end

	def check_guess(guess)
		@guessed_letters << guess
		if @word.include?(@guess)
			puts "You found a letter!"
		else
			puts "Uh oh, that's not in there!"
			@stage += 1
		end

		if !draw_word_so_far.include?('_')
			puts "You won!"
			puts draw_word_so_far
			@game_over = true
		elsif @stage == 7
			puts "You ran out of guesses, he's dead :("
			puts "The word was #{@word}."
			@game_over = true
		end

	end

	def save_game
		save_data = YAML::dump([@word, @guessed_letters, @stage])
		save_file = File.new("hangman_save", "w")
		save_file.puts save_data
		save_file.close
	end

	def initialize(word='0', guessed_letters=[], stage=0)
		if word == '0'
			@word = pick_word.chomp
		else
			@word = word
		end
		@word_so_far = draw_word_so_far
		@guessed_letters = guessed_letters
		@stage = stage
		@game_over = false

		until @game_over
			@word_so_far = draw_word_so_far
			puts @word_so_far
			puts "Guessed letters: #{@guessed_letters}"
			valid_entry = false
			puts "Pick a letter or type '1' to save"
			until valid_entry
				@guess = gets.chomp
				valid_entry = check_entry(@guess)
			end
			@guess = @guess.downcase
			if @guess == '1'
				save_game
				@game_over = true
				puts "Game saved"
			else
				check_guess(@guess)
			end
			draw_hangman(@stage)
		end
	end
end

class GameStarter
	def check_choice(choice)
		choice == '1' || choice == '2'
	end

	def initialize
		puts "Welcome to hangman!"
		valid_choice = false
		until valid_choice
			puts "Type '1' for a new game or '2' to load a game..."
			@choice = gets.chomp
			valid_choice = check_choice(@choice)
		end

		if @choice == '1'
			new_game = Game.new
		elsif @choice == '2'
			if File.exist?("hangman_save")
				save_data_raw = ''
				File.open("hangman_save").each do |line|
					save_data_raw << line
				end
				save_data = YAML::load(save_data_raw) 
				Game.new(save_data[0], save_data[1], save_data[2])
			else
				puts "No save file found, starting new game..."
				Game.new
			end
		end
	end
end

GameStarter.new