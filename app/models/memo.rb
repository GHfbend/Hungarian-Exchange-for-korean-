class Memo < ActiveRecord::Base
    belongs_to :user, required: false
    has_many :comments, dependent: :destroy
    acts_as_paranoid
    
    has_and_belongs_to_many :hashtags
  
    accepts_nested_attributes_for :hashtags
    
    resourcify
  
    def self.search(search)
        where("content LIKE ? OR title LIKE ?" , "%#{search}%" , "%#{search}%")
    end
    
    has_many :impressions, :as=>:impressionable
    
    def impression_count
        impressions.size
    end
    
    def unique_impression_count
        impressions.group(:ip_address).size.keys.length
    end
end
