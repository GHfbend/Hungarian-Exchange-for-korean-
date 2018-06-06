class Memo < ActiveRecord::Base
    belongs_to :user, required: false
    has_many :comments, dependent: :destroy
    has_and_belongs_to_many :hashtags
  
    accepts_nested_attributes_for :hashtags
  
    def self.search(search)
        where("content LIKE ? OR title LIKE ?" , "%#{search}%" , "%#{search}%")
    end
end
