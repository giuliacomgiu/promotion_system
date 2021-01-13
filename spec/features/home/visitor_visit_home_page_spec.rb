require 'rails_helper'

feature 'Visitor visits home page' do
  scenario 'successfully' do
    visit root_path

    expect(page).to have_content('Promotion System')
    expect(page).to have_content('Boas vindas ao sistema de gestão de '\
                                 'promoções')
  end

  xscenario 'and doesnt see the website\'s paths' do
    visit root_path

    expect(page).not_to have_link('Promoções', href: promotions_path)
  end
end
