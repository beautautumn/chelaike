class ChangeAcquisitionCarInfoPriceInt < ActiveRecord::Migration
  def change
    change_column :acquisition_car_infos, :new_car_guide_price_cents, :integer, limit: 8, comment: "新车指导价"
    change_column :acquisition_car_infos, :new_car_final_price_cents, :integer, limit: 8, comment: "新车完税价"
    change_column :acquisition_car_infos, :prepare_estimated_cents, :integer, limit: 8, comment: "整备预算"
    change_column :acquisition_car_infos, :valuation_cents, :integer, limit: 8, comment: "收车人估价"
    change_column :acquisition_car_infos, :closing_cost_cents, :integer, limit: 8, comment: "确认收购价"

    change_column :acquisition_car_comments, :valuation_cents, :integer, limit: 8, comment: "回复人的估价"
    change_column :acquisition_confirmations, :acquisition_price_cents, :integer, limit: 8, comment: "收购成交价"
  end
end
