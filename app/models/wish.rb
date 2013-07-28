# coding: utf-8
class Wish < ActiveRecord::Base
  include UUID
  include QnUploader

  validates_presence_of :content

  mount_uploader :photo
  
  has_many :wishers
  has_one :achiever, class_name: "User", foreign_key: "achiever_id"
  belongs_to :user, counter_cache: true

  validates_inclusion_of :status, :in => %w(PENDING LOCKED GRANTED FAILED)

  scope :granteds, -> { where(status: "GRANTED").includes(:user) }
  scope :pendings, -> { where(status: "PENDING").includes(:user) }

  %w(PENDING LOCKED GRANTED FAILED).each do |status|
    define_method :"#{status.downcase}?" do
      self.status == status
    end
  end

  def current_wisher
    self.wishers.current.try(:user)
  end

end
