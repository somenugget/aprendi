RSpec.describe 'Dashboard reminder logins' do
  let(:user) { create(:user) }
  let(:token) { UserAuthToken.create_for_user(user, meta: { purpose: 'reminder_login' }) }

  it 'signs in the recipient and redirects to the dashboard' do
    get dashboard_path(token: token)

    expect(response).to redirect_to(dashboard_path)
    expect(controller.current_user).to eq(user)
    expect(UserAuthToken.find_by_token(token)).to be_nil
    expect(response.headers['Cache-Control']).to include('no-store')
  end

  it 'rejects a used token' do
    get dashboard_path(token: token)
    sign_out user

    get dashboard_path(token: token)

    expect(response).to redirect_to(new_user_session_path)
    expect(controller.current_user).to be_nil
  end

  it 'rejects an expired token' do
    UserAuthToken.find_by_token(token).update!(expires_at: 1.second.ago)

    get dashboard_path(token: token)

    expect(response).to redirect_to(new_user_session_path)
    expect(controller.current_user).to be_nil
  end

  it 'rejects tokens created for another purpose' do
    other_token = UserAuthToken.create_for_user(user)

    get dashboard_path(token: other_token)

    expect(response).to redirect_to(new_user_session_path)
    expect(controller.current_user).to be_nil
    expect(UserAuthToken.find_by_token(other_token)).to be_present
  end

  it 'rejects an invalid token' do
    get dashboard_path(token: 'invalid')

    expect(response).to redirect_to(new_user_session_path)
    expect(controller.current_user).to be_nil
  end

  it 'requires normal login without a token' do
    get dashboard_path

    expect(response).to redirect_to(new_user_session_path)
  end
end
