module ObjectDiff
  class Base
    CHANGED_NOTE = "做了修改".freeze

    def diff_ids(ids, target_klass, primary_key = :id, attr_name = :name)
      objects = Hash[target_klass.where(primary_key => ids).pluck(primary_key, attr_name)]

      ids.map { |id| objects[id] }
    end

    def parse(klass, key, value)
      if value.is_a?(Array)
        if value[0].blank?
          "#{klass.human_attribute_name(key)} 调整为 #{value[1]}"
        elsif value[1].blank?
          "#{klass.human_attribute_name(key)}从 #{value[0]} 调整为 无"
        else
          "#{klass.human_attribute_name(key)}从 #{value[0]} 调整为 #{value[1]}"
        end
      elsif value.is_a?(String)
        "#{klass.human_attribute_name(key)} #{value}"
      end
    end

    def empty_value(value)
      value.blank? ? "无" : value
    end

    def text_for(user, diffs, name_only: false)
      return if diffs.blank?

      arr = []

      if name_only
        diffs.dup.extract!(*keys_filter(user)).each do |key, _value|
          arr << @target_klass.human_attribute_name(key)
        end
      else
        diffs.dup.extract!(*keys_filter(user)).each do |key, value|
          arr << parse(@target_klass, key, value)
        end
      end

      arr
    end
  end
end
