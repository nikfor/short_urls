class Url < ApplicationRecord
  validates :original_url, presence: true, format: /\A[a-zA-Z0-9\-._~:\/?#\[\]@!$&'()*+,;=]*\z/
  before_validation :set_short_url

  def set_short_url
    self.short_url = SecureRandom.hex(4)
  end

  def increment_counter!
    self.counter += 1
    self.save
  end
end
