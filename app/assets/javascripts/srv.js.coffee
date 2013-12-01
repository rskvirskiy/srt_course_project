$ ->
  data_for_real = $('#container_for_real_graph').data('for_real_graph')
  $("#container_for_real_graph").highcharts
    chart:
      zoomType: 'x'

    title:
      text: "Real time graph"

    plotOptions:
      series:
        turboThreshold: 22000

      line:
        marker:
          enabled: false

        shadow: false

        lineWidth: 1

        animation: false

        threshold: null

    series: [
      data: data_for_real
    ]

  values_for_model = $('#container_for_model_graph').data('for_model_graph')
  $("#container_for_model_graph").highcharts
    chart:
      zoomType: 'x'

    title:
      text: "Model time graph"

    plotOptions:
      series:
        turboThreshold: 24000

      line:
        marker:
          enabled: false

        shadow: false

        lineWidth: 1

        animation: false

        threshold: null

    series: [
      data: values_for_model
    ]
