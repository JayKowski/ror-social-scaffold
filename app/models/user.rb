class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  mount_uploader :image, ImageUploader

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships, class_name: 'Friendship', foreign_key: 'user_id', dependent: :destroy
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy

  def friends
    my_friends = friendships.map(&:friend_id) & inverse_friendships.map(&:user_id)
    friend_ids = User.where(id: my_friends)
    friend_ids
  end

  def pending_friends
    friendships.map(&:friend) - inverse_friendships.map(&:user)
  end

  def friend_requests
    requests = inverse_friendships.map(&:user_id) - friendships.map(&:friend_id)
    request_ids = User.where(id: requests)
    request_ids
  end

  def remove_inverse_friend(friend)
    friendships.delete friend
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find { |f| f.user == user }
    friendship.confirmed = true
    friendship.save
  end

  def friend?(user)
    friends.include?(user)
  end

  def user_timeline
    Post.where(user: ([self] + friends))
  end
end
