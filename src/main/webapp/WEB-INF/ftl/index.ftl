<#-- 取得 应用的绝对根路径 -->
<#assign basePath=request.contextPath>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>BarrageClient</title>
    <link rel="stylesheet" href="http://cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css">
</head>

<body>

<div class="container" style="padding-top:20px;">
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">聊天室</h3>
        </div>
        <div class="panel-body" id="content"></div>
    </div>
    <hr/>
    <input type="text" class="form-control" placeholder="msg" aria-describedby="sizing-addon1" id="msg">
    <hr/>

    <hr/>
    <button type="button" class="btn btn-lg btn-success btn-block" onclick="emit()">发送</button>
</div>

<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript" src="http://cdn.bootcss.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script type="text/javascript" >
    var socket = new WebSocket("ws://localhost:8080/talkServer");

    $(function() {
        listen();
    })

    function encodeScript(data) {
        if(null == data || "" == data) {
            return "";
        }
        return data.replace("<", "&lt;").replace(">", "&gt;");
    }

    function emit() {
        var text = encodeScript($("#msg").val());
        var text2 = $("#msg").val();
        var msg = {
            "message" : text,
            "color" : "#CECECE",
            "bubbleColor" : "#2E2E2E",
            "fontSize" : "12",
            "fontType" : "黑体"
        };
        msg = JSON.stringify(msg);
        alert(text2)
        socket.send(text2.toString());

        $("#content").append("<kbd style='color: #" + "CECECE" + ";float: right; font-size: " + 12 + ";'>" + text +  "</kbd><br/>");
        $("#msg").val("");
    }

    function listen() {
        socket.onopen = function() {
            $("#content").append("<kbd>Welcome!</kbd></br>")
        };
        socket.onmessage = function(evt) {
//            var data = JSON.parse(evt.data);
//            $("#content").append("<kbd style='color: #" + data.color + ";font-size: " + data.fontSize + ";margin-top: 10px;'>" + data.userName + " Say: " + data.message + "</kbd></br>");
            $("#content").append(evt.data);
        };
        socket.onclose = function(evt) {
            $("#content").append("<kbd>" + "Close!" + "</kbd></br>");
        }
        socket.onerror = function(evt) {
            $("#content").append("<kbd>" + "ERROR!" + "</kbd></br>");
        }
    }

    document.onkeydown = function(event){
        var e = event || window.event || arguments.callee.caller.arguments[0];
        if(e && e.keyCode == 13){ // enter 键
            emit();
        }
    };
</script>
</body>
</html>