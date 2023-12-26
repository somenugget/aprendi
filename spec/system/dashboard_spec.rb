require 'system_helper'

describe 'Dashboard' do
  before do
    login_as(create(:user))
  end

  it 'shows empty page' do
    # Visit the home page
    visit root_path

    expect(page).to have_content('add some new words')
  end
end
