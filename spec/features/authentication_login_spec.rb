require 'rails_helper'

feature 'Log in' do
  scenario 'and show welcome message' do
    User.create!(email: 'teste@locaweb.com.br', password: 'teste1')

    visit root_path
    click_on 'Login'
    fill_in 'Email', with: 'teste@locaweb.com.br'
    fill_in 'Senha', with: 'teste1'
    click_on 'Entrar'

    expect(page).to have_current_path(root_path, ignore_query: true)
    expect(page).to have_content('Login efetuado com sucesso')
    expect(page).to have_content('teste@locaweb.com.br')
    expect(page).not_to have_link('Login')
    expect(page).to have_link('Sair')
  end

  scenario 'and logout' do
    User.create!(email: 'teste@locaweb.com.br', password: 'teste1')

    visit root_path
    click_on 'Login'
    fill_in 'Email', with: 'teste@locaweb.com.br'
    fill_in 'Senha', with: 'teste1'
    click_on 'Entrar'
    click_on 'Sair'

    expect(page).to have_current_path(new_user_session_path, ignore_query: true)
    expect(page).not_to have_content('Login efetuado com sucesso')
    expect(page).not_to have_content('teste@locaweb.com.br')
    expect(page).to have_link('Login')
    expect(page).not_to have_link('Sair')
  end
end
