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

  test 'can update name and email without password' do
    @user = users(:jerry)
    @user.name = 'Jerry Seinfeld'
    @user.save!

    assert_equal 'Jerry Seinfeld', @user.name
  end

  test 'can update password' do
    @user = users(:jerry)
    @user.password = 'new_password'
    @user.password_challenge = 'password'
    @user.save(context: :password_change)

    assert_not_nil User.authenticate_by(email: @user.email, password: 'new_password')
  end
end
