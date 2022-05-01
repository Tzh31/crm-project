<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";%>

<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">
        $(function () {
            $("#transferBtn").click(function () {

                var clueId="${clue.id}"
                var isTransfer=$("#isCreateTransaction").prop("checked")
                var money=$("#amountOfMoney").val()
                var name=$("#tradeName").val()
                var expectedDate=$("#expectedClosingDate").val()
                var source=$("#selectActivityId").val()
                var stage=$("#stage option:selected").val()
                // alert(isTransfer)
           var activityId=$("#selectActivityId").val()
                if (name==''){
                    alert("请输入交易名称")
                    return
                }
                if (expectedDate==''){
                    alert("请选择预计成交日期")
                    return;
                }if (stage=='')
                {
                    alert("请选择阶段")
                    return;
                }
$.ajax({
    url:"workbench/clue/transfer.do",
    dataType: "json",
    type:'post',
    data:{
        clueId:clueId,
        isTransfer:isTransfer,
        money:money,name:name,expectedDate:expectedDate,
        source:source,stage:stage,activityId:activityId
    },success:function (data) {
        if (data.code=="1"){
            alert("转换成功")
            window.location.href="workbench/clue/index.do"
        }else {
            alert(data.message)
        }
    }
})
            })
            $(".mydate").datetimepicker({
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                minView: 'month',
                initialDate: new Date(),
                autoclose: true, todayBtn: true, todayHighlight: true, keyboardNavigation: true, clearBtn: true
            });
            $("#searchActivityBtn").click(function () {
                $("#searchActivityModal").modal("show")
                // alert($("#activityNameInput").val())
                <%--alert("${clue.id}")--%>


            })
            $("#activityNameInput").keyup(function () {

                var activityName = $("#activityNameInput").val()
                // alert(activityName)
                $.ajax({
                    url: "workbench/clue/queryActivityForConvertByNameClueId.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        clueId: "${clue.id}",
                        activityName: activityName
                    },
                    success: function (data) {
                        // alert(data)
                        // $("#tBody").empty()
                        var htmlStr=""
                        $.each(data, function () {

                            htmlStr+="		<tr>";
                            htmlStr+= "	<td><input type=\"radio\" name=\"activity\" activityName="+this.name+" value='"+this.id+"'/></td>";
                            htmlStr+= "	<td>" + this.name + "</td>";
                            htmlStr+= "	<td>" + this.startDate + "</td>";
                            htmlStr+= "	<td>" + this.endDate + "</td>";
                            htmlStr+= "	<td>" + this.owner + "</td>";
                            htmlStr+= "</tr>)";
                        })
                        $("#tBody").html(htmlStr)
                    }
                })
            })
            $("#tBody").on("click","input",function () {
                var activityId=$("#tBody input:checked").val()
                var activityName=$("#tBody input:checked").attr("activityName")
// alert(activityName)
                // alert(activityId)
                $("#activity").val(activityName)
                $("#selectActivityId").val(activityId)
                // alert($("#selectActivityId").val())
                $("#tBody").empty()
                $("#activityNameInput").val("")
                $("#searchActivityModal").modal("hide")
            })

            $("#close").click(function () {
                var activityId=$("#tBody input:checked").val()
                var activityName=$("#tBody input:checked").attr("activityName")
// alert(activityName)
                // alert(activityId)
                $("#activity").val(activityName)
$("#selectActivityId").val(activityId)
                // alert($("#selectActivityId").val())
                $("#tBody").empty()
                $("#activityNameInput").val("")
            })

            $("#isCreateTransaction").click(function () {
                if (this.checked) {
                    $("#create-transaction2").show(200);
                } else {
                    $("#create-transaction2").hide(200);
                }
            });
        });
    </script>

</head>
<body>

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" id="close">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="activityNameInput" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="tBody">
<%--                    <tr>--%>
<%--                        <td><input type="radio" name="activity"/></td>--%>
<%--                        <td>发传单</td>--%>
<%--                        <td>2020-10-10</td>--%>
<%--                        <td>2020-10-20</td>--%>
<%--                        <td>zhangsan</td>--%>
<%--                    </tr>--%>
<%--                    <tr>--%>
<%--                        <td><input type="radio" name="activity"/></td>--%>
<%--                        <td>发传单</td>--%>
<%--                        <td>2020-10-10</td>--%>
<%--                        <td>2020-10-20</td>--%>
<%--                        <td>zhangsan</td>--%>
<%--                    </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="title" class="page-header" style="position: relative; left: 20px;">
    <h4>转换线索 <small>${clue.fullname}-${clue.company}</small></h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
    新建客户：${clue.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
    新建联系人：${clue.fullname}${clue.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
    <input type="checkbox" id="isCreateTransaction"/>
    为客户创建交易
</div>
<div id="create-transaction2"
     style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;">

    <form>
        <div class="form-group" style="width: 400px; position: relative; left: 20px;">
            <label for="amountOfMoney">金额</label>
            <input type="text" class="form-control" id="amountOfMoney">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="tradeName">交易名称</label>
            <input type="text" class="form-control" id="tradeName" value="${clue.company}">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="expectedClosingDate">预计成交日期</label>
            <input type="text" class="form-control mydate" id="expectedClosingDate" readonly>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="stage">阶段</label>
            <select id="stage" class="form-control">
                <option></option>
                <c:forEach items="${stage}" var="sta">
                    <option value="${sta.id}">${sta.value}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <input type="hidden" id="selectActivityId">
            <label for="activity">市场活动源&nbsp;&nbsp;
                <a href="javascript:void(0);" id="searchActivityBtn" style="text-decoration: none;"><span
                        class="glyphicon glyphicon-search"></span></a></label>
            <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
        </div>
    </form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
    记录的所有者：<br>
    <b>${clue.owner}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
    <input class="btn btn-primary" type="button" value="转换" id="transferBtn">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input class="btn btn-default" type="button" value="取消">
</div>
</body>
</html>