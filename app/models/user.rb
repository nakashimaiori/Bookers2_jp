class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books, dependent: :destroy
  attachment :profile_image
  validates :introduction, presence: false, length: { maximum: 50 }
  validates :name, presence: true, length: { minimum: 2, maximum: 20 }

  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
  JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  def fruit_address
    "%s %s"%([self.address_city,self.address_street,self.address_building])
  end

  geocoded_by :fruit_address
  after_validation :geocode, if: :fruit_address_changed?

end
