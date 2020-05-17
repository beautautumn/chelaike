module CarPublisher
  class Che168Worker
    module Error
      class Che168Error < StandardError
        def initialize(record)
          return unless record
          record.update!(state: "failed", error_message: error_message)
        end

        def error_message
          raise "You have to rewrite this method"
        end
      end

      class LoginRetryLimit < Che168Error
        def error_message
          "同步失败5次，请联系管理员".freeze
        end
      end

      class UpdateRetryLimit < Che168Error
        def error_message
          "更新失败5次，请联系管理员".freeze
        end
      end

      class InvalidLoginInfo < Che168Error
        def error_message
          "用户名或密码错误".freeze
        end
      end

      class EmptyImages < Che168Error
        def error_message
          "车辆图片不能为空".freeze
        end
      end

      class InvalidPrice < Che168Error
        def error_message
          "车辆售价不符合同步要求".freeze
        end
      end

      class InvalidMileage < Che168Error
        def error_message
          "车辆表显里程不符合同步要求".freeze
        end
      end

      class InvalidLicensedAt < Che168Error
        def error_message
          "车辆上牌日期不符合同步要求".freeze
        end
      end

      class InvalidSeries < Che168Error
        def error_message
          "车辆车系不符合同步要求".freeze
        end
      end

      class InvalidStyle < Che168Error
        def error_message
          "车辆车款不符合同步要求".freeze
        end
      end

      class InvalidProvince < Che168Error
        def error_message
          "省份信息不符合同步要求".freeze
        end
      end

      class InvalidCity < Che168Error
        def error_message
          "城市信息不符合同步要求".freeze
        end
      end

      class InvalidConfiguration < Che168Error
        def error_message
          "车辆车款的配置不符合同步要求".freeze
        end
      end
    end
  end
end
