require 'rails_helper'

feature 'Admin views product category' do
  scenario 'successfully' do
    ProductCategory.create!(name: 'Hospedagem', code: 'HOSP')
    ProductCategory.create!(name: 'E-mail', code: 'EMAIL')

    visit root_path
    click_on 'Categorias de produto'

    expect(page).to have_content('Hospedagem')
    expect(page).to have_content('HOSP')
    expect(page).to have_content('E-mail')
    expect(page).to have_content('EMAIL')
    expect(page).to have_link('Voltar', href: root_path)
  end

  xscenario 'and shows empty message' do
  end

  xscenario 'and views details' do
  end
end
