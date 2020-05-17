# frozen_string_literal: true
class AddMakeToInsuranceRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :insurance_records, :make, :string, comment: "车型信息"
    add_column :insurance_records, :order_id, :string, comment: "查询报告ID"
    add_column :insurance_records, :engine_num, :string, comment: "发动机号"
    add_column :insurance_records, :license_no, :string, comment: "车牌号"
  end
end
