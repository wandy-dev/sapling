class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one :account
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def finished_onboarding?
    self.account.present?
  end
end
