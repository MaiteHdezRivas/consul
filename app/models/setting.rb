class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true

  default_scope { order(id: :asc) }
  scope :banner,  -> { where("key ilike ?", "banner.%")}


  def type
    if feature_flag?
      'feature'
    elsif banner?
      'banner'
    else
      'common'
    end
  end

  def feature_flag?
    key.start_with?('feature.')
  end

  def banner?
    key.start_with?('banner.')
  end
  
  def enabled?
    feature_flag? && value.present?
  end

  class << self
    def [](key)
      where(key: key).pluck(:value).first.presence
    end

    def []=(key, value)
      setting = where(key: key).first || new(key: key)
      setting.value = value.presence
      setting.save!
      value
    end
  end
end
