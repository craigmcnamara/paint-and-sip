# == Schema Information
#
# Table name: living_social_codes
#
#  id                 :integer          not null, primary key
#  code               :string(255)
#  type               :string(255)
#  bucket             :string(255)
#  voucher_id         :string(255)
#  registration_id    :integer
#  sales_associate_id :integer
#

class LivingSocialCode < ActiveRecord::Base
  self.inheritance_column = :code_type
  attr_accessible :code, :type, :bucket, :voucher_id
  scope :associated, where("sales_associate_id IS NOT NULL")
  scope :unassociated, where(sales_associate_id: nil)
  scope :claimed, where("registration_id IS NOT NULL")
  scope :unclaimed, where(:registration_id => nil)
  scope :with_code, lambda { |code| where("LOWER(code) = ?", (code || "").downcase) }

  belongs_to :sales_associate
  belongs_to :registration

  validates :code, presence: true, uniqueness: true
  validates :type, presence: true
  validates :bucket, presence: true


  def self.create_batch!(options = {})
    associate = SalesAssociate.find(options[:sales_associate_id])
    transaction do
      options[:count].to_i.times do |n|
        associate.living_social_codes.create!(code: generate_code(associate, n), bucket: options[:bucket], type: 'text')
      end
    end
  end

  def self.generate_code(associate, n)
    "#{associate.code}#{Digest::SHA1.hexdigest("#{n}-#{rand}")[0..4]}"
  end

  def count
    case bucket
    when 'one' then 1
    when 'two' then 2
    else 0
    end
  end

  def to_s
    code
  end
end
