$ ->
  myChart = Highcharts.chart('fruit_container',
    chart: type: 'column'
    title: text: 'Fruit Consumption'
    xAxis: categories: [
      'Jan'
      'Feb'
      'March'
      'April'

    ]
    yAxis: title: text: 'Commits'
    series: [
      {
        data: [
          2
          3
          3
          5
        ]
      }
      {
        data: [
          2
          3
          4
          5
        ]
      }
    ])
  return
