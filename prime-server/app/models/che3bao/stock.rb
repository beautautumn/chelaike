# == Schema Information
#
# Table name: tf_t_stock
#
#  id                   :integer          not null, primary key
#  vehicle_id           :integer
#  corp_id              :integer
#  group_id             :integer
#  region_code          :integer
#  locate_id            :integer
#  sale_staff           :integer
#  buy_staff            :integer
#  source_code          :integer
#  cur_sale_id          :integer                                # 本车最新???生??销售????????识
#  cur_buy_id           :integer                                # 本车最新产生的收??合??标识
#  buy_kind             :string(1)                              # 0：收购1：寄售2：合作
#  stock_state          :integer          default(0)            # 0——无效1------在库2----出库3-----已订车4---收购推车
#  instock_date         :date
#  onshelf_date         :date
#  reserve_date         :date
#  outstock_date        :date
#  market_desc          :string(2000)
#  show_price           :integer
#  web_price            :integer
#  bottom_price         :integer
#  whole_sale_price     :integer
#  newcar_ref_price     :integer
#  newcar_add_price     :integer
#  newcar_discount      :integer
#  newcar_deal_price    :integer
#  adjust_desc          :string(255)
#  outstock_kind        :string(1)                              # 0：销售出库；1：收购退车；2：无效数据
#  create_time          :datetime
#  update_time          :datetime
#  warranty_level       :string(20)
#  original_region_code :integer
#  warranty_fee         :integer
#  vehicle_state        :string(2)
#  stock_no             :string(32)
#  intact_tag           :string(1)
#  intact_desc          :string(255)
#  pub_upload_state     :string(1)
#  ourter_vehicle_id    :integer
#  modify_tag           :string(1)
#  state_chg_date       :date
#  pre_back_date        :date
#  mstate_desc          :string(128)
#  mortgage_desc        :string(500)
#  import_tag           :string(1)        default("0")
#  manager_price        :integer
#  maintain_state       :string(1)
#  buy_proc_state       :string(1)
#  sale_proc_state      :string(1)
#  sale_file_id         :integer
#  sale_transfer_id     :integer
#  buy_file_id          :integer
#  buy_transfer_id      :integer
#  drive_back_desc      :string(500)
#  back_return_desc     :string(500)
#  fix_price_tag        :string(1)        default("0")
#  label_print_tag      :string(1)        default("0")
#  drive_back_time      :date
#  back_return_time     :date
#  sale_license_ftime   :date
#  acqu_license_ftime   :date
#  import_hash          :string(40)
#  sellable_tag         :string(1)        default("1")
#  instock_oper_time    :datetime
#  reserve_oper_time    :datetime
#  outstock_oper_time   :datetime
#  mortgage_tag         :string(1)
#  ykj_tag              :string(1)        default("0")
#  proc_contacter       :string(64)
#  proc_contact_tel     :string(32)
#

module Che3bao
  class Stock < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    include Appropriatable
    # relationships .............................................................
    belongs_to :corp
    belongs_to :vehicle
    belongs_to :channel, foreign_key: :source_code
    belongs_to :buy_staff_user, foreign_key: :buy_staff, class_name: Staff.name
    belongs_to :warranty, foreign_key: :warranty_level
    belongs_to :shop, foreign_key: :locate_id, class_name: Shop.name
    has_one :acquisition_transfer
    has_one :sale_transfer

    belongs_to :acquisition_transfer_info,
               foreign_key: :buy_transfer_id,
               class_name: AcquisitionTransferInfo

    belongs_to :sale_transfer_info,
               foreign_key: :sale_transfer_id,
               class_name: SaleTransferInfo

    has_many :car_reservations
    has_many :cooperation_company_relationships
    has_many :cooperation_companies,
             through: :cooperation_company_relationships,
             source: :cooperation_company

    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "tf_t_stock"
    # class methods .............................................................
    # public instance methods ...................................................
    def acquisition_type
      {
        0 => "acquisition", # [收购]
        1 => "consignment", # [寄卖]
        2 => "cooperation", # [合作]
        3 => "permute"      # [置换]
      }[buy_kind.to_i]
    end

    def state
      if vehicle_state.present?
        case vehicle_state.to_i
        when 0
          "preparing"
        when 1
          "in_hall"
        when 2
          "shipping"
        when 3
          "loaning"
        when 4
          "transferred"
        when 5
          "loaning"
        when 6
          "sold"
        when 7
          "acquisition_refunded"
        when 8
          "driven_back"
        when 9
          "in_hall"
        end
      end
    end

    def allowed_mortgage
      mortgage_tag.present? ? mortgage_tag.to_i == 1 : nil
    end

    def cooperation_company_attributes
      cooperation_company_relationships.map do |cc|
        price = cc.cooper_price.to_i

        {
          cooperation_company_id: cc.cooperation_company.try(:appropriate_id),
          cooperation_price_wan: price > 0 ? price / 1_000_000.0 : 0
        }
      end
    end
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
