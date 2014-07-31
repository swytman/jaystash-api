def valid_token? email, token
  user = User.find_by(email: email)
  return false if user.nil?
  return user.check_token(token)
end
