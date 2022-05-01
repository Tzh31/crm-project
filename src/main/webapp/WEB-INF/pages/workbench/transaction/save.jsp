<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">

        $(function () {
            $("#cancelBtn").click(function () {
                window.location.href = "workbench/transaction/index.do"
            })
            $("#activitySearch").keyup(function () {
                var fullname = $("#activitySearch").val()
                // $("#ContactstBody").html("")
                $.ajax({
                    url: "workbench/transaction/querryContactsByName.do",

                    dataType: "json",
                    type: "post",data:{
                        fullname:fullname
                    },
                    success: function (data) {
                        // alert(data)
                        // alert(data)
                        var str=""
                        var htmlStr=""
                        $.each(data.retData, function (index,obj) {

                            htmlStr+="		<tr>";
                            htmlStr+= "	<td><input type=\"radio\" name=\"activity\" id='"+this.id+"' value='"+this.fullname+"'/></td>";
                            htmlStr+= "	<td>" + this.fullname + "</td>";
                            htmlStr+= "	<td>" + this.email + "</td>";
                            htmlStr+= "	<td>" + this.mphone +"</td>";
                            htmlStr+= "</tr>)";
                        })
                        // alert(htmlStr)
                        $("#ContactstBody").html(htmlStr)

                    }
                })


            })
            $("#ContactstBody").on("click","input",function () {
                var contactCheckName=$("#ContactstBody input:checked").val()
                // alert()
                var contactId=$("#ContactstBody input:checked").prop("id")
$("#contactId").val(contactId)
                $("#create-contactsName").val(contactCheckName)
                // create-contactsId
$("#findContacts").modal("hide")

            })
            $("#activityNameInput").keyup(function () {

                var activityName = $("#activityNameInput").val()
                // alert(activityName)
                $.ajax({
                    url: "workbench/transaction/querryActivityByName.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        <%--clueId: "${clue.id}",--%>
                        name: activityName
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
                $("#create-activityName").val(activityName)
                $("#create-activityId").val(activityId)
                // alert($("#selectActivityId").val())
                $("#tBody").empty()
                $("#activityNameInput").val("")
                $("#findMarketActivity").modal("hide")
            })
            $("#saveNewTranBtn").click(function () {

                var owner = $.trim($("#create-owner").val())
                var money = $.trim($("#create-money").val())
                var name = $.trim($("#create-name").val())
                var expectedDate = $.trim($("#create-expectedDate").val())
                var customerName = $.trim($("#create-customerName").val())
                var stage = $.trim($("#create-stage").val())
                var type = $.trim($("#create-type").val())
                var source = $.trim($("#create-source         ").val())
                var activityId = $.trim($("#create-activityId     ").val())
                var contactsId = $.trim($("#contactId    ").val())
                var description = $.trim($("#create-description    ").val())
                var contactSummary = $.trim($("#create-contactSummary ").val())
                var nextContactTime = $.trim($("#create-nextContactTime").val())
                if (name == '') {
                    alert("请输入名称")
                    return
                }
                if (stage == '') {
                    alert("请选择交易阶段")
                    return;
                }
                if (customerName == '') {
                    alert('请输入客户名称')
                    return;
                }
                if (expectedDate == '') {
                    alert("请选择成交日期")
                    return;
                }
                $.ajax({
                    url: "workbench/transaction/saveNewTran.do"
                    , data: {
                        owner: owner,
                        money: money,
                        name: name,
                        expectedDate: expectedDate,
                        customerName: customerName,
                        stage: stage,
                        type: type,
                        source: source,
                        activityId: activityId,
                        contactsId: contactsId,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,


                    },
                    dataType: "json",
                    type: "post",
                    success: function (data) {
                        if (data.code == '1') {
                            window.location.href = "workbench/transaction/index.do"
                        } else {
                            alert(data.message)
                        }
                    }
                })
            })
            $("#create-stage").change(function () {
                var stageValue = $("#create-stage option:selected").text()
                $.ajax({
                    url: "workbench/transaction/getPossibly.do",
                    dataType: "json",
                    type: "post",
                    data: {
                        stageValue: stageValue
                    },
                    success: function (data) {
                        $("#create-possibility").val(data)
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

            $("#create-customerName").typeahead({
                source: function (jquery, process) {
                    $.ajax({
                        url: "workbench/transaction/queryCustomerName.do",
                        type: "post",
                        dataType: "json",
                        data: {
                            customerName: jquery
                        },
                        success: function (data) {
                            process(data)
                        }
                    })
                }
            })

        })
    </script>
</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="activityNameInput" type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
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

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="activitySearch" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="ContactstBody">
<%--                    <tr>--%>
<%--                        <td><input type="radio" name="activity"/></td>--%>
<%--                        <td>李四</td>--%>
<%--                        <td>lisi@bjpowernode.com</td>--%>
<%--                        <td>12345678901</td>--%>
<%--                    </tr>--%>
<%--                    <tr>--%>
<%--                        <td><input type="radio" name="activity"/></td>--%>
<%--                        <td>李四</td>--%>
<%--                        <td>lisi@bjpowernode.com</td>--%>
<%--                        <td>12345678901</td>--%>
<%--                    </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveNewTranBtn">保存</button>
        <button type="button" class="btn btn-default" id="cancelBtn">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-owner">
                <c:forEach items="${requestScope.users}" var="obj">
                    <option value="${obj.id}">${obj.name}</option>
                </c:forEach>
                <%--					<c:forEach items="${stage}" var="obj">--%>
                <%--						<option value="${obj.id}">${obj.value}</option>--%>
                <%--					</c:forEach>--%>
            </select>
        </div>
        <label for="create-money" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-money">
        </div>
    </div>

    <div class="form-group">
        <label for="create-name" class="col-sm-2 control-label">名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-name">
        </div>
        <label for="create-expectedDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control mydate" id="create-expectedDate" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-customerName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
        </div>
        <label for="create-stage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-stage">
                <option></option>
                <c:forEach items="${stage}" var="obj">
                    <option value="${obj.id}">${obj.value}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-type" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-type">
                <option></option>
                <c:forEach items="${transactionType}" var="obj">
                    <option value="${obj.id}">${obj.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-source" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-source">
                <option></option>
                <c:forEach items="${source}" var="obj">
                    <option value="${obj.id}">${obj.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                            data-toggle="modal"
                                                                                            data-target="#findMarketActivity"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <input id="activityId" type="hidden">
        <input id="create-activityId" type="hidden" >
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-activityName" readonly>
        </div>
    </div>

    <div class="form-group">
        <input id="contactId" type="hidden">

        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                            data-toggle="modal"
                                                                                            data-target="#findContacts"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <input id="create-contactsId" type="hidden">
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-contactsName" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-description" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control mydate" id="create-nextContactTime" readonly>
        </div>
    </div>

</form>
</body>
</html>