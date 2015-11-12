require 'rails_helper'

feature 'Destroy Anser', %q{
  In order to destroy answer
  For Answer Owner
  I want to destroy answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }

end
