# == Schema Information
#
# Table name: tf_t_vehicle_pic
#
#  id             :integer          not null, primary key
#  vehicle_id     :integer
#  pic_name       :string(50)
#  pic_addr       :string(255)                            # 用于网络访问????图???地址
#  upload_staff   :integer
#  upload_date    :datetime
#  display_order  :integer
#  temp_id        :string(40)
#  show_tag       :string(1)
#  pic_kind       :string(2)
#  small_pic_addr :string(255)
#  list_pic_addr  :string(255)
#  pic_src        :string(1)        default("0")
#

module Che3bao
  class VehicleImage < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    # relationships .............................................................
    belongs_to :vehicle

    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "tf_t_vehicle_pic"
    # class methods .............................................................
    def self.to_qiniu
      sql = <<-SQL
        UPDATE tf_t_vehicle_pic
          SET pic_addr = REPLACE(pic_addr, 'kimg.nayouche.com', 'image.che3bao.com');
      SQL

      connection.execute(sql.squish!)
    end
    # public instance methods ...................................................
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
