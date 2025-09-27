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

    click_link_or_button('Whole set')

    sleep 1

    expect(latest_test_step_in_progress).to be_pick_term
    expect(page).to have_current_path(test_test_step_path(latest_test, latest_test_step_in_progress))

    find('label', text: term.term).click
    click_link_or_button('Check')
    click_link_or_button('Next step')

    expect(latest_test_step_in_progress).to be_pick_definition
    expect(page).to have_current_path(test_test_step_path(latest_test, latest_test_step_in_progress))

    find('label', text: term.definition).click
    click_link_or_button('Check')
    click_link_or_button('Next step')

    expect(latest_test_step_in_progress).to be_letters
    expect(page).to have_current_path(test_test_step_path(latest_test, latest_test_step_in_progress))

    term.term.chars.each do |letter|
      within('[data-testid="letters"]') do
        click_link_or_button(letter)
      end
    end

    click_link_or_button('Next step')

    expect(latest_test_step_in_progress).to be_write_term
    expect(page).to have_current_path(test_test_step_path(latest_test, latest_test_step_in_progress))

    fill_in('test_step_answer_term', with: term.term)

    click_link_or_button('Submit')

    expect(page).to have_content('4 of 4 exercises passed without errors')
    expect(page).to have_content('Great job!')
  end

  it 'shows handles failed steps correctly' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    term2 = create(:term, study_set: study_set, term: 'fizz', definition: 'buzz')

    visit study_set_path(study_set)

    click_link_or_button('Whole set')

    sleep 1

    expect(latest_test_step_in_progress).to be_pick_term

    failed_steps_count = 0

    find('label', text: term.term).click
    click_link_or_button('Check')

    failed_steps_count += all('[data-testid="answer_label"][data-result="error"]').count
    click_link_or_button('Next step')

    find('label', text: term.term).click
    click_link_or_button('Check')
    failed_steps_count += all('[data-testid="answer_label"][data-result="error"]').count

    expect(failed_steps_count).to eq(1)
    click_link_or_button('Next step')

    expect(latest_test_step_in_progress).to be_pick_definition

    failed_steps_count = 0
    find('label', text: term.definition).click
    click_link_or_button('Check')
    failed_steps_count += all('[data-testid="answer_label"][data-result="error"]').count

    click_link_or_button('Next step')

    find('label', text: term.definition).click
    click_link_or_button('Check')
    failed_steps_count += all('[data-testid="answer_label"][data-result="error"]').count
    expect(failed_steps_count).to eq(1)

    click_link_or_button('Next step')

    expect(latest_test_step_in_progress).to be_letters

    2.times do
      step_title = find('[data-testid="step_title"]')

      if step_title.text == term.definition
        term.term.chars.each do |letter|
          within('[data-testid="letters"]') do
            click_link_or_button(letter, match: :first)
          end
        end
      else
        # errored char
        within('[data-testid="letters"]') do
          click_link_or_button(term2.term.chars.last, match: :first)
        end

        expect(page).to have_css('input[name="test_step[failed]"][value="true"]', visible: :hidden)

        term2.term.chars.each do |letter|
          within('[data-testid="letters"]') do
            click_link_or_button(letter, match: :first)
          end
        end
      end

      click_link_or_button('Next step')
    end

    expect(latest_test_step_in_progress).to be_write_term

    2.times do
      step_title = find('[data-testid="step_title"]')

      if step_title.text == term.definition
        fill_in('test_step_answer_term', with: term.term)
        click_link_or_button('Submit')
      else
        fill_in('test_step_answer_term', with: "#{term2.term}aaa")
        click_link_or_button('Submit')
        expect(page).to have_css('#test_step_answer_term[data-result="error"]')
      end

      click_link_or_button('Next step')
    end

    # retrying failed steps

    expect(latest_test_step_in_progress).to be_pick_term
    find('label', text: term2.term).click
    click_link_or_button('Check')
    click_link_or_button('Next step')

    expect(latest_test_step_in_progress).to be_pick_definition
    find('label', text: term2.definition).click
    click_link_or_button('Check')
    click_link_or_button('Next step')

    expect(latest_test_step_in_progress).to be_letters

    term2.term.chars.each do |letter|
      within('[data-testid="letters"]') do
        click_link_or_button(letter, match: :first)
      end
    end
    click_link_or_button('Next step')

    expect(latest_test_step_in_progress).to be_write_term
    fill_in('test_step_answer_term', with: term2.term)
    click_link_or_button('Submit')

    expect(page).to have_content('8 of 12 exercises passed without errors')
    expect(page).to have_content('This term needs some extra attention')
    expect(page).to have_content('fizz - buzz')
  end
end
