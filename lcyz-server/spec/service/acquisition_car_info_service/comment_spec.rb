require "rails_helper"

RSpec.describe AcquisitionCarInfoService::Comment do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:warner) { companies(:warner) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:zhaoliu) { users(:zhaoliu) }
  let(:aodi) { cars(:aodi) }
  let(:acquisition_aodi) { acquisition_car_infos(:aodi) }

  def comment_params
    {
      valuation_wan: 20,
      note_text: "很好",
      note_audios: ["audio-url1", "audio-url2"],
      cooperate: true,
      is_seller: true
    }
  end

  describe "#create(params)" do
    context "回复者是其他公司的员工" do
      before do
        lisi.update(company: warner)
        @service = AcquisitionCarInfoService::Comment.new(lisi, acquisition_aodi)
      end

      it "创建一条收车信息的回复" do
        @service.create(comment_params)
        expect(acquisition_aodi.comments.count).to eq 1
      end

      it "如果状态为'已结束'，不能创建回复，抛出异常" do
        acquisition_aodi.update(state: "finished")
        expect do
          @service.create(comment_params)
        end.to raise_error(AcquisitionCarInfoService::Comment::StateError)
      end

      it "同一个公司只允许一个人选择合作收车及成为销售方" do
        zhaoliu.update(company: warner)
        @service.create(comment_params)
        service = AcquisitionCarInfoService::Comment.new(zhaoliu, acquisition_aodi)
        comment = service.create(comment_params).comment

        expect(comment.cooperate).to be_falsy
        expect(comment.is_seller).to be_falsy
      end
    end

    context "回复者是发布者同一公司员工" do
      before do
        lisi.update(company: zhangsan.company)
      end

      it "不保存'合作收车'信息" do
        service = AcquisitionCarInfoService::Comment.new(lisi, acquisition_aodi)
        comment = service.create(comment_params).comment
        expect(comment.cooperate).to be_falsey
        expect(comment).to be_persisted
      end
    end
  end
end
