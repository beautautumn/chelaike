require "rails_helper"

RSpec.describe V1::DetectionReportsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  before do
    login_user(zhangsan)
  end

  describe "GET show" do
    it "get report" do
      DetectionReport.create(
        car_id: aodi.id,
        url: "url",
        report_type: :report
      )

      auth_get :show, car_id: aodi.id

      expect(response_json).to be_present
    end
  end

  describe "POST create" do
    it "创建格式为pdf的记录" do
      expect do
        auth_post :create,
                  car_id: aodi.id,
                  detection_report: {
                    report_type: :pdf,
                    url: "pdf-url"
                  }
      end.to change { DetectionReport.count }.by 1
    end

    it "创建格式为图片的记录" do
      expect do
        auth_post :create,
                  car_id: aodi.id,
                  detection_report: {
                    report_type: :image,
                    images_attributes: [
                      { url: "image-1" },
                      { url: "image-2" }
                    ]
                  }
      end.to change { DetectionReport.count }.by 1
    end
  end

  describe "PUT update" do
    it "可以更新" do
      @report = DetectionReport.create(
        car_id: aodi.id,
        url: "url",
        report_type: :report
      )
      auth_put :update,
               car_id: aodi.id,
               id: @report.id,
               detection_report: {
                 url: "new url"
               }

      expect(@report.reload.url).to eq "new url"
    end

    it "可以删除图片" do
      report = DetectionReport.create(
        car_id: aodi.id,
        report_type: :image,
        images_attributes: [
          { url: "image-1" },
          { url: "image-2" }
        ]
      )

      images = report.images

      auth_put :update,
               car_id: aodi.id,
               id: report.id,
               detection_report: {
                 url: "new url",
                 images: [
                   { id: images.first.id, url: "", _destroy: true },
                   { id: images.last.id, url: "image-3" }
                 ]
               }

      expect(report.reload.url).to eq "new url"
    end
  end
end
