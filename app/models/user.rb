# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  mount_uploader :avatar, ImageUploader

  has_many :posts, dependent: :destroy
  has_many :likes
  has_many :subscriptions

  # validates :email, :nickname, :name, :lastname, :password, presence: true
  # validates :password, length: { in: 8..50 }
  # validates :email, :nickname, :name, :lastname, length: { in: 2..50 }

  def self.search(search)
    where("LOWER(nickname) LIKE LOWER(?)", "%#{search}%")
  end
end
