class User < ActiveRecord::Base
  has_many :posts

  has_many :relationships, foreign_key: :follower_id
  has_many :followed, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: :followed_id, class_name: 'Relationship'
  has_many :followers, through: :reverse_relationships, source: :follower

  def follow!(user)
    followed << user
  end

  validates :email, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/  }
  validates_length_of :password, minimum: 7
end

class Post < ActiveRecord::Base
  belongs_to :user

  validates :body, length: { maximum: 150 }
end

class Relationship < ActiveRecord::Base
  belongs_to :followed, class_name: 'User'
  belongs_to :follower, class_name: 'User'
end
