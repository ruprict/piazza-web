require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jerry)
  end

  test 'user is logged in and redirected to home with correct creds' do
    assert_difference('@user.app_sessions.count', 1) do
      log_in(@user)
      assert_not_empty cookies[:app_session]
      assert_redirected_to root_path
    end
  end

  test 'error is rendered with incorrect creds given' do
    assert_no_difference('@user.app_sessions.count') do
      post login_path, params: {
        user: {
          email: 'adasay@example.com',
          password: 'padsassword'
        }
      }
    end
    assert_select '.notification', I18n.t('sessions.create.incorrect_details')
  end

  test 'logging out redirects to the root url and deletes the sesssion' do
    log_in(@user)

    assert_difference('@user.app_sessions.count', -1) { log_out }
    assert_redirected_to root_path
    follow_redirect!

    assert_select '.notification', I18n.t('sessions.destroy.success')
  end

  test 'providing remember me creates a cookie' do
    log_in(@user, password: 'password', remember_me: '1')
    assert_not_empty cookies[:app_session]
  end

  test 'no providing remember me does not create a cookie' do
    log_in(@user, password: 'password', remember_me: '0')
    assert_nil cookies[:app_session]
  end
end
