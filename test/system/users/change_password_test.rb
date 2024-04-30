require 'application_system_test_case'

class ChangePasswordTest < ApplicationSystemTestCase
  test 'user can change password' do
    @user = users(:jerry)
    log_in(@user)

    visit profile_path

    fill_in User.human_attribute_name(:password_challenge), with: 'password'
    fill_in User.human_attribute_name(:password), with: 'new_password'

    click_on I18n.t('users.show.change_password_button')

    assert_not_nil User.authenticate_by(email: @user.email, password: 'new_password')
  end
end
