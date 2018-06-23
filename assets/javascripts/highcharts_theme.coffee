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
    tooltip:
      borderColor:  "#ff00cc"
      borderWidth: 0
      borderRadius: 0
      style:
        color: "#aaa"
        fontFamily: fontFamily
        fontSize: '12px'
    yAxis:
      labels:
        style:
          fontFamily: fontFamily
          color: "#aaa"
      gridLineWidth: 0
      minorGridLineWidth: 0
    xAxis:
      labels:
        style:
          fontFamily: fontFamily
          color: "#aaa"

  highchartsOptions = Highcharts.setOptions(Highcharts.theme);
