module Dashboard
  class AppVersionsController < ApplicationController
    before_action do
      authorize :dashboard_app_version
    end
    before_action :set_app
    before_action :set_app_version, only: [:companies, :edit, :update, :destroy]

    def index
      @app_versions = @app.app_versions.ransack(params[:q])
                          .result
                          .page(params[:page])
                          .per(20)
                          .order(id: :desc)
      @counter = @app.app_versions.ransack(params[:q]).result.count
    end

    def companies
      @companies = @app_version.companies
    end

    def create
      app_version = @app.app_versions.new(app_version_params)
      app_version.version_category = @app.alias
      app_version.companies << Company.find(app_version_params[:company_ids].reject(&:empty?))
      app_version.plist_source = generate_plist(
        params[:app_version][:ipa_source],
        "#{app_version.version_category}_#{app_version.version_number}_#{SecureRandom.hex(2)}.plist"
      ).gsub("http", "https")

      app_version.save

      redirect_to app_app_versions_path(@app), status: 303
    end

    def edit
      @app_version
    end

    def update
      @app_version.assign_attributes(app_version_params)
      @app_version.companies << Company.find(app_version_params[:company_ids].reject(&:empty?))

      @app_version.save

      redirect_to app_app_versions_path(@app), status: 303
    end

    def destroy
      @app_version.destroy

      redirect_to app_app_versions_path(@app), status: 303
    end

    private

    def app_version_params
      params.require(:app_version).permit(
        :version_number, :android_source, :ipa_source, :version_category,
        :force_update, :version_type, :note, company_ids: []
      )
    end

    def set_app
      @app = App.find(params[:app_id])
    end

    def set_app_version
      @app_version = @app.app_versions.find(params[:id])
    end

    def generate_plist(ipa_source, filename)
      ipa_file = IpaReader::IpaFile.new(open(ipa_source))
      tmp_file = "#{Rails.root}/tmp/#{filename}"

      @ipa_source = ipa_source
      @ipa_file = ipa_file
      plist = ERB.new File.open("#{Dashboard::Engine.root}/config/plist.xml.erb").read
      plist = plist.result(binding)

      File.open(tmp_file, "w") { |file| file.write(plist) }
      plist_path = send_to_aliyun(tmp_file, filename)
      File.delete tmp_file

      plist_path
    end

    def send_to_aliyun(path, filename)
      connection = CarrierWave::Storage::Aliyun::Connection.new(AliyunOss.opts)

      filename = "#{ENV.fetch("OSS_IPA_FOLDER")}/#{filename}"

      connection.put(filename, open(path), content_type: "application/x-plist")

      GC.start

      asset_host = "http://prime.oss-cn-hangzhou.aliyuncs.com"

      "#{asset_host}/#{filename}"
    end
  end
end
