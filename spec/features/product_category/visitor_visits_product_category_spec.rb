require 'rails_helper'

feature 'Visitor visits product category page' do
  scenario 'and is redirected to authentication page' do
    visit product_categories_path

    expect(current_path).to eq new_user_session_path
  end
end
