class ChangeIsAllianceContactToFalseToUsers < ActiveRecord::Migration
  def migrate(dir)
    super

    User.where("is_alliance_contact IS NULL").update_all(is_alliance_contact: false)

    Company.find_each do |company|
      company.owner.update_columns(is_alliance_contact: true) if company.owner
    end
  end

  def change
    change_column :users, :is_alliance_contact, :boolean, default: false, comment: "是否联盟联系人"
  end
end
