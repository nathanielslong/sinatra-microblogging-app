class User < ActiveRecord::Base
  has_many :posts
  has_many :groups, through: :user_groups
end

class Post < ActiveRecord::Base
  belongs_to :user
end

class Group < ActiveRecord::Base
  has_many :users, through: :user_groups
end

class UserGroups < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
end
