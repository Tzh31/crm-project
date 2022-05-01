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
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>

    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">

        $(function () {
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
            $("#savaNewContacts").click(function () {
                // $("#createContactsModal").modal("show")
                var owner = $("#create-contactsOwner option:selected").prop("id")
                var source = $("#create-clueSource option:selected").prop("id")
                var appellation = $("#create-call option:selected").prop("id")
                var job = $("#create-job").val()
                var mphone = $("#create-mphone").val()
                var email = $("#create-email").val()
                var customerId = $("#create-customerName").val()
                var description = $("#create-describe").val()
                var contactSummary = $("#create-contactSummary1").val()
                var nextContactTime = $("#create-nextContactTime1").val()
                var address = $("#edit-address1").val()
                var fullname=$("#create-surname").val()
$.ajax({
    url:"workbench/contacts/saveNewContacts.do",
    dataType:"json",
    type:"post",
    data:{
        fullname:fullname,
        owner             :owner            ,
        source            :source           ,
        appellation       :appellation      ,
        job               :job              ,
        mphone            :mphone           ,
        email             :email            ,
        customerId        :customerId       ,
            description   :    description  ,
        contactSummary    :contactSummary   ,
        nextContactTime   :nextContactTime  ,
        address           :address          ,
    },success:function (data) {
        if (data.code=="1"){
            queryContactsByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'))
            $("#createContactsModal").modal("hide")

        }else {alert(data.message)}
    }
})
                // alert(source)
            })
            $("#deleteContactsBtn").click(function () {
                var id = []
                var contactsList = $("#tBody input:checked")
                if (contactsList.size() > 0) {
                    $.each(contactsList, function (index, obj) {
                        id.push($(this).prop("id"))
                    })
                    $.ajax({
                        url: "workbench/contacts/deleteByIds.do",
                        dataType: "json",
                        type: "post",
                        data: {
                            id: id
                        }, traditional: true,
                        success: function (data) {
                            if (data.code == "1") {
                                alert("删除成功")
                                queryContactsByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'))


                            } else {
                                alert(data.message)
                            }
                        }
                    })

                } else {
                    alert("至少选一个进行删除")
                    return;
                }
                // alert(contactsList)


            })
            $("#all").click(function () {
                $("#tBody input").prop("checked", $(this).prop("checked"))
            })
            $("#tBody").on("click", "input", function () {
                var now = $("#tBody input:checked").prop("checked")
                if ($("#tBody input:checked").size() == $("#tBody input").size()) {
                    $("#all").prop("checked", true)
                } else {
                    $("#all").prop("checked", false)

                }
            })

            queryContactsByConditionForPage(1, 10)
            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });
            $("#queryByConditonBtn").click(function () {
                queryContactsByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'))
            })

        });

        function queryContactsByConditionForPage(pageNo, pageSize) {
            var owner = $.trim($("#query_owner").val())
            var name = $.trim($("#query_name").val())
            var customerId = $.trim($("#query_customer").val())
            var source = $("#query_source option:selected").val()
            // alert(owner+name+customerId+source)
            $.ajax({
                    url: "workbench/contacts/queryContactsByConditionForPage.do",
                    dataType: "json",
                    type: "post",
                    data: {
                        owner: owner,
                        fullname: name,
                        customerId: customerId,
                        source: source,
                        beginNo: pageNo, pageSize: pageSize
                    }, success: function (data) {
                        if (data.code == "1") {
                            var str = ""
                            $.each(data.retData, function (index, obj) {
                                str += "<tr >"
                                str += "	<td><input type=\"checkbox\" id=" + obj.id + "></td>"
                                str += "	<td><a style=\"text-decoration: none; cursor: pointer;\">" + obj.fullname + "</a></td>"
                                str += "	<td>" + obj.customerId + "</td>"
                                str += "	<td>" + obj.owner + "</td>"
                                str += "	<td>" + obj.source + "</td>"
                                str += "	<td>" + obj.nextContactTime + "</td>"
                                str += "</tr>"
                            })
                            $("#tBody").html(str)
                            var totalRows = data.retData1
                            var totalPages = 0
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
                                    queryContactsByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage)

                                }
                                // htmlStr += "<tr class=\"active\">";
                                // htmlStr += "<td><input type=\"checkbox\" value=\"" + obj.id + "\"/></td>";
                                // htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.jsp';\">" + obj.name + "</a></td>";
                                // htmlStr += "<td>" + obj.owner + "</td>";
                                // htmlStr += "<td>" + obj.startDate + "</td>";
                                // htmlStr += "<td>" + obj.endDate + "</td>";
                                // htmlStr += "</tr>";
                            });
                        } else {
                            alert(data.message)
                        }
                    }

                }
            )
        }
    </script>
</head>
<body>


<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-contactsOwner">
                                <c:forEach var="obj" items="${userList}">
                                    <option id="${obj.id}">${obj.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueSource">
                                <option></option>
                                <c:forEach var="obj" items="${source}">
                                    <option id="${obj.id}">${obj.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <option></option>
                                <c:forEach var="obj" items="${appellation}">
                                    <option id="${obj.id}">${obj.value}</option>
                                </c:forEach>
                            </select>
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>

                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-nextContactTime1">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address1">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="savaNewContacts">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改联系人的模态窗口 -->
<div class="modal fade" id="editContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-contactsOwner">
                                <c:forEach var="obj" items="${userList}">
                                    <option id="${obj.id}">${obj.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-clueSource1" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueSource1">
                                <option></option>
                                <c:forEach var="obj" items="${source}">
                                    <option id="${obj.id}">${obj.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-surname" value="李四">
                        </div>
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <option></option>
                                <c:forEach var="obj" items="${appellation}">
                                    <option id="${obj.id}">${obj.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address2" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address2">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>联系人列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="query_owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">姓名</div>
                        <input class="form-control" type="text" id="query_name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="query_customer">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="query_source">
                            <option></option>
                            <c:forEach var="obj" items="${source}">
                                <option id="${obj.id}">${obj.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>


                <button type="button" class="btn btn-default" id="queryByConditonBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createContactsModal">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editContactsModal"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteContactsBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 20px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="all"/></td>
                    <td>姓名</td>
                    <td>客户名称</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>下次联系时间</td>
                </tr>
                </thead>
                <tbody id="tBody">

                <%--                        <tr class="active">--%>
                <%--                            <td><input type="checkbox" /></td>--%>
                <%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>--%>
                <%--                            <td>动力节点</td>--%>
                <%--                            <td>zhangsan</td>--%>
                <%--                            <td>广告</td>--%>
                <%--                            <td>2000-10-10</td>--%>
                <%--                        </tr>--%>
                </tbody>
            </table>
        </div>
        <div id="demo_pag1"></div>
        <%--			<div style="height: 50px; position: relative;top: 10px;">--%>
        <%--				<div>--%>
        <%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
        <%--				</div>--%>
        <%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
        <%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
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
        <%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
        <%--				</div>--%>
        <%--				<div style="position: relative;top: -88px; left: 285px;">--%>
        <%--					<nav>--%>
        <%--						<ul class="pagination">--%>
        <%--							<li class="disabled"><a href="#">首页</a></li>--%>
        <%--							<li class="disabled"><a href="#">上一页</a></li>--%>
        <%--							<li class="active"><a href="#">1</a></li>--%>
        <%--							<li><a href="#">2</a></li>--%>
        <%--							<li><a href="#">3</a></li>--%>
        <%--							<li><a href="#">4</a></li>--%>
        <%--							<li><a href="#">5</a></li>--%>
        <%--							<li><a href="#">下一页</a></li>--%>
        <%--							<li class="disabled"><a href="#">末页</a></li>--%>
        <%--						</ul>--%>
        <%--					</nav>--%>
        <%--				</div>--%>
        <%--			</div>--%>

    </div>

</div>
</body>
</html>