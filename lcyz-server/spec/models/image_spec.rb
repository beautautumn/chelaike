# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  imageable_id   :integer                                # 多态ID
#  imageable_type :string                                 # 多态名
#  url            :string                                 # 图片URL
#  name           :string                                 # 名称
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  location       :string                                 # 图片位置
#  is_cover       :boolean          default(FALSE)        # 是否为LOGO
#  sort           :integer          default(0)            # 排序
#  image_style    :string                                 # 图片的类型
#

require "rails_helper"

RSpec.describe Image, type: :model do
  fixtures :all

  let(:aodi) { cars(:aodi) }

  describe "order by location" do
    before do
      %w(左前45度 前排座椅-左前门).each do |location|
        aodi.images.create(url: "abc", name: "abc", location: location)
      end
    end

    it "sortted by specify rule" do
      images = aodi.images.order(Image.location_order_sql.squish!)

      expect(images.first.location).to eq "左前45度"
    end
  end
end
