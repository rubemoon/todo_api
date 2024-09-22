class User < ApplicationRecord
  has_many :todos, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end
