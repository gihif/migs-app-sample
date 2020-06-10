json.images @images do |image|
  json.partial! 'images/image', image: image
end
