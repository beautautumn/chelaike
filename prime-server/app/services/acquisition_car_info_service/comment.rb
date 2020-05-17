module AcquisitionCarInfoService
  class Comment
    include ErrorCollector

    class StateError < StandardError; end

    attr_accessor :comment, :info

    def initialize(user, acquisition_car_info)
      @user = user
      @info = acquisition_car_info
    end

    def create(comment_params)
      raise StateError, "本信息已完成收购" if @info.state == "finished"

      comment_params = sanitized_params(comment_params)

      @comment = @info.comments.build(comment_params.merge(commenter: @user))
      fallible @info, @comment

      begin
        @info.transaction do
          @comment.save!
        end
      rescue ActiveRecord::RecordInvalid
        @comment
      end

      self
    end

    private

    def sanitized_params(comment_params)
      return comment_params.slice!(:cooperate, :is_seller) if self_acquisition?

      return comment_params unless company_cooperate?
      comment_params.tap do |p|
        p[:cooperate] = false
        p[:is_seller] = false
      end
    end

    def company_cooperate?
      AcquisitionCarComment.exists?(
        company_id: @user.company_id,
        cooperate: true
      )
    end

    def self_acquisition?
      @info.company == @user.company
    end
  end
end
