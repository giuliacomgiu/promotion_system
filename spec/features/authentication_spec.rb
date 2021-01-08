require 'rails_helper'

feature 'Log in' do
  scenario 'and show welcome message' do
    User.create!(email: 'teste@locaweb.com.br', password: 'teste1')

    visit root_path
    click_on 'Login'
    fill_in 'Email', with: 'teste@locaweb.com.br'
    fill_in 'Senha', with: 'teste1'
    click_on 'Entrar'

    expect(current_path).to eq(root_path)
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

    expect(current_path).to eq(root_path)
    expect(page).not_to have_content('Login efetuado com sucesso')
    expect(page).not_to have_content('teste@locaweb.com.br')
    expect(page).to have_link('Login')
    expect(page).not_to have_link('Sair')
  end
end

feature 'Registers' do
  scenario 'and fails with incorrect domain' do
    visit root_path
    click_on 'Cadastre-se'
    fill_in 'Email', with: 'teste@email.com.br'
    fill_in 'Senha', with: 'teste1'
    fill_in 'Confirme sua senha', with: 'teste1'
    click_on 'Cadastrar'

    expect(current_path).to eq '/users'
    expect(page).to have_content('Email não é válido')
  end

  scenario 'and password cant be blank' do
    visit new_user_registration_path
    fill_in 'Email', with: 'teste@locaweb.com.br'
    fill_in 'Senha', with: ''
    fill_in 'Confirme sua senha', with: ''
    click_on 'Cadastrar'

    expect(current_path).to eq '/users'
    expect(page).to have_content('Password não pode ficar em branco')
  end

  scenario 'successfully' do
    visit new_user_registration_path
    fill_in 'Email', with: 'teste@locaweb.com.br'
    fill_in 'Senha', with: 'teste1'
    fill_in 'Confirme sua senha', with: 'teste1'
    click_on 'Cadastrar'

    expect(page).to have_content('Login efetuado com sucesso')
    expect(page).to have_content('teste@locaweb.com.br')
    expect(page).not_to have_link('Login')
    expect(page).to have_link('Sair')
  end
end
