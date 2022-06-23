# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  short_url  :string           not null
#  long_url   :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "securerandom"
class ShortenedUrl < ApplicationRecord
  validates :user_id, presence: true 
  validates :short_url, uniqueness: { scope: :long_url }

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  alias :user :submitter

  # belongs_to :user,
  #   primary_key: :id,
  #   foreign_key: :user_id,
  #   class_name: :User

  def self.create!(options)
    long = options["long_url"]
    short = ShortenedUrl.random_code
    until !ShortenedUrl.exists?(short)
      short = ShortenedUrl.random_code
    end
    ele = self.new(short_url: short, long_url: long, user_id: options["user_id"])
    ele.save
  end

  def self.random_code
    SecureRandom.urlsafe_base64
  end
end
