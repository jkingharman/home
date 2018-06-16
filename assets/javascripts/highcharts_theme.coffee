mainColor = '#4477aa'
fontFamily = "Helvetica, Arial, sans-serif"

$ ->
  Highcharts.theme =
    credits:
      enabled: false
    legend:
      enabled: false
    title:
      text: null
    yAxis:
      gridLineWidth: 0
      minorGridLineWidth: 0


  highchartsOptions = Highcharts.setOptions(Highcharts.theme);
