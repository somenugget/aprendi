class UserParamsFromAuth < BaseService
  input :provider, type: String
  input :auth, type: OmniAuth::AuthHash

  # convert the auth hash to a hash of user params
  # @return [Hash]
  def call
    send(provider.downcase)
  end

  private

  def google_oauth2
    {
      provider: provider,
      uid: auth.uid,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      email: auth.info.email
    }
  end

  def facebook
    first_name, last_name = auth.info.name.split

    {
      provider: provider,
      uid: auth.uid,
      first_name: first_name,
      last_name: last_name,
      email: auth.info.email
    }
  end
end
