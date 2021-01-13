require 'rails_helper'

feature 'Visitor visits promotion page' do
  scenario 'and is redirected to authentication page' do
    visit promotions_path

    expect(current_path).to eq new_user_session_path
  end
end
