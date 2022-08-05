class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :content, presence: true,
                      length: {
                        maximum: Settings.micropost.content.length.maximum
                      }
  validates :image, content_type: {in: Settings.micropost.image.content_types},
    size: {less_than: Settings.micropost.image.maximum_file_size}
  delegate :name, to: :user, prefix: true
  scope :newest, ->{order(created_at: :desc)}
  scope :feed, ->(id){where(user_id: id)}

  def display_image
    image.variant(
      resize_to_limit: Settings.micropost.image.size
    )
  end
end
