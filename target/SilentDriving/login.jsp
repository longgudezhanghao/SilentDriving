<%--
  Created by IntelliJ IDEA.
  User: dengzhihui
  Date: 19-5-29
  Time: 下午9:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <style type="text/css">
        .login{
            position: absolute;
            top: 50%;
            left: 50%;
            margin: -10% 0 0 -13%;
            width: 20%;
            height: 50%;
        }
    </style>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>SilentDriving登入页面</title>
    <link rel="stylesheet" href="${ctx}/static/plugins/layui/css/layui.css">
    <script src="${ctx}/static/plugins/layui/layui.js"></script>
    <script src="${ctx}/static/plugins/jquery/jquery-3.4.1.js"></script>
</head>
<body>
<div class="login">
    <form class="layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">姓名</label>
            <div class="layui-input-block">
                <input type="text" name="name" required  lay-verify="required" placeholder="请输入姓名" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">密码</label>
            <div class="layui-input-inline">
                <input type="password" name="password" required lay-verify="required" placeholder="请输入密码" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="formDemo">立即登入</button>
            </div>
        </div>
    </form>
</div>
<script>
    //Demo
    layui.use('form', function(){
        var form = layui.form;
        //监听提交
        form.on('submit(formDemo)', function(person){
            layer.msg("登入成功，欢迎您使用SilentDriving！");
            $.ajax({
                url: '${ctx}/login',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(person.field),
                success: function (data) {
                    alert('success');
                }
            })
            return false;
        });
    });
</script>
</body>
</html>
