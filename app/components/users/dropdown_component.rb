# app/components/user_dropdown_component.rb
class Users::DropdownComponent < ViewComponent::Base
  attr_reader :user

  def initialize(user:)
    @user = user
  end
end
