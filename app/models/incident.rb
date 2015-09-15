class Incident < ActiveRecord::Base
  # The 'incident' model.
  # Incidents are created by Users (foreign key)
  # 'begins' and 'ends' are for scheduled incidents, like scheduled maintenance.
  # Incidents may be public or private.

  validates :name, presence: true, length: {minimum: 5, maximum: 256}
  validates_presence_of :component
  validates_presence_of :public
  validates_presence_of :user_id

end