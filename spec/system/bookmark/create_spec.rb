# frozen_string_literal: true

require 'rails_helper'

# rspec spec/system/bookmark/create_spec.rb
# use above command to run the tests

RSpec.describe 'create bookmark', type: :system do
  scenario 'empty title and url' do
    visit new_bookmark_path
    click_button 'Create Bookmark'

    expect(page).to have_content("Title can't be blank")

    expect(Bookmark.count).to eq(0)
  end

  scenario 'valid title and url' do
    visit new_bookmark_path
    fill_in 'Title', with: 'RubyonRails'
    fill_in 'Url', with: 'https://google.com'
    click_button 'Create Bookmark'

    expect(page).to have_content('Bookmark was successfully created')

    expect(Bookmark.count).to eq(1)

    expect(Bookmark.last.title).to eq('RubyonRails')
  end
end
