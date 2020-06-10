json.extract! image, :id, :title, :created_at, :updated_at
json.image_url url_for(image.picture) if image.picture.attached?
