# == Schema Information
#
# Table name: customers # 客户
#
#  id           :integer          not null, primary key     # 客户
#  company_id   :integer                                    # 公司ID
#  name         :string                                     # 姓名
#  note         :text                                       # 备注
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  phone        :string                                     # 客户主要联系电话
#  phones       :string           default([]), is an Array  # 客户联系电话
#  gender       :string                                     # 性别
#  id_number    :string                                     # 证件号
#  avatar       :string                                     # 客户头像
#  user_id      :integer                                    # 客户所属员工ID
#  first_letter :string                                     # 客户姓名首字母
#  deleted_at   :datetime
#  source       :string           default("user_operation") # 客户产生来源
#

module CustomerSerializer
  class List < ActiveModel::Serializer
    attributes :id, :company_id, :name, :phones, :note, :avatar, :first_letter,
               :phone, :gender, :id_number, :created_at

    def avatar
      return object[:avatar] if instance_options[:batch_avatars].blank?

      value = instance_options[:batch_avatars][object.id]

      value ? value : object[:avatar]
    end
  end
end
