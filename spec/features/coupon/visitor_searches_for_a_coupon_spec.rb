require 'rails_helper'

feature 'Visitor searches for coupon' do
  scenario 'and fails' do
    visit "#{search_coupons_path}?search=pascoa&commit=Buscar"

    expect(current_path).to eq new_user_session_path
  end
end
