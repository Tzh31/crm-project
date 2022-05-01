<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">

		$(window).keydown(function (e){
			if (e.keyCode==13){
				$("#loginBtn").click()

			}
		})
		$(function (){


			$("#loginBtn").click(function (){
var loginAct=$.trim($("#loginAct").val()) ;
var loginPwd=$.trim($("#loginPwd").val());
var idRemPwd=$("#idRemPwd").prop("checked");

$.ajax({
	url:'setting/qx/user/login.do',
	dataType:"json",
	data:{
		loginAct:loginAct,
		loginPwd:loginPwd,
		idRemPwd:idRemPwd
	},
	type:"post",
	success:function(data){
		// alert(idRemPwd)
if (data.code==1){
	window.location.href="workbench/index.do";
}else {
	// alert(data.message)
	$("#msg").text(data.message);
}
	},beforeSend:function (){
		if (loginAct==""){
			alert("账号未输入");
			return false;
		}
		if(loginPwd==""){
			alert("密码未输入");
			return false;
		}
		$("#msg").text("请稍后.....");
		return true;
	}


})


			})
		})
	</script>
</head>
<%--<%--%>
<%--	for (Cookie cookie : request.getCookies()) {--%>
<%--		System.out.println(cookie.getName()+"  "+cookie.getValue());--%>
<%--	}%>--%>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;陶子涵</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginAct" type="text" value="${cookie.loginAct.value}" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginPwd" type="password" value="${cookie.loginPwd.value}" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
							<label>
								<input type="checkbox" id="idRemPwd" checked> 十天内免登录
							</label>
						</c:if>
						<c:if test="${empty cookie.loginAct or empty cookie.loginPwd}">
							<label>
								<input type="checkbox" id="idRemPwd" > 十天内免登录
							</label>
						&nbsp;&nbsp;</c:if>
						<span id="msg"></span>
					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>