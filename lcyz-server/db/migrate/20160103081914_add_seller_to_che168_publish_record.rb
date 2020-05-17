class AddSellerToChe168PublishRecord < ActiveRecord::Migration
  def change
    add_column :che168_publish_records, :seller_id, :string, default: "", comment: "销售员ID"
  end
end
