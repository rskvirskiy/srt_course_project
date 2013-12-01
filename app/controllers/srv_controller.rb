class SrvController < ApplicationController
  include GSL

  def graph
    @parameters    = ParametersSRV.new({period: 6.283185, begin: 0.0, dfmin: 0.01})
    @data_for_real_graph = @parameters.get_data_for_real_graph.to_json
    @data_for_model_graph = @parameters.get_data_for_model_graph.to_json
  end
end
