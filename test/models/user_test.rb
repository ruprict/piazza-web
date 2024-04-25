require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'requires a name' do
    @user = User.new(name: '', email: 'fred@bedrockisp.com', password: 'password')
    assert_not @user.valid?
    @user.name = 'Fred'
    assert @user.valid?
  end

  test 'requires a valid email' do
    @user = User.new(name: 'Fred', email: '', password: 'password')
    assert_not @user.valid?
    @user.email = 'afdacom'
    assert_not @user.valid?
    @user.email = 'fred@bedrockisp.com'
    assert @user.valid?
  end

  test 'requires a unique email' do
    @existing_user = User.create(name: 'Wilma', email: 'fred@bedrockisp.com', password: 'password')
    assert @existing_user.persisted?
    @user = User.new(name: 'Fred', email: 'fred@bedrockisp.com', password: 'password')
    assert_not @user.valid?
  end

  test 'name and email remove spaces before saving' do
    @user = User.create(
      name: ' John   ',
      email: '  john@email.com ',
      password: 'password'
    )
    assert_equal 'John', @user.name
    assert_equal 'john@email.com', @user.email
  end

  test 'password length must be between 8 and ActiveModel maximum' do
    @user = User.new(
      name: 'Jane',
      email: 'janedoe@example.com', password: ''
    )
    assert_not @user.valid?
    @user.password = 'password'
    assert @user.valid?
    max_length = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    @user.password = 'a' * (max_length + 1)
    assert_not @user.valid?
  end

  test 'can create an app_session with user and pass' do
    @app_session = User.create_app_session(
      email: 'jerry@example.com',
      password: 'password'
    )

    assert_not_nil @app_session
    assert_not_nil @app_session.token
  end

  test 'cannot create a session with email and incorrect password' do
    @app_session = User.create_app_session(
      email: 'jerry@example.com',
      password: 'wrongpass'
    )

    assert_nil @app_session
  end

  test 'cannot create a session with non-existant email' do
    @app_session = User.create_app_session(
      email: 'newman@example.com',
      password: 'password'
    )

    assert_nil @app_session
  end

  test 'can authenticate wiht a valid session and token' do
    @user = users(:jerry)
    @app_session = @user.app_sessions.create

    assert_equal @app_session, @user.authenticate_app_session(@app_session.id, @app_session.token)
  end

  test "trying to authenticate with a token that doesn't exist returns false" do
    @user = users(:jerry)

    assert_not @user.authenticate_app_session('40', 'token')
  end
end
