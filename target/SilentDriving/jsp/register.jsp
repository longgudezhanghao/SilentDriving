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
        .register{
            position: absolute;
            top: 50%;
            left: 50%;
            margin: -15% 0 0 -15%;
            width: 25%;
            height: 50%;
            text-align: center;/*(让div中的内容居中)*/
        }
    </style>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>SilentDriving注册页面</title>
    <link rel="stylesheet" href="${ctx}/static/plugins/layui/css/layui.css">
    <script src="${ctx}/static/plugins/layui/layui.js"></script>
    <script src="${ctx}/static/plugins/jquery/jquery-3.4.1.js"></script>
</head>
<body>
<div class="register">
                        <div id="title"><h1 style="padding: 0px 0px 20px 20%;">个人注册页面</h1></div>
<form class="layui-form">
    <div class="layui-form-item">
        <label class="layui-form-label">姓名</label>
        <div class="layui-input-block">
            <input type="text" name="name" required  lay-verify="required" placeholder="请输入姓名" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">年龄</label>
        <div class="layui-input-block">
            <input type="text" name="age" required  lay-verify="required" placeholder="请输入年龄" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">密码</label>
        <div class="layui-input-inline">
            <input type="password" name="password" required lay-verify="required" placeholder="请输入密码" autocomplete="off" class="layui-input">
        </div>
        <div class="layui-form-mid layui-word-aux">辅助文字</div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">居住城市</label>
        <div class="layui-input-block">
            <select name="city" lay-verify="required">
                <option value="湖南">湖南</option>
                <option value="北京">北京</option>
                <option value="上海">上海</option>
                <option value="广州">广州</option>
                <option value="深圳">深圳</option>
                <option value="杭州">杭州</option>
            </select>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">性别</label>
        <div class="layui-input-block">
            <input type="radio" name="sex" value="男" title="男">
            <input type="radio" name="sex" value="女" title="女" checked>
        </div>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">爱好</label>
        <div class="layui-input-block">
            <textarea name="hobby" placeholder="请输入内容" class="layui-textarea"></textarea>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
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
            layer.msg("注册成功，欢迎您使用SilentDriving！");
            $.ajax({
                url: '${ctx}/register',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(person.field),
                success: function (data) {

                }
            })
            return false;
        });
    });
</script>
</body>
</html>
