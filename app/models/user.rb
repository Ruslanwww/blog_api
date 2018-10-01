# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :posts, dependent: :destroy

  validates :email, :nickname, :name, :lastname, :password, presence: true
  validates :password, length: { in: 8..50 }
  validates :email, :nickname, :name, :lastname, length: { in: 2..50 }
  validates :email, :nickname, uniqueness: true

  def self.search(search)
    where("nickname LIKE ?", "%#{search}%")
  end
end
