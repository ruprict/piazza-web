module AuthenticationHelpers
  def log_in(user, password: 'password', remember_me: '1')
    post login_path, params: {
      user: {
        email: user.email,
        password:,
        remember_me:
      }
    }
  end

  def log_out
    delete logout_path
  end
end
