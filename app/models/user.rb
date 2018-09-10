class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :username, :firstname, :lastname, :password, presence: true
  validates :password, length: { in: 6..50 }
  validates :email, :username, :firstname, :lastname, length: { in: 2..50 }
  validates :email, :username, uniqueness: true

  has_many :posts, dependent: :destroy

  def self.search(search)
    where("username LIKE ?", "%#{search}%")
  end
end
