class CreateJoinTableHashtagsMemos < ActiveRecord::Migration
  def change
    create_join_table :Hashtags, :Memos do |t|
      # t.index [:hashtag_id, :memo_id]
      # t.index [:memo_id, :hashtag_id]
    end
  end
end
