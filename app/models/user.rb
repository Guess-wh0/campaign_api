class User < ApplicationRecord

  # Callbacks
  before_validation :set_default_campaigns_list

  # Validations
  with_options presence: true do
    validates :name
    validates :email, uniqueness: true
    validates :campaigns_list
  end

  private

  def set_default_campaigns_list
    self.campaigns_list ||= []
  end
end
