json.partial! 'images/image', image: @image
json.user do
  json.partial! 'users/user', user: @image.user
end
