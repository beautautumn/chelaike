# == Schema Information
#
# Table name: task_statistics # 任务统计
#
#  id                            :integer          not null, primary key # 任务统计
#  user_id                       :integer                                # 用户ID
#  shop_id                       :integer                                # 分店ID
#  company_id                    :integer                                # 公司ID
#  record_date                   :date                                   # 记录日期
#  intention_interviewed         :integer          is an Array           # 今日意向已接待
#  intention_processed           :integer          is an Array           # 今日意向已跟进
#  intention_completed           :integer          is an Array           # 今日意向已经成交
#  intention_failed              :integer          is an Array           # 今日意向已失败
#  intention_invalid             :integer          is an Array           # 今日意向已失效
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  pending_interviewing_finished :integer          is an Array           # 今日待接待已完成
#  pending_processing_finished   :integer          is an Array           # 今日待跟进已完成
#  expired_interviewed_finished  :integer          is an Array           # 过期未接待已完成
#  expired_processed_finished    :integer          is an Array           # 过期未跟进已完成
#

require "rails_helper"

RSpec.describe TaskStatistic, type: :model do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }
  let(:cruise_sell_aodi) { intentions(:cruise_sell_aodi) }
  let(:zhangsan_task_statistic) { task_statistics(:zhangsan_task_statistic) }

  before do
    travel_to Time.zone.parse("2015-10-01")
  end

  describe "increment method" do
    before do
      expect(
        zhangsan_task_statistic.intention_processed.sort
      ).to eq [doraemon_seeking_aodi.id].sort

      TaskStatistic.increment("intention_processed", zhangsan, doraemon_seeking_aodi.id)
      TaskStatistic.increment("intention_processed", zhangsan, cruise_sell_aodi.id)
    end

    it "appends intention_id to array if it is not exists" do
      zhangsan_task_statistic.reload
      expect(
        zhangsan_task_statistic.intention_processed.sort
      ).to eq [cruise_sell_aodi.id, doraemon_seeking_aodi.id].sort
    end
  end
end
