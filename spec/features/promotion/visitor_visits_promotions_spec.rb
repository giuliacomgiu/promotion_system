require 'rails_helper'

feature 'Visitor visits promotion page' do
  scenario 'and is redirected to authentication page' do
    visit promotions_path

    expect(page).to have_current_path new_user_session_path, ignore_query: true
  end

  scenario 'and cant search for a promotion' do
    visit "#{search_promotions_path}?search=pascoa&commit=Buscar"

    expect(page).to have_current_path new_user_session_path, ignore_query: true
  end
end
