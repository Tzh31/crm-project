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
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>

    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <script type="text/javascript">

        $(function () {
$("#editTranBtn").click(function () {
    var id=$("#tBody input:checked").prop("id")
    // alert(id)
    window.location.href="workbench/transaction/edit.do?id="+id
})
            $("#all").click(function () {
                // $("all").val()
                // alert()
                $("#tBody input").prop("checked", this.checked)
            })
            // $("#editTranBtn").click(function () {
            //     window.location.href='edit.jsp'
            // })
            $("#tBody").on("click", "input", function () {
                // alert(1)
                if ($("#tBody input:checked").size() == $("#tBody input").size()) {
                    $("#all").prop("checked", true)
                } else {
                    $("#all").prop("checked", false)
                }
            })
            $("#saveNewTran").click(function () {
                window.location.href = "workbench/transaction/save.do"
            })
            queryActivityByConditionForPage(1, 10)
            $("#queryByConditionBtn").click(function () {
                queryActivityByConditionForPage(1, 10)
            })

        });

        function queryActivityByConditionForPage(pageNo, pageSize) {
            var owner = $("#query_owner").val();
            var name = $("#query_name").val();
            var customer = $("#query_customer").val()
            var stage = $("#query_stage option:selected").val()
            var type = $("#query_type option:selected").val()
            var source = $("#create-clueSource option:selected").val()
            var contacts = $("#contacts_name").val()
            $.ajax({
                url: "workbench/transaction/queryTranByConditionForPage.do",
                dataType: "json",
                type: "post",
                data: {
                    owner: owner,
                    name: name,
                    stage: stage,
                    type: type,
                    customer_id: customer,
                    source: source,
                    contacts_id: contacts,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                success: function (data) {
                    var str = ""
                    $.each(data.trans, function (index, obj) {


                        str += "	<tr>";
                        str += "		<td><input type=\"checkbox\" id='"+obj.id+"'/></td>";
                        str += "		<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/transaction/detail.do?tranId=" + obj.id + "';\">" + obj.name + "</a></td>";
                        str += "		<td>" + obj.customerId + "</td>";
                        str += "		<td>" + obj.stage + "</td>";
                        str += "		<td>" + obj.type + "</td>";
                        str += "		<td>" + obj.owner + "</td>";
                        str += "		<td>" + obj.source + "</td>";
                        str += "		<td>" + obj.contactsId + "</td>";
                        str += "	</tr>";

                    })
                    $("#tBody").html(str)
                    var totalPages
                    var totalRows = data.totalRows
                    if (totalRows % pageSize == 0) {
                        totalPages = totalRows / pageSize
                    } else {
                        totalPages = parseInt(totalRows / pageSize) + 1
                    }

                    $("#demo_pag1").bs_pagination({
                        currencyPage: pageNo,
                        rowsPerPage: pageSize,
                        totalRows: data.totalRows,
                        maxRowsPerPage: 10,
                        totalPages: totalPages,
                        showGoToPage: true,
                        showRowsInfo: true,
                        showRowsPerPage: true,
                        onChangePage: function (event, pageObj) {
                            // alert(pageObj.rowsPerPage)
                            queryActivityByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage)

                        }
                        // htmlStr += "<tr class=\"active\">";
                        // htmlStr += "<td><input type=\"checkbox\" value=\"" + obj.id + "\"/></td>";
                        // htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.jsp';\">" + obj.name + "</a></td>";
                        // htmlStr += "<td>" + obj.owner + "</td>";
                        // htmlStr += "<td>" + obj.startDate + "</td>";
                        // htmlStr += "<td>" + obj.endDate + "</td>";
                        // htmlStr += "</tr>";
                    });
                }
            })

        }
    </script>
</head>
<body>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>????????????</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">?????????</div>
                        <input class="form-control" type="text" id="query_owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <input class="form-control" type="text" id="query_name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">????????????</div>
                        <input class="form-control" type="text" id="query_customer">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <select class="form-control" id="query_stage">
                            <option></option>
                            <c:forEach var="obj" items="${stage}">
                                <option id="${obj.id}">${obj.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <select class="form-control" id="query_type">
                            <option></option>
                            <c:forEach var="obj" items="${transactionType}">
                                <option id="${obj.id}">${obj.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <select class="form-control" id="create-clueSource">
                            <option></option>
                            <c:forEach var="obj" items="${source}">
                                <option id="${obj.id}">${obj.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">???????????????</div>
                        <input class="form-control" type="text" id="contacts_name">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="queryByConditionBtn">??????</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="saveNewTran"><span
                        class="glyphicon glyphicon-plus"></span> ??????
                </button>
                <button type="button" class="btn btn-default" id="editTranBtn"><span
                        class="glyphicon glyphicon-pencil"></span> ??????
                </button>
                <button type="button" class="btn btn-danger" id="deleteTranBtn"><span
                        class="glyphicon glyphicon-minus"></span> ??????
                </button>
            </div>


        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="all"/></td>
                    <td>??????</td>
                    <td>????????????</td>
                    <td>??????</td>
                    <td>??????</td>
                    <td>?????????</td>
                    <td>??????</td>
                    <td>???????????????</td>
                </tr>
                </thead>
                <tbody id="tBody">
                <%--						<tr>--%>
                <%--							<td><input type="checkbox" /></td>--%>
                <%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">????????????-??????01</a></td>--%>
                <%--							<td>????????????</td>--%>
                <%--							<td>??????/??????</td>--%>
                <%--							<td>?????????</td>--%>
                <%--							<td>zhangsan</td>--%>
                <%--							<td>??????</td>--%>
                <%--							<td>??????</td>--%>
                <%--						</tr>--%>
                <%--                        <tr class="active">--%>
                <%--                            <td><input type="checkbox" /></td>--%>
                <%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">????????????-??????01</a></td>--%>
                <%--                            <td>????????????</td>--%>
                <%--                            <td>??????/??????</td>--%>
                <%--                            <td>?????????</td>--%>
                <%--                            <td>zhangsan</td>--%>
                <%--                            <td>??????</td>--%>
                <%--                            <td>??????</td>--%>
                <%--                        </tr>--%>

                </tbody>
            </table>
            <div id="demo_pag1"></div>
        </div>

        <%--			<div style="height: 50px; position: relative;top: 20px;">--%>
        <%--				<div>--%>
        <%--					<button type="button" class="btn btn-default" style="cursor: default;">???<b>50</b>?????????</button>--%>
        <%--				</div>--%>
        <%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
        <%--					<button type="button" class="btn btn-default" style="cursor: default;">??????</button>--%>
        <%--					<div class="btn-group">--%>
        <%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
        <%--							10--%>
        <%--							<span class="caret"></span>--%>
        <%--						</button>--%>
        <%--						<ul class="dropdown-menu" role="menu">--%>
        <%--							<li><a href="#">20</a></li>--%>
        <%--							<li><a href="#">30</a></li>--%>
        <%--						</ul>--%>
        <%--					</div>--%>
        <%--					<button type="button" class="btn btn-default" style="cursor: default;">???/???</button>--%>
        <%--				</div>--%>
        <%--				<div style="position: relative;top: -88px; left: 285px;">--%>
        <%--					<nav>--%>
        <%--						<ul class="pagination">--%>
        <%--							<li class="disabled"><a href="#">??????</a></li>--%>
        <%--							<li class="disabled"><a href="#">?????????</a></li>--%>
        <%--							<li class="active"><a href="#">1</a></li>--%>
        <%--							<li><a href="#">2</a></li>--%>
        <%--							<li><a href="#">3</a></li>--%>
        <%--							<li><a href="#">4</a></li>--%>
        <%--							<li><a href="#">5</a></li>--%>
        <%--							<li><a href="#">?????????</a></li>--%>
        <%--							<li class="disabled"><a href="#">??????</a></li>--%>
        <%--						</ul>--%>
        <%--					</nav>--%>
        <%--				</div>--%>
        <%--			</div>--%>

    </div>

</div>
</body>
</html>