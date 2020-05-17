require "rails_helper"

RSpec.describe V1::AcquisitionCarCommentsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:warner) { companies(:warner) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:aodi) { cars(:aodi) }
  let(:acquisition_aodi) { acquisition_car_infos(:aodi) }

  before do
    login_user(lisi)
  end

  def comment_params
    {
      valuation_wan: 20,
      note_text: "很好",
      note_audios: [
        { url: "audio-1", duration: 20, is_unread: true },
        { url: "audio-2", duration: 15, is_unread: false }
      ],
      cooperate: true,
      is_seller: true
    }
  end

  describe "POST create" do
    before do
      lisi.update(company: warner)
    end

    it "创建一条收车信息的回复" do
      auth_post :create, acquisition_car_info_id: acquisition_aodi,
                         acquisition_car_comment: comment_params
      expect(acquisition_aodi.comments.count).to eq 1
    end
  end
end
