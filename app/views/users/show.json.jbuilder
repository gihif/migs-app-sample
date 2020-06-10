json.partial! 'users/user', user: @user
json.images @user.images do |image|
  json.partial! 'images/image', image: image
end
