class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  has_many :posts, dependent: :destroy

  def self.search(search)
    where("username LIKE ?", "%#{search}%")
  end
end
