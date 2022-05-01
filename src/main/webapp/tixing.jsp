<%--
  Created by IntelliJ IDEA.
  User: 86189
  Date: 2022/4/17
  Time: 14:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <title>Title</title>
      <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
<script type="text/javascript">
$(function () {
    // import * as echarts from 'echarts';

// 基于准备好的dom，初始化echarts实例
    var myChart = echarts.init(document.getElementById('main'));
// 绘制图表
    myChart.setOption({
        title: {
            text: 'Funnel'
        },
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b} : {c}'
        },
        toolbox: {
            feature: {
                dataView: { readOnly: false },
                restore: {},
                saveAsImage: {}
            }
        },
        // legend: {
        //     data: ['Show', 'Click', 'Visit', 'Inquiry', 'Order']
        // },
        series: [
            {
                name: 'Expected',
                type: 'funnel',
                left: '10%',
                width: '80%',
                label: {
                    formatter: '{b}Expected'
                },
                labelLine: {
                    show: false
                },
                itemStyle: {
                    opacity: 0.5
                },
                emphasis: {
                    label: {
                        position: 'inside',
                        formatter: '{b}Expected: {c}'
                    }
                },
                data: [
                    { value: 60, name: 'Visit' },
                    { value: 40, name: 'Inquiry' },
                    { value: 20, name: 'Order' },
                    { value: 80, name: 'Click' },
                    { value: 100, name: 'Show' }
                ]
            }
        ]
    });
})
</script>
</head>
<body>
<!-- 为 ECharts 准备一个定义了宽高的 DOM -->
<div id="main" style="width: 600px;height:400px;"></div>
</body>
</html>
