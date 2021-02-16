require 'rails_helper'

feature 'Visitor searches for coupon' do
  scenario 'and fails' do
    visit "#{search_coupons_path}?search=pascoa&commit=Buscar"

    expect(page).to have_current_path new_user_session_path, ignore_query: true
  end
end
