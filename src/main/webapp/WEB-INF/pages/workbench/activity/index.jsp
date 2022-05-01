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

            $("#importActivityBtn").click(function () {
               var file=($("#activityFile").val())
                if (file.substr(file.lastIndexOf('.')+1).toLowerCase()!="xls"){
                    alert("只支持xls类型的文件")
                    return
                }
                var activeFile= $("#activityFile")[0].files[0]
                // alert(activeFile.size)
                if (activeFile.size>5*1024*1024)
                {
                    alert("文件大小不能超过5M")
                    return
                }


                var myfiles=new FormData()
                myfiles.append("myfile",activeFile)

                $.ajax({
                    url:"workbench/activity/importActivity.do",
                    data:myfiles,
                    dataType:"json",
                    type:"post",
                    processData: false, // 告诉jQuery不要去处理发送的数据
                    contentType: false,
                    success:function (data){
                        if (data.code=='1'){
                            alert("上传"+"成功")
                            $("#importActivityModal").modal("hide")
                            queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption','rowsPerPage'))

                        }
                        else {
                            alert("上传失败")
                        }
                    }
                })


            })
            //转为dom对象,取出文件




            $("#createActionBtn").click(function () {
                $("#createActivityModal").modal("show")
                $("#createActivityForm")[0].reset();
            });
            //这个地方重新加载并没有意义，本来就不是要动态显示的数据,应该要清零才对
            // $("#createActivityModal").load("http://127.0.0.1:8080/pages/workbench/activity/index.jsp #createActivityModal");

$("#exportActivityAllBtn").click(function (){
    window.location.href="workbench/activity/downLoad.do"
})
            $("#exportActivityXzBtn").click(function (){

             var checked=$("#tBody input:checked")
                if (checked.length>0){
                    // alert(checked.length)
                    var id="";
                    $.each(checked,function (){
                        // alert(this.value)
                        id+="id="+this.value+"&"

                    })
                    id= id.substr(0,id.length-1)
                    window.location.href=("workbench/activity/selectdownLoad.do?"+id)
                    // alert(str)

                }else {
                    alert("请至少选择一条记录")
                    return
                }


            })
            $("#savaCreateActivity ").click(function () {
                var owner = $("#create-marketActivityOwner option:selected").attr("id");
                // alert(owner)
                var name = $.trim($("#create-marketActivityName").val());
                var startDate = $.trim($("#create-startTime").val());
                var endDate = $.trim($("#create-endTime").val());

                var cost = $.trim($("#create-cost").val());
                var description = $.trim($("#create-describe").val());

                if (owner == "") {
                    alert("用户名不能为空");
                    return
                }
                if (name == "") {
                    alert("用户名不能为空");
                    return
                }
                if (startDate != "" && endDate != "") {
                    if (startDate > endDate) {
                        alert("起始时间不能比终止时间晚");
                        return
                    }
                }

                var regExp = /^(([1-9]\d*)|0)$/;
                if (cost!=""){
                    if (!regExp.test(cost)) {
                        alert("必须是非负整数");
                        return;
                    }
                }

                ;
                $.ajax(
                    {
                        url: "workbench/activity/saveCreatActivity.do",
                        data: {
                            "owner": owner, "name": name, "startDate": startDate,
                            "endDate": endDate, "cost": cost, "description": description
                        },
                        dataType: "json"
                        , type: "post"
                        , success(data) {
                            if (data.code == 1) {
                                alert("保存成功")
                                $("#createActivityModal").modal("hide")
                                queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption','rowsPerPage'))

                            } else {
                                alert(cost.message)
                            }
                        }
                    }
                )

            })
            $("#updateActivityById").click(function () {

                var owner = $("#edit-marketActivityOwner option:selected").val();
                // alert(owner)
                // alert(owner)
                var name = $.trim($("#edit-marketActivityName").val());
                var startDate = $.trim($("#edit-startTime").val());
                var endDate = $.trim($("#edit-endTime").val());
                var id=$("#edit-id").val()
                var cost = $.trim($("#edit-cost").val());
                var description = $.trim($("#edit-describe").val());
// alert(owner+name+startDate+endDate+cost+description)
                if (owner == "") {
                    alert("用户名不能为空");
                    return
                }
                if (name == "") {
                    alert("用户名不能为空");
                    return
                }
                if (startDate != "" && endDate != "") {
                    if (startDate > endDate) {
                        alert("起始时间不能比终止时间晚");
                        return
                    }
                }

                var regExp = /^(([1-9]\d*)|0)$/;
                if (cost!=""){
                    if (!regExp.test(cost)) {
                        alert("必须是非负整数");
                        return;
                    }
                }

                ;
                $.ajax(
                    {
                        url: "workbench/activity/updateByPrimaryKey.do",
                        data: {
                            "owner": owner, "name": name, "startDate": startDate,
                            "endDate": endDate, "cost": cost, "description": description,"id":id
                        },
                        dataType: "json"
                        , type: "post"
                        , success(data) {
                            if (data.code == 1) {
                                alert("保存成功")
                                $("#editActivityModal").modal("hide")
                                queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption','rowsPerPage'))

                            } else {
                                alert(cost.message)
                            }
                        }
                    }
                )

            })


            $(".mydate").datetimepicker({
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                minView: 'month',
                initialDate: new Date(),
                autoclose: true, todayBtn: true, todayHighlight: true, keyboardNavigation: true, clearBtn: true
            });
            queryActivityByConditionForPage(1, 10);
// $("#savaCreateActivity").click(function (){
// 	queryActivityByConditionForPage()
// })
            $("#querryByConditionBtn").click(function () {
                queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption','rowsPerPage'))

            })
            $("#all").click(function (){
                // var isChecked=$("#all").prop("checked")
                // alert(isChecked)
                $("input[name=ck]").prop("checked",this.checked)
                // alert($("#tBody input").length)

            });
    //         $("#tBody input[type='checkbox']").click(function () {
    //     //如果列表中的所有checkbox都选中，则"全选"按钮也选中
    //     if($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
    //         $("#all").prop("checked",true);
    //     }else{//如果列表中的所有checkbox至少有一个没选中，则"全选"按钮也取消
    //         $("#all").prop("checked",false);
    //     }
    // });
//             $("#tBody input").click(function (){
//                 alert(1)
//                 // var isChecked=$("#all").prop("checked")
//                 // alert(isChecked)
//                 // alert($("#tBody input").length)
// if ($("#tBody input").length==$("#tBody input:checked").length)
// {
//     $("input[name=ck]").prop("checked",true)
// }
//             else {
//     $("input[name=ck]").prop("checked",false)
// }
//             });

            $("#tBody").on("click","input[type=\"checkbox\"]",function () {
                //如果列表中的所有checkbox都选中，则"全选"按钮也选中
                if($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
                    $("#all").prop("checked",true);
                }else{//如果列表中的所有checkbox至少有一个没选中，则"全选"按钮也取消
                    $("#all").prop("checked",false);
                }
            });

$("#deleteActivityBtn").click(function () {
    var checked=$("#tBody input:checked")
    var i=checked.size()
    if (i<1){
        alert("请选择要删除的记录")
        return
    }    var id="";

 $.each($("#tBody input:checked"),function (index,obj){
// alert(obj.value)
    id+="id="+this.value+"&"
// alert(obj.value)

 })
    // alert(id)
// $.ajax({ur})
    id=id.substr(0,id.length-1)
    // alert(id)
    if (window.confirm("确定删除？"))
    {
        $.ajax({
            url:"workbench/activity/deleteActivityByIds.do",
            data:id,
            dataType:"json",
            type:"post",
            success(data){
                if (data.code=="1"){
                    alert("删除成功")

                    queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'))

                }
                else alert(data.message)
            }
        })
    }

})


           $("#editActivityBtn").click(function (){
               // $("#editActivityForm")[0].reset()
             var edit= $("#tBody input:checked")
               // alert(edit.get(0).value)

               // alert(edit.size())
               var size=edit.size()
               if (size==0){
                   alert("请选择要修改的活动信息")
                   return;
               }
               if (size>1){
                   alert("最多只能选择一个")
                   return
               }
              else {

                  var ids=edit.get(0).value

                   $.ajax({
                       url:"workbench/activity/queryActivityById.do",
                       dataType:"json",
                       type:"post",
                       data:{
                           ids:ids
                       },
                       success(data){
// alert(data.name)
// alert(data.name)
                           $("#edit-id").val(data.id)

                           // alert(data.owner)

                           // $("#edit-marketActivityOwner").val(data.name)
                           $("#edit-marketActivityOwner").prop("value",data.owner)
                           // alert($("#edit-marketActivityOwner").val())
                           // $("#edit-marketActivityName").val(data.name)
                           $("#edit-marketActivityName").prop("value",data.name)
                           $("#edit-startTime").val(data.startDate)
                           $("#edit-endTime").val(data.endDate)
                           // $("#edit-cost").val(data.cost)
                           $("#edit-cost").prop("value",data.cost)
                           $("#edit-describe").val(data.description)
                           $("#editActivityModal").modal("show")
                       }
                   })

               }

               // alert(edit.size)
               // alert(edit.get(0).value)
           })
        });

        function queryActivityByConditionForPage(pageNo, pageSize) {

            var owner = $("#queryowner").val();
            var name = $("#queryname").val();

            var startDate = $("#querystartDate").val();
            var endDate = $("#queryendDate").val();
            // var pageSize = 10;
            // var pageNo = 1;
            $.ajax({
                url: 'workbench/activity/querryActivityByConditionForPage.do',
                data: {
                    name: name,
                    owner: owner,
                    startDate: startDate,
                    endDate: endDate,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: 'post',
                dataType: 'json',
                success: function (data) {
                    // alert(name)
                    //显示总条数
                    // $("#totalRowsB").text(data.totalRows);
                    // alert(pageSize)
                    //显示市场活动的列表
                    //遍历activityList，拼接所有行数据
                    var htmlStr = "";
                    $("#tBody").empty()
                    $("#all").prop("checked",false)
                    // alert(data.activityList[0].id)

                    $.each(data.activityList, function (index, obj) {
// alert(obj.id)
                        $("#tBody").append("<tr class=\"active\">"
                            + "<td><input type=\"checkbox\" name=\"ck\" value=\""+obj.id+"\"/></td>"
                            + "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailActivity.do?id="+obj.id+"+';\">" + obj.name + "</a></td>"
                            + "<td>" + obj.owner + "</td>"
                            + "<td>" + obj.startDate + "</td>"
                            + "<td>" + obj.endDate + "</td>"
                            + "</tr>")

                        });
                        var totalPages = 1;
                        if (data.totalRows % pageSize == 0) {
                            totalPages = data.totalRows / pageSize
                        } else {
                            totalPages = parseInt(data.totalRows / pageSize) + 1

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
                            onChangePage:function (event,pageObj){
                                // alert(pageObj.rowsPerPage)
                                queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage)

                            }
                        // htmlStr += "<tr class=\"active\">";
                        // htmlStr += "<td><input type=\"checkbox\" value=\"" + obj.id + "\"/></td>";
                        // htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.jsp';\">" + obj.name + "</a></td>";
                        // htmlStr += "<td>" + obj.owner + "</td>";
                        // htmlStr += "<td>" + obj.startDate + "</td>";
                        // htmlStr += "<td>" + obj.endDate + "</td>";
                        // htmlStr += "</tr>";
                    });
                    // $("#tBody").html(htmlStr);

                }
            });
        }

    </script>
</head>
<body>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" id="createActivityForm" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">
                                <c:forEach items="${userList}" var="c">
                                    <option id="${c.id}">${c.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="create-startTime" readonly>
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="create-endTime" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="savaCreateActivity">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="editActivityForm">
<input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <c:forEach items="${userList}" var="c">
                                    <option value="${c.id}">${c.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label" id="edit-name">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="edit-startTime" value="2020-10-10"
                                   readonly>
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="edit-endTime" value="2020-10-20"
                                   readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateActivityById" >更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="queryname">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="queryowner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control" type="text" id="querystartDate"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control" type="text" id="queryendDate">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="querryByConditionBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" data-toggle="modal" id="createActionBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default"  id="editActivityBtn"><span
                        class="glyphicon glyphicon-pencil" ></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal">
                    <span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）
                </button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）
                </button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）
                </button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="all"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="tBody">


                </tbody>
            </table>
            <div id="demo_pag1"></div>

        </div>

        <%--			<div style="height: 50px; position: relative;top: 30px;">--%>
        <%--				<div>--%>
        <%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">50</b>条记录</button>--%>
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