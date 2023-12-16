class User < ApplicationRecord
  attr_accessor :token
  after_create :welcome_send
  after_create :create_jwt_and_cart
  has_one_attached :avatar
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  
  def create_jwt_and_cart
    create_jwt
    create_cart
  end
  
  
  def create_jwt
    payload = { id: self.id }
    token = JWT.encode(payload, Rails.application.credentials.secret_key_base)
    self.token = token
    self.save
  end
  
  def create_cart
    Cart.create(user: self) #Permt de créer un panier aprés au même moment que l'inscription
  end
  
  # def welcome_send
  #   UserMailer.welcome_email(self).deliver_now
  # end
  
  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end

end

