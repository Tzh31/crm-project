<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <base href="<%=basePath%>">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $.ajax({
                url:"workbench/chart/selectCountOfTranGroupByStage.do",
                dataType:"json",type:"post"
                ,
                success:function (data) {

                    // import * as echarts from 'echarts';

// 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));
// 绘制图表
                    myChart.setOption({
                        title: {
                            text: '交易图标',subtext: "交易表中各个阶段的数量"
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
                                name: '数据量',
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
                                data: data
                            }
                        ]
                    });
                }
            })
        })


    </script>
    <title>Title</title>
</head>
<body>
<div id="main" style="width: 600px;height:400px;"></div>

</body>
</html>
