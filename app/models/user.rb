class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :email, presence:true
  validates :posts_counter, numericality: { greater_than_or_equal_to: 0 }

  def recent_posts(limit: 3)
    posts.order(created_at: :asc).limit(limit)
  end
end
