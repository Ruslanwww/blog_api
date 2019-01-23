class Post < ApplicationRecord
  mount_base64_uploader :image, ImageUploader

  belongs_to :user
  has_many :likes, dependent: :destroy
end
