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
</body>
</html>
<script type="text/javascript">
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
    var points = [];       //储存其他车辆点的位置
    var circle;             //以用户为中心的一个圆形区域，用来确认距离
    var mylng;          //用户位置全局lng
    var mylat;          //用户位置全局lat
    var id = '12';      //用户id
    idint = parseInt(id);//将用户id转换成int类型，便于传入后台
    var pointI;
    var e;
    var mk;

    //地图定位
    var geolocation = new BMap.Geolocation();
    x();
    function x() {
        setInterval(function () {
            geolocation.getCurrentPosition(function (r) {
                if (this.getStatus() == BMAP_STATUS_SUCCESS) {
                    pointI = r.point;
                    mk = new BMap.Marker(r.point);
                    mk.setAnimation(BMAP_ANIMATION_BOUNCE);
                    mylng = r.point.lng;
                    mylat = r.point.lat;
                    map.addOverlay(mk);
                    map.panTo(r.point);
                    e = confirm('您的位置：' + r.point.lng + ',' + r.point.lat);
                } else {
                    alert('failed' + this.getStatus());
                }
            }, {enableHighAccuracy: true, maximumAge: 0})
        },10*1000)
    }

    function ControlsCreate(e,pointI) {
        circle = new BMap.Circle(pointI, 10000, {
            fillColor: "blue",
            strokeWeight: 1,
            fillOpacity: 0.3,
            strokeOpacity: 0.3
        });
        map.addOverlay(circle);
        if (e == true) {
            // 创建所有控件begin
            var myZoomCtrl = new ZoomControl();
            map.addControl(myZoomCtrl);
            var myZoomCtrl2 = new ZoomControl2();
            map.addControl(myZoomCtrl2);
            var myZoomCtrl3 = new ZoomControl3();
            map.addControl(myZoomCtrl3);
            //创建控件end
        } else {
            console.log("bad behaviour!")
        }
    }

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
                'id': idint
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
                url: '${ctx}/map/search?id=' + idint,
                type: 'get',
                success: function (data) {
                    points.splice(0, points.length);
                    for (var i = 0; i < data.length; i++) {
                        var point = new BMap.Point(data[i].lng, data[i].lat);
                        points.push(point);
                        var marker = new BMap.Marker(point);// 创建标注
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
            for (var i = 0; i < points.length; i++) {
                var number = 0;
                var point = points[i];
                if (BMapLib.GeoUtils.isPointInCircle(point, circle)) {
                    var obj = {
                        'lng': point.lng,
                        'lat': point.lat,
                        'id': idint
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

</script>

