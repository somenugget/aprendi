RSpec.describe 'Home' do
  it 'renders the landing page with the dark mode toggle for visitors' do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('aria-label="Toggle dark mode"')
  end

  it 'renders the landing page for signed-in users' do
    sign_in create(:user)

    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Go to Dashboard')
  end
end
