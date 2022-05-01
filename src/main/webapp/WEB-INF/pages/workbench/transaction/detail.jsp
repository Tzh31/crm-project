<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>

    <style type="text/css">
        .mystage {
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }

        .closingDate {
            font-size: 15px;
            cursor: pointer;
            vertical-align: middle;
        }
    </style>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $("#stageBody").on("click", "span", function () {


                var orderNo = $(this).attr("id")
                orderNo = orderNo.substr(5, 1)
                var d = $("#span_7").attr("current")
                // alert(d)
// alert(current+" "+orderNo)
                if (orderNo == d) {
                    alert("已在本阶段")
                    return;
                }
                if (d == '7') {
                    alert("已经成交,不能再转换")
                    return
                }


                var tranId = "${tran.id}"
                $.ajax({
                    url: "workbench/transaction/editStage.do",
                    dataType: "json",
                    type: "post",
                    data: {
                        orderNo: orderNo,
                        tranId: tranId
                    }, success: function (data) {

                        if (data.code == '1') {
                            // alert(data.retData)
// $("#stageBody").empty()

                            $("#edit_time").html(data.retData.editTime)
                            $("#edit_by").html(data.retData.editBy + "&nbsp;&nbsp")
$("#edit_stage").html(data.retData.stage)
                            $("#edit_possibly").html(data.retData.possibility)
                            var str = ""
                            str += "阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                            <%--var stage=JSON.parse("${stage}")--%>

                            var recentOrderNo = data.retData.orderNo

                            $.each(data.retData1, function (index, sta) {
// alert(sta.value)
                                if (recentOrderNo > sta.orderNo) {
                                    str += "<span id='span_" + sta.orderNo + "' class=\"glyphicon glyphicon-ok-circle mystage\" data-toggle=\"popover\" data-placement=\"bottom\" data-content='" + sta.value + "' style=\"color: #90F790;\"></span>"
                                    str += " ----------- "
                                } else if (recentOrderNo < sta.orderNo) {
                                    str += "<span  id='span_" + sta.orderNo + "'  class=\"glyphicon glyphicon-record mystage\" data-toggle=\"popover\" data-placement=\"bottom\" data-content='" + sta.value + "'></span>"
                                    str += " ----------- "
                                } else {
                                    str += "<span  id='span_" + sta.orderNo + "'current=" + sta.orderNo + " class=\"glyphicon glyphicon-map-marker mystage\" data-toggle=\"popover\" data-placement=\"bottom\" data-content='" + sta.value + "' style=\"color: #68c968;\"></span>"
                                    str += " ----------- "

                                }


                            })
// alert(str)

                            $("#stageBody").html(str)

                            str=""
                            $.each(data.retData2,function (index,history) {
                      str+=" <tr>"
                      str+="  <td>"+history.stage+"</td>";
                      str+="  <td>"+history.money+"</td>";
                      str+="  <td>"+history.expectedDate+"</td>";
                      str+="  <td>"+history.createTime+"</td>";
                      str+="  <td>"+history.createBy+"</td>";
                      str+="  </tr>";
                            })
                            $("#historyBody").html(str)
                        } else {
                            alert(data.message)
                        }
                    }
                })


            })
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });


            //阶段提示框
            $(".mystage").popover({
                trigger: 'manual',
                placement: 'bottom',
                html: 'true',
                animation: false
            }).on("mouseenter", function () {
                var _this = this;
                $(this).popover("show");
                $(this).siblings(".popover").on("mouseleave", function () {
                    $(_this).popover('hide');
                });
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide")
                    }
                }, 100);
            });
        });


    </script>

</head>
<body>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${tran.customerId}-${tran.name} <small>${tran.money}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 阶段状态 -->
<div style="position: relative; left: 40px; top: -50px;" id="stageBody">
    阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <c:forEach items="${stage}" var="sta">
        <c:if test="${sta.orderNo<tran.orderNo}">
            <span id="span_${sta.orderNo}" class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover"
                  data-placement="bottom" data-content="${sta.value}" style="color: #90F790;"></span>
            -----------
        </c:if>
        <c:if test="${sta.orderNo==tran.orderNo}">
            <span id="span_${sta.orderNo}" current="${sta.orderNo}" class="glyphicon glyphicon-map-marker mystage"
                  data-toggle="popover" data-placement="bottom" data-content="${sta.value}"
                  style="color: #68c968;"></span>
            -----------

        </c:if>
        <c:if test="${sta.orderNo>tran.orderNo}">
            <span id="span_${sta.orderNo}" class="glyphicon glyphicon-record mystage" data-toggle="popover"
                  data-placement="bottom" data-content="${sta.value}"></span>
            -----------

        </c:if>
    </c:forEach>
    <%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>--%>
    <%--		-------------%>
    <%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>--%>
    <%--		-------------%>
    <%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>--%>
    <%--		-------------%>
    <%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>--%>
    <%--		-------------%>
    <%--		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>--%>
    <%--		-------------%>
    <%--		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>--%>
    <%--		-------------%>
    <%--		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>--%>
    <%--		-------------%>
    <%--		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>--%>
    <%--		-------------%>
    <%--		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>--%>
    <%--		-------------%>
    <span class="closingDate">${tran.expectedDate}</span>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: 0px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.money}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.name}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="edit_stage">${tran.stage}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">类型</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="edit_possibly">${tran.possibility}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tarn.source}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.activityId}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">联系人名称</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsId}</b></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="edit_by">${tran.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;" id="edit_time">${tran.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${tran.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${tran.contactSummary}&nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.nextContactTime}&nbsp;</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 100px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->
    <c:forEach items="${remarks}" var="remark">
        <div class="remarkDiv" style="height: 60px;">
            <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>${remark.noteContent}</h5>
                <font color="gray">交易</font> <font color="gray">-</font> <b>${tran.activityId}</b> <small
                    style="color: gray;"> ${remark.editFlag=='1'?remark.editTime:remark.createTime}由
                    ${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag=='1'?"修改":"创建"}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>


    <!-- 备注2 -->
    <%--		<div class="remarkDiv" style="height: 60px;">--%>
    <%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
    <%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
    <%--				<h5>呵呵！</h5>--%>
    <%--				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
    <%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
    <%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--				</div>--%>
    <%--			</div>--%>
    <%--		</div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 阶段历史 -->
<div>
    <div style="position: relative; top: 100px; left: 40px;">
        <div class="page-header">
            <h4>阶段历史</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>阶段</td>
                    <td>金额</td>
                    <td>预计成交日期</td>
                    <td>创建时间</td>
                    <td>创建人</td>
                </tr>
                </thead>
                <tbody id="historyBody">
                <c:forEach items="${tranHistories}" var="history">
                    <tr>
                        <td>${history.stage}</td>
                        <td>${history.money}</td>
                        <td>${history.expectedDate}</td>
                        <td>${history.createTime}</td>
                        <td>${history.createBy}</td>
                    </tr>
                </c:forEach>

                <%--						<tr>--%>
                <%--							<td>需求分析</td>--%>
                <%--							<td>5,000</td>--%>
                <%--							<td>20</td>--%>
                <%--							<td>2017-02-07</td>--%>
                <%--							<td>2016-10-20 10:10:10</td>--%>
                <%--							<td>zhangsan</td>--%>
                <%--						</tr>--%>
                <%--						<tr>--%>
                <%--							<td>谈判/复审</td>--%>
                <%--							<td>5,000</td>--%>
                <%--							<td>90</td>--%>
                <%--							<td>2017-02-07</td>--%>
                <%--							<td>2017-02-09 10:10:10</td>--%>
                <%--							<td>zhangsan</td>--%>
                <%--						</tr>--%>
                </tbody>
            </table>
        </div>

    </div>
</div>

<div style="height: 200px;"></div>

</body>
</html>