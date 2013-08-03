# coding: utf-8
class Wish < ActiveRecord::Base
  include UUID
  include QnUploader
  include Rails.application.routes.url_helpers

  validates_presence_of :content

  mount_uploader :photo
  
  has_many :wishers
  has_one :achiever, class_name: "User", foreign_key: "achiever_id"
  belongs_to :user, counter_cache: true

  validates_inclusion_of :status, :in => %w(PENDING LOCKED GRANTED FAILED)

  scope :granted, -> { where(status: "GRANTED").includes(:user) }
  scope :pending, -> { where(status: "PENDING").includes(:user) }
  scope :locked, -> { where(status: "LOCKED").includes(:user) }
  scope :failed, -> { where(status: "FAILED").includes(:user) }

  %w(PENDING LOCKED GRANTED FAILED).each do |status|
    define_method :"#{status.downcase}?" do
      self.status == status
    end
  end

  def current_wisher
    self.wishers.where(current: true).first.try(:user)
  end

  after_create do
    self.delay(queue: "sync_2_weibo", priority: 20)
        .sync_2_weibo
  end

  after_update do
    return unless self.changed.include?('status')
    case self.status
    when "LOCKED"
      self.delay(queue: "send_grant_notification", priority: 20)
          .send_grant_notification
    when "GRANTED"
      self.delay(queue: "send_confirm_granted_notification", priority: 20)
          .send_confirm_granted_notification
    end
  end

  def sync_2_weibo
    status = %Q(刚刚许了个心愿：『#{self.content.truncate(100)}』,谁能帮我？#{wish_url(self.id)})
    opts = {
      :access_token => self.user.weibo_token,
      :status => URI.encode(status)
    }

    if self.photo.blank?
      Rails.logger.info 1111111111
      conn = Faraday.new "https://api.weibo.com"
      conn.post '/2/statuses/update.json', opts

      Rails.logger.info conn
    else
      pic_path = convert_to_tempfile(self.photo_url).path
      opts.merge!(:pic => Faraday::UploadIO.new(pic_path, 'image/jpeg'))
      conn = Faraday.new(:url => "https://upload.api.weibo.com") do |faraday|
        faraday.request :multipart
        faraday.adapter :net_http
      end
      conn.post "/2/statuses/upload.json", opts
    end     
  end

  def send_grant_notification
    return if user_id == current_wisher.id
    notify = Notification::Grant.new
    notify.user_id = current_wisher.id
    notify.to_user_id = self.user_id
    notify.model_id = self.id
    notify.save
  end

  def send_confirm_granted_notification
    return if user_id == current_wisher.id
    notify = Notification::ConfirmGrant.new
    notify.user_id = self.user_id
    notify.to_user_id = current_wisher.id
    notify.model_id = self.id
    notify.save
  end  

end
