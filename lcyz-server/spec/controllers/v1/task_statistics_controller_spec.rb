require "rails_helper"

RSpec.describe V1::TaskStatisticsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }
  let(:gian_seeking_aodi) { intentions(:gian_seeking_aodi) }

  before do
    login_user(zhangsan)

    TaskStatistic.increment(:intention_interviewed, zhangsan, doraemon_seeking_aodi.id)
    TaskStatistic.increment(:intention_interviewed, lisi, gian_seeking_aodi.id)
  end

  # 废弃的
  describe "GET /api/v1/task_statistics" do
    it "lists statistics" do
      auth_get :index, user_ids: [zhangsan.id, lisi.id].join(",")

      expect(response_json[:data][:intention_interviewed_count_today]).to eq 2
    end
  end

  describe "GET /api/v1/task_statistic" do
    it "lists task statistics" do
      auth_get :index, user_ids: [zhangsan.id, lisi.id].join(",")

      expect(response_json[:data][:intention_interviewed_count_today]).to eq 2
    end
  end
end
