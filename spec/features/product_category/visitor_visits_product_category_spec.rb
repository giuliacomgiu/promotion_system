require 'rails_helper'

feature 'Visitor visits product category page' do
  scenario 'and is redirected to authentication page' do
    visit product_categories_path

    expect(page).to have_current_path new_user_session_path, ignore_query: true
  end
end
