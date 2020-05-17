class BaseFilter
  attr_reader :output_params

  def initialize(input_params)
    @input_params = input_params
    @output_params = {}
  end

  def self.pass_variable
    :@output_params
  end

  def self.before(controller)
    filter = new(controller.params)
    filter.execute

    controller.instance_variable_set(
      pass_variable, filter.output_params
    )
  end
end
