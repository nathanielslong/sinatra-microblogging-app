class User < ActiveRecord::Base
  has_many :posts
  has_many :groups, through: :user_groups

  validates :email, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/  }
  validates_length_of :password, minimum: 7
end

class Post < ActiveRecord::Base
  belongs_to :user

  validates :body, length: { maximum: 150 }
end

class Group < ActiveRecord::Base
  has_many :users, through: :user_groups
end

class UserGroups < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
end
