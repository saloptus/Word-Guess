#secret_word
# - initialize
#   = create with the word
# - return the word
#_add_a_aguess
#  - give it a stirng
#- get the hidden viersion of the word
#- get if it's completed#
#  - true or false


def test_start
  word = SecretWord.new("bob")
  assert "bob" == word.get_word
end

def test_hidden_version
  word = secret_word.new("harriet")
  word.add_a_guess("p")
  word.add_a_guess("h")
  assert(word.get_hidden_version == "h-----")
