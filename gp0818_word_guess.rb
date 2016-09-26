######### M&M's Word Guess game ########
#########   by Maya & Miriam   #########
#### featuring words from Faker gem ####
# difficulty level depends on topic chosen (Pokemon might be very for some people and very hard for others)
# number of chances corresponds to 85% of the length of the word (we thought this was fair)
# We color-coded our messages for correct guesses (green), incorrect guesses (red), and guesses previously made (blue)
# ASCII art shows user's last 4 chances
# multiple guesses of the same incorrect letters are not penalized and shown in blue
# multiple guesses of same correct letters are ignored
# user has the option to guess the whole word. If it's incorrect it's treated as just one penalty
# letters that are included in the word more than once are all shown during the first guess of the letter
# User receives a warning for improper input
# display space character when first present the word to the user

require 'faker'
require 'rainbow'

class Hangman
  attr_accessor :letter, :word

  def initialize()
    @word_to_guess = "" #this is the word we want the user to guess
    @array_of_words_to_guess = [] # this is where the word is coming from- contains a bank of words
    @letters_of_word = [] # array of letters in the word, in the proper order ROOM => ["R","O","O","M"]
    @chances #how many chances the user has to be wrong
    @correct_letters = [] #this is the display array for
    @incorrect_letters = [] #bank of letters already guessed and were incorrect
    @letters_included_array = []
    @theme = ""
    @entire_word #variable for if user wants to guess the entire word

  end

  def generate_new_word #user can guess based on three themes: musical instruments, pokemons, & constellations
    while true
      puts "Please input a number to select a theme of words:"
      puts "1.music instrument\n2.Pokemon\n3.constellation\n4.Star Wars Characters"
      @theme = gets.chomp
      case @theme
      when "1"
        @word_to_guess = Faker::Music.instrument.upcase
        break
      when "2"
        @word_to_guess = Faker::Pokemon.name.upcase
        break
      when "3"
        @word_to_guess = Faker::Space.constellation.upcase
        break
      when "4"
        @word_to_guess = Faker::StarWars.character.upcase
        break
      else
        puts "Sorry, please enter a valid number of theme."
      end
      # puts @word_to_guess
    end
  end

  def display_word_to_guess
    # puts "The words has #{@word_to_guess.length} letters."
    @letters_of_word = @word_to_guess.split("") #splits letters into an array
    @word_to_guess.length.times do # new array with blanks instead of letters for display
      @correct_letters << "_"
    end
    display_duplicate_letters(" ") #displays spaces in words so user doesn't have to guess a space
    #puts @correct_letters.join(" ")
    @chances = (@word_to_guess.length * 0.85).to_i
  end

  def get_letter_from_user #input from user on what letter they think is in the word
    while true
      print "What letter do you want to guess? If you'd like to guess the whole word then type 'whole word' "
      letter = gets.chomp.upcase
      if letter == "WHOLE WORD"
        guess_entire_word
      elsif letter.length == 1 && letter.index(/[a-zA-Z ]/) != nil
        self.guess_letter(letter)
        # use self. refers to the object that currently called on(e.g. here is game.)
        # usually use when member method call another member method within the same class
        # self. can be obmit in ruby.
      else
        puts "That's not ONE LETTER!"
      end
    end
  end

  def guess_letter(letter)
    is_correct_guess = @word_to_guess.include?(letter) #checks if letter is included in word
    if is_correct_guess
      self.display_duplicate_letters(letter) # if the letter is included it'll check in the duplicate letter method & display them all
      if @correct_letters == @word_to_guess.split("")
        puts "YOU WIN!!!!\n\n"
        exit
      end
    elsif @incorrect_letters.include?(letter)
      puts Rainbow("You already guessed that letter...and it's wrong. I won't punish you this time!").blue.bg(:white)
    else
      @incorrect_letters << letter
      @chances -= 1
      puts Rainbow("Nope; you have #{@chances} chances left.").red.bg(:white)
      self.flower(@chances) #ASCII art based on how many chances are left
      if @chances == 0
        puts "You lost."
        puts "The word was #{@word_to_guess}."
        exit
      end
    end
    sorted_incorrect_letters = @incorrect_letters.sort_by {|incorrect_letter| incorrect_letter.upcase} #gives incorrect letters guessed in alpha order
    puts "Incorrect Letters: #{Rainbow(sorted_incorrect_letters.join(" ")).red}"
  end

  def display_duplicate_letters(letter)
    while true
      index = @letters_of_word.index(letter)
      if index == nil
        break
      end
      @letters_of_word[index] = "~"
      @correct_letters[index] = letter
    end
    puts "The word is: #{Rainbow(@correct_letters.join(" ")).green.bg(:white)}"
  end

  def guess_entire_word()
    print "What do you think the word is? "
    @entire_word = gets.chomp.upcase
    if @entire_word == @word_to_guess
      puts "That's right! You win! You are so smart! How did you do it?!?!?! "
      exit
    else
      guess_letter(@entire_word)
    end
  end

  def flower(chances)
    @chances = chances
    case @chances
    when 4
      puts """
      (@)(@)(@)(@)
       ,\\,\\,|,/,/,
          _\\|/_
         |_____|
          |   |
          |___|
   """
    when 3
     puts """
     (@)(@)(@)
      ,\\,\\,|,/,/,
         _\\|/_
        |_____|
         |   |
         |___|
     """
    when 2
      puts """
      (@)(@)
       ,\\,\\,|,/,/,
          _\\|/_
         |_____|
          |   |
          |___|
   """
    when 1
     puts """
     (@)
      ,\\,\\,|,/,/,
         _\\|/_
        |_____|
         |   |
         |___|
  """
    when 0
      puts """
       ,\\,\\,|,/,/,
          _\\|/_
         |_____|
          |   |
          |___|
    """
    else
    end
  end
end

game = Hangman.new()
game.generate_new_word
game.display_word_to_guess
game.get_letter_from_user #guess_letter is called inside this method.
