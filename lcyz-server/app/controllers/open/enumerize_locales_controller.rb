module Open
  class EnumerizeLocalesController < Open::ApplicationController
    serialization_scope :anonymous

    def index
      render json: { data: I18n.t("open_enumerize_locales") }, scope: nil
    end
  end
end
