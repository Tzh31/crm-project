<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript">
    $(function () {
        $("#fileDownLoad").click(function (){
            window.location.href="workbench/activity/fileDownLoad.do"
        })
    })
</script>
</head>
<body>
<%--<input type="button" value="上传" id="fileDownLoad">--%>
<form action="workbench/activity/fileUpLoad.do" method="post" enctype="multipart/form-data">
    <input type="file" name="myfile" >
    <input type="submit" value="提价" >
</form>
</body>
</html>
