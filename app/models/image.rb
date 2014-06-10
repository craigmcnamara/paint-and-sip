# == Schema Information
#
# Table name: images
#
#  id              :integer          not null, primary key
#  image_mime_type :string(255)
#  image_name      :string(255)
#  image_size      :integer
#  image_width     :integer
#  image_height    :integer
#  image_uid       :string(255)
#  image_ext       :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string(255)
#

class Image < ActiveRecord::Base
  extend FriendlyId
  friendly_id :image_name, use: :slugged

  dragonfly_accessor :image

  def thumb(*args)
    if image
      image.thumb(*args)
    end
  end

  def thumbnail(*args)
    if image
      image.thumb(*args)
    end
  end

  def image_name
    read_attribute(:image_name)
  end

  def to_s
    image_name
  end
end
