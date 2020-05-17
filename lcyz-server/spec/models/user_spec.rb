# == Schema Information
#
# Table name: users # 用户
#
#  id                         :integer          not null, primary key    # 用户
#  name                       :string           not null                 # 姓名
#  username                   :string                                    # 用户名
#  password_digest            :string           not null                 # 加密密码
#  email                      :string                                    # 邮箱
#  pass_reset_token           :string                                    # 重置密码token
#  phone                      :string                                    # 手机号码
#  state                      :string           default("enabled")       # 状态
#  is_alliance_contact        :boolean          default(FALSE)           # 是否联盟联系人
#  pass_reset_expired_at      :datetime                                  # 重置密码token过期时间
#  last_sign_in_at            :datetime                                  # 最后登录时间
#  current_sign_in_at         :datetime                                  # 当前登录时间
#  company_id                 :integer                                   # 所属公司
#  shop_id                    :integer                                   # 所属分店
#  manager_id                 :integer                                   # 所属经理
#  note                       :text                                      # 员工描述
#  authority_type             :string           default("role")          # 权限选择类型
#  authorities                :text             default([]), is an Array # 权限
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  deleted_at                 :datetime                                  # 删除时间
#  avatar                     :string                                    # 头像URL
#  settings                   :jsonb                                     # 设置
#  mac_address                :string                                    # MAC地址
#  cross_shop_authorities     :text             default([]), is an Array # 跨店权限
#  device_numbers             :text             default([]), is an Array # App设备号
#  client_info                :jsonb                                     # 客户端信息
#  first_letter               :string                                    # 拼音
#  mobile_app_car_detail_menu :string           is an Array              # 移动APP车辆详情页菜单
#  rc_token                   :string                                    # 融云token
#  current_device_number      :string                                    # 用户当前使用的手机设备号
#  qrcode_url                 :string                                    # 二维码地址
#  self_description           :text                                      # 自我介绍
#

require "rails_helper"

RSpec.describe User do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }
  let(:gian_seeking_aodi) { intentions(:gian_seeking_aodi) }

  describe ".can?(*actions)" do
    it "reutrns boolean to judge user's authorities" do
      expect(zhangsan.can?("在库车辆查询")).to be_truthy
      expect(zhangsan.can?("员工权限管理")).to be_falsy

      expect(zhangsan.can?("在库车辆查询", "车辆状态修改")).to be_truthy
      expect(zhangsan.can?("在库车辆查询", "员工权限管理")).to be_falsy
    end
  end

  describe ".authorities" do
    it "display all authorities" do
      authorities = %w(
        在库车辆查询 车辆信息编辑 出库车辆编辑 车辆新增入库 在库车辆预定
        车辆销售定价 车辆状态修改 在库车辆出库 销售底价查看 经理底价查看 车主寄卖信息查看
        收购信息查看 收购价格查看 合作信息查看 库存转帮售 车辆操作历史查看 车辆库龄查看 网站车辆导入
        库存明细导出 在库车辆删除 车辆图片上传 已出库车辆查询 出库车辆回库 按揭信息查看 保险信息查看
        销售成交信息查看 销售明细导出 联盟车辆查询 联盟底价查看 联盟管理 整备信息录入 整备信息查看
        整备费用查看 牌证信息查看 牌证信息录入 证件资料导出 删除客户 代办客户预定/出库 全部客户管理
        求购客户跟进 求购客户管理 全部求购客户管理 出售客户管理 出售客户跟进 全部出售客户管理 坐席录入
        车币充值 维保报告查询 打印回单 公司信息设置 员工管理 角色管理 业务设置 库存统计查看 微店管理权限
        维保详情查看 维保统计查看 牌证图片查看 财务管理
      )

      expect(User.authorities.sort).to eq authorities.sort
    end
  end

  describe "authorities_include scope" do
    it "filter users by authorities" do
      expect(User.authorities_include("在库车辆查询")).to include(zhangsan)

      expect(
        User.authorities_include("员工权限管理")
      ).not_to include(zhangsan)

      expect(
        User.authorities_include(*%w(在库车辆查询 车辆状态修改))
      ).to include(zhangsan)

      expect(
        User.authorities_include(*%w(在库车辆查询 员工权限管理))
      ).not_to include(zhangsan)
    end
  end

  describe "authorities_any scope" do
    before do
      give_authority(zhangsan, "求购客户管理")
      give_authority(lisi, "出售客户管理")
    end

    it "filter users by authorities" do
      expect(
        User.ransack(authorities_any: %w(求购客户管理 出售客户管理)).result.pluck(:id).sort
      ).to eq [zhangsan.id, lisi.id].sort
    end
  end

  describe "#shared_intentions" do
    before do
      doraemon_seeking_aodi.update(assignee_id: zhangsan.id)
    end

    it "得到共享给自己的意向" do
      IntentionSharedUser.create(
        user: lisi,
        intention: doraemon_seeking_aodi,
        customer_id: doraemon_seeking_aodi.customer_id
      )

      expect(lisi.shared_intentions).to include doraemon_seeking_aodi
    end
  end

  describe "#all_intentions" do
    it "得到所有自己可见的意向，包括归属及共享" do
      doraemon_seeking_aodi
      gian_seeking_aodi.update(assignee_id: lisi.id)

      IntentionSharedUser.create(
        user: zhangsan,
        intention: gian_seeking_aodi,
        customer_id: gian_seeking_aodi.customer_id
      )

      expect(zhangsan.all_intentions.map(&:id)).to include gian_seeking_aodi.id
    end

    it "这个user没有被分配过意向，但有被共享的意向" do
      Intention.update_all(assignee_id: zhangsan.id)
      shared_intention = Intention.last

      IntentionSharedUser.create(
        user: lisi,
        intention: shared_intention
      )

      expect(lisi.all_intentions).to include shared_intention
    end
  end

  # describe ".mac_address_valid?" do
  #   it "check the mac address" do
  #     zhangsan.update(mac_address_lock: true, mac_address: "aaa")

  #     expect(zhangsan.mac_address_valid?("aaa")).to be_truthy
  #     expect(zhangsan.mac_address_valid?("aaa, bbb")).to be_truthy
  #     expect(zhangsan.mac_address_valid?("ddd")).to be_falsy
  #   end
  # end
end
