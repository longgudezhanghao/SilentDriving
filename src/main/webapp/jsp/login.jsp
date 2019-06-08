<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>WebSocket Connection Page</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
</head>
<script type="text/javascript">
    window.onload = function () {
        //var userCd = "<%=request.getSession().getAttribute("USER_CD") %>";
        var userCd = "che";
        if (userCd != null && userCd != "null") {
            // alert("登录成功");
            // 登录成功后，建立websocket连接
            connect();
        }
    }

    var ws = null;
    var target = 'ws://localhost:8080/s/myHandler';

    // 创建WebSocket连接
    function connect() {

        // WebSocket适配

        //此处有点类似向后台发起请求的意思，后台将会对此请求拦截并进行一系列处理
        ws = new WebSocket(target);

        // 注入连接事件
        ws.onopen = function () {
            echo();
            log('连接已建立。');
        };
        // 注入消息事件
        ws.onmessage = function (event) {
           log('新消息：' + event.data);
        };
        // 注入断开事件
        ws.onclose = function (event) {
            log('连接已断开。');
            disconnect();
        };
    }

    // 断开连接,自定义函数
    function disconnect() {
        if (ws != null) {
            ws.close();
            ws = null;
        }
    }

    // 发送消息，作为被调用函数
    function echo() {
        if (ws != null) {
            ws.send("message");
        } else {
            log('connection not established, please connect.');
        }
    }

    // 打印消息,作为被调用函数
    function log(message) {
        var console = document.getElementById('console');
        var p = document.createElement('p');
        p.style.wordWrap = 'break-word';
        p.appendChild(document.createTextNode(message));
        console.appendChild(p);
        while (console.childNodes.length > 25) {
            console.removeChild(console.firstChild);
        }
        console.scrollTop = console.scrollHeight;
    }
</script>

<body>
<%--下面的iframe是用来显示那个发送按键的，本来应该是在（websocket.jsp页面的并与<%=basePath%>/web下面的controller对应）--%>
<iframe id="main" src="<%=basePath%>/web" scrolling="no" frameborder="0" width="100%"></iframe>
<div id="console-container">
    <div id="console"></div>
</div>
</body>

</html>


