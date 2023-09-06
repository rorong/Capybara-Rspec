# frozen_string_literal: true

require 'rails_helper'

# rspec spec/system/auth/signup_spec.rb
# use above command to run the tests

RSpec.describe 'User Sign Up', type: :system do
  let(:user_attributes) do
    {
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    }
  end

  before do
    # Create a user for testing
    @user = User.create(user_attributes)
  end

  scenario 'User signs up with valid information' do
    visit new_user_registration_path

    fill_in 'Email', with: 'test1@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    click_button 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  scenario 'User fails to sign up with short password' do
    visit new_user_registration_path

    fill_in 'Email', with: 'invalid@gmail.com'
    fill_in 'Password', with: 'pass' # Short password
    fill_in 'Password confirmation', with: 'wrong-password'
    click_button 'Sign up'
    expect(page).to have_content('Password is too short')
  end

  scenario 'User attempts to sign up with an existing email' do
    visit new_user_registration_path

    fill_in 'Email', with: 'test@example.com' # Existing email
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    click_button 'Sign up'

    expect(page).to have_content('Email has already been taken')
  end

  scenario 'User attempts to sign up with mismatched password and confirmation' do
    visit new_user_registration_path

    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'wrong-password' # Mismatched confirmation

    click_button 'Sign up'

    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  scenario 'User signs in with valid credentials' do
    visit new_user_session_path

    fill_in 'Email', with: user_attributes[:email] # Use the predefined email
    fill_in 'Password', with: user_attributes[:password] # Use the predefined password

    click_button 'Log in'

    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'User fails to sign in with invalid credentials' do
    visit new_user_session_path

    fill_in 'Email', with: user_attributes[:email] # Use the predefined email
    fill_in 'Password', with: 'wrong-password' # Invalid password

    click_button 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end

  scenario 'User attempts to sign in with non-existent email' do
    visit new_user_session_path

    fill_in 'Email', with: 'nonexistent@example.com' # Non-existent email
    fill_in 'Password', with: 'password'

    click_button 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end
end
