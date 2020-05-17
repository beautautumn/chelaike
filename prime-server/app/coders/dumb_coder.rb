module DumbCoder
  module_function

  def load(data)
    if data.present?
      data
    else
      {}
    end.with_indifferent_access
  end

  def dump(data)
    data || {}
  end
end
