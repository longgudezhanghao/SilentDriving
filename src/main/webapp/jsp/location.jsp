<%--
  Created by IntelliJ IDEA.
  User: dengzhihui
  Date: 19-5-8
  Time: 下午10:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>WebSocket Connection Page</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no"/>
    <style type="text/css">
        body, html, #allmap {
            width: 100%;
            height: 100%;
            overflow: hidden;
            margin: 0;
            font-family: "微软雅黑";
        }
    </style>
    <script type="text/javascript"
            src="http://api.map.baidu.com/api?v=2.0&ak=VatuKFzIEelTNW9rP1vtpLyVP0jQjrSF"></script>
    <script src="${ctx}/static/plugins/jquery/jquery-3.4.1.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/library/GeoUtils/1.2/src/GeoUtils_min.js"></script>
    <title>浏览器定位</title>
</head>
<body>
<div id="allmap"></div>
</div>
</body>
</html>
<script type="text/javascript">

    window.onload = function () {
        var userCd = "<%=request.getSession().getAttribute("USER_CD") %>";
        if (userCd != null && userCd != "null") {
            alert("登录成功");
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
            //echo();
            alert('连接已建立。');
        };

        // 注入消息事件
        ws.onmessage = function (event) {
            alert('您的消息：' + event.data);
        };
        // 注入断开事件
        ws.onclose = function (event) {
            alert('连接已断开。');
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
    function echo(otherID) {
        alert(otherID);
        if (ws != null) {
            ws.send(otherID+"号，请快点走！");
        } else {
            alert('connection not established, please connect.');
        }
    }

    // 创建地图map和其他元素
    var map = new BMap.Map("allmap");
    var point = new BMap.Point(113.114171, 27.824301);
    //地图控件begin
    map.centerAndZoom(point, 18);
    var stCtrl = new BMap.PanoramaControl();
    stCtrl.setOffset(new BMap.Size(20, 40));
    map.addControl(stCtrl);
    map.addControl(new BMap.NavigationControl());
    map.addControl(new BMap.ScaleControl());
    map.addControl(new BMap.OverviewMapControl());
    map.addControl(new BMap.MapTypeControl());
    //地图控件end
    map.enableScrollWheelZoom();   //启用滚轮放大缩小，默认禁用
    map.enableContinuousZoom();    //启用地图惯性拖拽，默认禁用
    var markers = [];       //储存其他车辆点的位置
    var circle;             //以用户为中心的一个圆形区域，用来确认距离
    var mylng;          //用户位置全局lng
    var mylat;          //用户位置全局lat
    var m = true;
    var em = true;
    var mk = new BMap.Marker();//当前用户的全局标注

    //控件1设置begin
    // 定义一个控件类,即function
    function ZoomControl() {
        // 默认停靠位置和偏移量
        this.defaultAnchor = BMAP_ANCHOR_TOP_LEFT;
        this.defaultOffset = new BMap.Size(10, 10);
    }

    // 通过JavaScript的prototype属性继承于BMap.Control
    ZoomControl.prototype = new BMap.Control();
    // 自定义控件必须实现自己的initialize方法,并且将控件的DOM元素返回
    // 在本方法中创建个div元素作为控件的容器,并将其添加到地图容器中
    ZoomControl.prototype.initialize = function (map) {
        // 创建一个DOM元素
        var div = document.createElement("div");
        // 添加文字说明
        div.appendChild(document.createTextNode("传输经纬度以及返回其他车辆位置"));
        // 设置样式
        div.style.cursor = "pointer";
        div.style.border = "1px solid gray";
        div.style.backgroundColor = "grey";
        // 绑定事件,将位置数据传回后台
        div.onclick = function (e) {
            var obj = {
                'lng': mylng,
                'lat': mylat,
                'id':${userID}

            };
            $.ajax({
                url: '${ctx}/map/storelocation',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(obj),
                success: function (data) {
                    alert('success');
                }
            })
        }
        // 添加DOM元素到地图中
        map.getContainer().appendChild(div);
        // 将DOM元素返回
        return div;
    }
    //控件1设置end

    //创建控件2begin
    function ZoomControl2() {
        this.defaultAnchor = BMAP_ANCHOR_TOP_LEFT;
        this.defaultOffset = new BMap.Size(10, 40);
    }

    ZoomControl2.prototype = new BMap.Control();
    ZoomControl2.prototype.initialize = function (map) {
        var div2 = document.createElement("div2");
        div2.appendChild(document.createTextNode("展示别人的车辆位置"));
        div2.style.cursor = "pointer";
        div2.style.border = "1px solid gray";
        div2.style.backgroundColor = "white";
        //将从后台接受到的数据展示在前台
        div2.onclick = function (e) {
            $.ajax({
                url: '${ctx}/map/search?id=' + ${userID},
                type: 'get',
                success: function (data) {
                    markers.splice(0, markers.length);
                    map.clearOverlays();
                    for (var i = 0; i < data.length; i++) {
                        var point = new BMap.Point(data[i].lng, data[i].lat);
                        var marker = new BMap.Marker(point);// 创建标注
                        markers.push(marker);
                        marker.setTitle(data[i].id);
                        var title = data[i].id;
                        marker.addEventListener("click",function (e) {
                            echo(title);
                        });
                        map.addOverlay(marker);// 将标注添加到地图中
                    }
                }
            });
        }
        map.getContainer().appendChild(div2);
        return div2;
    }
    //创建控件2end

    //创建控件3begin
    function ZoomControl3() {
        this.defaultAnchor = BMAP_ANCHOR_TOP_LEFT;
        this.defaultOffset = new BMap.Size(10, 80);
    }

    ZoomControl3.prototype = new BMap.Control();
    ZoomControl3.prototype.initialize = function (map) {
        var div3 = document.createElement("div3");
        div3.appendChild(document.createTextNode("确定范围内车辆"));
        div3.style.cursor = "pointer";
        div3.style.border = "1px solid gray";
        div3.style.backgroundColor = "blue";
        //找出范围内车辆
        div3.onclick = function (e) {
            for (var i = 0; i < markers.length; i++) {
                var number = 0;
                var marker = markers[i];
                var point = marker.getPosition();
                if (BMapLib.GeoUtils.isPointInCircle(point, circle)) {
                    var obj = {
                        'lng': point.lng,
                        'lat': point.lat,
                        'id': marker.getTitle(),
                        'userID':${userID}
                    }
                    $.ajax({
                        url: '${ctx}/map/storelocationinrange',
                        type: 'post',
                        contentType: 'application/json',
                        data: JSON.stringify(obj),
                        success: function (data) {
                            alert('success');
                        }
                    });
                    alert("有" + (++number) + "点在圆内");
                } else {
                    alert("此点在圆形外")
                }
            }
        }
        map.getContainer().appendChild(div3);
        return div3;
    }
    //创建控件3end

    //地图定位
    var geolocation = new BMap.Geolocation();
    function x() {
        //
        setInterval(function () {
            geolocation.getCurrentPosition(function (r) {
                if (this.getStatus() == BMAP_STATUS_SUCCESS) {

                    map.removeOverlay(mk);

                    var pointI = r.point;
                    mk = new BMap.Marker(r.point);
                    mylng = r.point.lng;
                    mylat = r.point.lat;
                    map.addOverlay(mk);
                    mk.setAnimation(BMAP_ANIMATION_BOUNCE);
                    mk.setTitle(${userID});
                    mk.addEventListener("click",function (e) {
                        echo(${userID});
                    });
                    map.panTo(r.point);
                    //此处while循环是保持confirm只会运行一次，里面的while也是，em，m定义在全局
                    while(em == true) {
                        e = confirm(mylng + " " + mylat);
                        if (e == true) {
                            while (m == true) {
                                circle = new BMap.Circle(pointI, 10000, {
                                    fillColor: "blue",
                                    strokeWeight: 1,
                                    fillOpacity: 0.3,
                                    strokeOpacity: 0.3
                                });
                                circle.disableMassClear();
                                map.addOverlay(circle);
                                m = false;
                            }
                        }
                        em = false;
                    }
                } else {
                    alert('failed' + this.getStatus());
                }
            },
                {enableHighAccuracy: true, maximumAge: 0})
        },2*1000);
        //
        ControlsCreate();
    }

    //所有控件的创建
    function ControlsCreate() {
            // 创建所有控件begin
            var myZoomCtrl = new ZoomControl();
            map.addControl(myZoomCtrl);
            var myZoomCtrl2 = new ZoomControl2();
            map.addControl(myZoomCtrl2);
            var myZoomCtrl3 = new ZoomControl3();
            map.addControl(myZoomCtrl3);
            //创建控件end
    }
    
    x();

</script>

