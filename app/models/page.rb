# == Schema Information
#
# Table name: pages
#
#  id            :integer          not null, primary key
#  body          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  name          :string(255)
#  publish       :boolean          default(FALSE)
#  meta_keywords :string(255)
#  slug          :string(255)
#  position      :integer
#

class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_list

  default_scope ->{ order('position ASC') }

  scope :published, ->{ where(publish: true) }

  def html
    Redcarpet::Markdown.new( Redcarpet::Render::HTML,
                              autolink: true,
                              tables: true
                            ).render(body).html_safe
  end

  def to_param
    slug
  end
end
