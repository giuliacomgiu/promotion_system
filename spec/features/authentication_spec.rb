require 'rails_helper'

feature 'Log in' do
  scenario 'and show welcome message' do
    User.create!(email: 'teste@email.com', password: 'teste1')

    visit root_path
    click_on 'Login'
    fill_in 'Email', with: 'teste@email.com'
    fill_in 'Senha', with: 'teste1'
    click_on 'Entrar'

    expect(current_path).to eq(root_path)
    # expect(page).to have_content('Login efetuado com sucesso')
    expect(page).to have_content('teste@email.com')
    expect(page).not_to have_link('Login')
    expect(page).to have_link('Sair')
  end

  scenario 'and logout' do
    User.create!(email: 'teste@email.com', password: 'teste1')

    visit root_path
    click_on 'Login'
    fill_in 'Email', with: 'teste@email.com'
    fill_in 'Senha', with: 'teste1'
    click_on 'Entrar'
    click_on 'Sair'

    expect(current_path).to eq(root_path)
    # expect(page).to have_content('Login efetuado com sucesso')
    expect(page).not_to have_content('teste@email.com')
    expect(page).to have_link('Login')
    expect(page).not_to have_link('Sair')
  end
end
