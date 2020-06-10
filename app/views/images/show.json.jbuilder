json.partial! 'images/image', image: @image
json.users @user.users do |user|
  json.partial! 'users/user', user: user
end
