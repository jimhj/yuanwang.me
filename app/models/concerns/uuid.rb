module UUID
  extend ActiveSupport::Concern

  included do
    self.primary_key = "id"
    validates_uniqueness_of :id, on: :create
    before_create { self.generate_primary_key! }
  end

  def generate_primary_key!
    self.id = SecureRandom.hex(4)
  end

  module ClassMethods; end
end
