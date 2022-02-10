class User < ApplicationRecord
  self.primary_key = 'address'

  def seen
    self.last_seen = DateTime.now
  end
end
