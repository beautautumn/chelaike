module Dashboard
  class IntentionsController < ApplicationController
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::TextHelper

    helper_method :build_car, :readable_time, :wrap

    before_action do
      authorize :dashboard_intention
    end

    def index
      @q = Intention.all
      if params[:from_price]
        @q = @q.where("minimum_price_cents >= ? ", params[:from_price].to_f*1000000)
      end
      if params[:to_price]
        @q = @q.where("maximum_price_cents <= ? ", params[:to_price].to_f*1000000)
      end

      @q = @q.ransack(params[:q])

      @intentions = @q.result
                      .includes(:company,
                                { latest_intention_push_history: :executor },
                                :intention_level)
                      .where(intention_type: :seek)
                      .order(created_at: :desc)
                      .state_unfinished_scope
                      .page(params[:page])
                      .per(20)
      @counter = @q.result
                      .where(intention_type: :seek)
                      .state_unfinished_scope
                      .count
    end

    protected

    def build_car(intention)
      return "" unless intention.seeking_cars &&
                       (intention.seeking_cars.size > 0)

      result = ""
      i = 0
      intention.seeking_cars.each do |car|
        i += 1
        result += car[:brand_name].to_s + " " + car[:series_name].to_s
        result += "，" if i < intention.seeking_cars.size
      end
      result
    end

    def readable_time(intention)
      time = intention.try(:latest_intention_push_history).try(:processing_time)
      return "" unless time
      "#{time_ago_in_words(time)} 前"
    end

    def wrap(text)
      return "" unless text
      word_wrap(text, line_width: 8)
    end
  end
end
