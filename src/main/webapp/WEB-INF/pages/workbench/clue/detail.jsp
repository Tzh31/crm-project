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

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {

            $("#bindActionActivityBtn").click(function () {

                // var id = ""
                var id = []
                var ActionIdList = $("#bindBody input[name=ck]:checked")
                if (ActionIdList.size() == 0) {
                    alert("请至少选择一项")
                    return
                }

                $.each(ActionIdList, function (index, obj) {
                    id.push(obj.value)
                    // id += "id=" + obj.value + "&"
                })
                // id = id.substr(0, id.length - 1)
// alert(id)
                $.ajax({
                    dataType: "json",
                    type: "post",
                    url: "workbench/clue/saveCreateClueActivityForDetailByNameClueId.do",

                    data: {
                        id: id,
                        clueId: "${clue.id}",

                    }, traditional: true,
                    success: function (data) {
// alert(data)
                        if (data.code == 1) {
                            $("#bundModal").modal("hide")

                            $.each(data.retData, function (index, obj) {

                                $("#relationedTBody").append(
                                    "<tr id=\"tr_" + obj.id + "\">"
                                    + "	<td>" + obj.name + "</td>"
                                    + "	<td>" + obj.startDate + "</td>"
                                    + "	<td>" + obj.endDate + "</td>"
                                    + "	<td>" + obj.owner + "</td>"
                                    + "<td><a href=\"javascript:void(0);\" activityID=" + obj.id + " style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>"
                                    + "</tr>")

                            })
                        } else {
                            alert(dara.message)
                        }

                    }
                })
            })
            $("#all").click(function () {
                var isCheck = $("#all").prop("checked")
                // alert(id)
                $("#bindBody input[name=ck]").prop("checked", isCheck)
            })
            $("#bindBody").on("click", "input[name=ck]", function () {
                if ($("#bindBody input").size() == $("#bindBody input[name=ck]:checked").size()) {
                    $("#all").prop("checked", true)
                } else {
                    $("#all").prop("checked", false)


                }
            })
$("#RemarksList").on("click","a[name=deleteA]",function () {
    var clueRemarkId=$(this).attr("remarkId")
    // alert(remarkId)
    $.ajax({
        url:"workbench/clue/deleteClueRemarkByRemarkId.do",
         type: "post",
        dataType:"json",
        data: {
            clueRemarkId:clueRemarkId

    },
        success:function (data) {

            if (data.code!=1){
                alert(data.message)
            }
else {
                $("#div_"+clueRemarkId).remove()
            }
        }

})
})
            $("#queryActivityNameInput").keyup(function () {
                if ($("#queryActivityNameInput").val() == "") {
                    $("#bindBody").empty()
                    return
                }
                var activityName = $("#queryActivityNameInput").val()
                var clueId = "${requestScope.clue.id}"
                // alert(clueId)
                $.ajax({
                    url: "workbench/clue/selectActivityForDetailByNameClueId.do",
                    dataType: "json",
                    type: "post",
                    data: {
                        activityName: activityName,
                        clueId: clueId
                    },
                    success: function (data) {
                        $("#bindBody").empty()
                        // alert("")
                        $.each(data.activities, function (index, obj) {

                            $("#bindBody").append(
                                "<tr>"
                                + "	<td><input type=\"checkbox\" name='ck' value='" + obj.id + "'/></td>"
                                + "	<td>" + obj.name + "</td>"
                                + "	<td>" + obj.startDate + "</td>"
                                + "	<td>" + obj.endDate + "</td>"
                                + "	<td>" + obj.owner + "</td>"
                                + "</tr>")

                        })


                    }
                })
                // alert(activityName)

            })
            $("#savaCreateClueRemarkBtn").click(function () {
                var noteContent = $.trim($("#remark").val())

                $.ajax({
                    data: {
                        clueId: "${clue.id}",
                        noteContent: noteContent
                    },
                    url: "workbench/clue/saveClueRemark.do",
                    dataType: "json",
                    type: "post",
                    success: function (data) {
                        if (data.code == 1) {
                            $("#remark").val("");

                            // alert("发表成功")
                            var htmlStr = "";
                            htmlStr += "<div style=\"height: 60px;\" id=\"div_" + data.retData.id + "\" class=\"remarkDiv\">";
                            htmlStr += "                   <img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
                            htmlStr += "                  <div style=\"position: relative; top: -40px; left: 40px;\">";
                            htmlStr += "                 <h5 id=\"h5_" + data.retData.id + "\">" + data.retData.noteContent + "</h5>";
                            htmlStr += "               <font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b></b>";
                            htmlStr += "                  <small style=\"color: gray;\" id=\"small_" + data.retData.id + "\"> " + data.retData.createTime + "由${sessionScope.sessionUser.name}创建</small>";
                            htmlStr += "           <div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
                            htmlStr += "               <a class=\"myHref\" href=\"javascript:void(0);\" name=\"editA\" remarkId=" + data.retData.id + "><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "               &nbsp;&nbsp;&nbsp;&nbsp;";
                            htmlStr += "               <a class=\"myHref\" href=\"javascript:void(0);\" name=\"deleteA\" remarkId=" + data.retData.id + "><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "           </div>";
                            htmlStr += "       </div>";
                            htmlStr += "   </div>";
                            $("#remarkDiv").before(htmlStr);

                        } else {
                            alert(data.message)
                        }
                    }
                })

            })

            $("#RemarksList").on("click", "a[name='editA']", function () {
                var id = $(this).attr("remarkId")
                // alert(id)
                var noteContent = $("#h5_" + id).html()
                // alert(noteContent)
                $("#noteContent").val(noteContent)

                $("#editRemarkModal").modal("show")
                //给修改的框框的隐藏域赋值
                $("#remarkId").val(id)

            })
            $("#updateRemarkBtn").click(function () {

                var noteContent = $.trim($("#noteContent").val())
                if (noteContent == "") {
                    alert("请输入内容后再提交")
                    return
                }
                var id = $("#remarkId").val()
                $.ajax({
                    url: "workbench/clue/editClueRemark.do",
                    type: "post"
                    ,
                    dataType: "json",
                    data: {
                        id: id,
                        noteContent: noteContent
                    }
                    ,
                    success: function (data) {
                        // data.retData
                        if (data.code == "1") {
                            // var id=$(this).attr("remarkId")

                            alert("修改成功")
                            $("#editRemarkModal").modal("hide")
                            var noteContent = data.retData.noteContent
                            // alert(noteContent)
                            $("#h5_" + id).text(noteContent)
                            $("#small_" + id).text(
                                " " + data.retData.editTime + " 由${sessionScope.sessionUser.name}修改"
                            )


                        } else {
                            alert(data.message)
                        }
                    }
                })
                // alert(id)
                // alert(noteContext)

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
            $("#toConvertBtn").click(function () {
                window.location.href = "workbench/clue/toConvert.do?id=" + "${clue.id}"
            })
            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });
            $("#RemarksList").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();

            })
            // $(".remarkDiv").mouseover(function () {
            //     $(this).children("div").children("div").show();
            // });

            $("#RemarksList").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();

            })
            // $(".remarkDiv").mouseout(function () {
            //     $(this).children("div").children("div").hide();
            // });
            $("#RemarksList").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");

            })
            // $(".myHref").mouseover(function () {
            //     $(this).children("span").css("color", "red");
            // });
            $("#RemarksList").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");

            })
            $("#bindActivityBtn").click(function () {
                $("#queryActivityNameInput").val("")
                $("#bindBody").empty()
// alert(  $("#bindBody").html())
                $("#bundModal").modal("show")
            })

            $("#relationedTBody").on("click", "a", function () {
                // alert((this.attr("activityID")))
                var activityId = ($(this).attr("activityID"))
                var clueId = "${clue.id}"
                // alert(clueId)
                $.ajax({
                    url: "workbench/clue/deleteClueActivityRelationByClueIdActivityId.do",
                    dataType: "json",
                    type: "post",
                    data: {
                        clueId: clueId,
                        activityId: activityId
                    },
                    success: function (data) {
                        // alert(data.code)

                        if (data.code == 1) {
                            $("#tr_" + activityId).remove()
                        } else {
                            alert(data.message)
                        }
                    }
                })
            })
            // $(".remarkDiv").mouseover(function(){
            // 	$(this).children("div").children("div").show();
            // });
            //
            // $(".remarkDiv").mouseout(function(){
            // 	$(this).children("div").children("div").hide();
            // });
            //
            // $(".myHref").mouseover(function(){
            // 	$(this).children("span").css("color","red");
            // });
            //
            // $(".myHref").mouseout(function(){
            // 	$(this).children("span").css("color","#E6E6E6");
            // });
        });

    </script>

</head>
<body>

<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="queryActivityNameInput" type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="all"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="bindBody">

                    <%--							<tr>--%>
                    <%--								<td><input type="checkbox"/></td>--%>
                    <%--								<td>发传单</td>--%>
                    <%--								<td>2020-10-10</td>--%>
                    <%--								<td>2020-10-20</td>--%>
                    <%--								<td>zhangsan</td>--%>
                    <%--							</tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="bindActionActivityBtn">关联</button>
            </div>
        </div>
    </div>
</div>


<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" id="toConvertBtn"><span
                class="glyphicon glyphicon-retweet"></span> 转换
        </button>

    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;">
            <b>${clue.fullname}${clue.appellation}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">线索状态</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 40px; left: 40px;" id="RemarksList">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->
    <c:forEach items="${clueRemark}" var="remark">
        <div class="remarkDiv" style="height: 60px;" id="div_${remark.id}">
            <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5 id="h5_${remark.id}">${remark.noteContent}</h5>
                <font color="gray">线索</font> <font color="gray">-</font> <b>${createBy}</b>
                <small style="color: gray;"
                       id="small_${remark.id}"> ${remark.editFlag=="1"?remark.editTime:remark.createTime}
                    由${remark.editFlag=="1"? remark.editBy:remark.createBy}${remark.editFlag=='1'?'修改':'创建'}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" href="javascript:void(0);" name="editA" remarkId=${remark.id}><span
                            class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" href="javascript:void(0);" name="deleteA" remarkId=${remark.id}><span
                            class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>

    <div class="modal fade" id="editRemarkModal" role="dialog">
        <%-- 备注的id --%>
        <input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>

                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="noteContent" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    <%--		<!-- 备注2 -->--%>
    <%--		<div class="remarkDiv" style="height: 60px;">--%>
    <%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
    <%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
    <%--				<h5>呵呵！</h5>--%>
    <%--				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
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
                <button type="button" class="btn btn-primary" id="savaCreateClueRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="relationedTBody">
                <c:forEach items="${activity}" var="act">
                    <tr id="tr_${act.id}">
                        <td>${act.name}</td>
                        <td>${act.startDate}</td>
                        <td>${act.endDate}</td>
                        <td>${act.owner}</td>
                        <td><a href="javascript:void(0);" style="text-decoration: none;" name="deleteClueActivityBtn"
                               activityID=${act.id}><span
                                class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                    </tr>
                </c:forEach>
                <%--						<tr>--%>
                <%--							<td>发传单</td>--%>
                <%--							<td>2020-10-10</td>--%>
                <%--							<td>2020-10-20</td>--%>
                <%--							<td>zhangsan</td>--%>
                <%--							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
                <%--						</tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a id="bindActivityBtn" href="javascript:void(0);" style="text-decoration: none;"><span
                    class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>