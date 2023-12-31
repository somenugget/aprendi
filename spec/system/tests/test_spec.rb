require 'system_helper'

describe 'Test' do
  let(:user) { create(:user) }
  let!(:study_set) { create(:study_set, user: user, name: 'My study set') }
  let!(:term) { create(:term, study_set: study_set, term: 'term', definition: 'definition') }

  let(:latest_test) { user.tests.order(:created_at).last }

  def latest_test_step_in_progress
    latest_test.test_steps.where(status: 'in_progress').order(:id).last
  end

  before do
    login_as(user)
  end

  it 'allows to pass the test' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    visit study_set_path(study_set)

    click_button('Learn this set')

    sleep 1

    expect(latest_test_step_in_progress).to be_pick_term
    expect(page).to have_current_path(test_test_step_path(latest_test, latest_test_step_in_progress))

    find('label', text: term.term).click
    click_button('Check')
    click_link('Next step')

    expect(latest_test_step_in_progress).to be_pick_definition
    expect(page).to have_current_path(test_test_step_path(latest_test, latest_test_step_in_progress))

    find('label', text: term.definition).click
    click_button('Check')
    click_link('Next step')

    expect(latest_test_step_in_progress).to be_letters
    expect(page).to have_current_path(test_test_step_path(latest_test, latest_test_step_in_progress))

    term.term.chars.each do |letter|
      within('[data-testid="letters"]') do
        click_button(letter)
      end
    end

    click_button('Next step')

    expect(latest_test_step_in_progress).to be_write_term
    expect(page).to have_current_path(test_test_step_path(latest_test, latest_test_step_in_progress))

    fill_in('test_step_answer_term', with: term.term)

    click_button('Submit')

    expect(page).to have_content('4 of 4 exercises passed without errors')
    expect(page).to have_content('Great job!')
  end
end
