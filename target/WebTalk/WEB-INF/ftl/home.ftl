<#-- 取得 应用的绝对根路径 -->
<#assign basePath=request.contextPath>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link href="${basePath}/css/bootstrap.min.css" rel="stylesheet">
    <title>喽比聊天界面</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            font-size: 12px;
            font-family:'Microsoft YaHei';
        }

        #home{
            background: #1ABC9C;
            height: 100%;
            padding-top: 20px;
        }

        #left{
            background: #3498DB;
            height: 100%;
            padding-top: 10px;
        }

        #right{
            background: #9B59B6;
            height: 100%;
            padding-top: 10px;
        }

        #right button{
            margin-top: 20px;
        }


        #friends li{
            margin-top: 10px;
        }

        #text{
            height: 65%;
        }
    </style>
        </head>
<body>

    <#-- 左 -->
    <div id="left"  class="col-md-3">
        <ul id="friends" class="list-group ">

            <li class="list-group-item" >所有加入聊天室的人</li>

            <#--<li class="list-group-item" >路人甲
                <a onclick="getUsers()" class="btn btn-info btn-xs pull-right">联系</a>
            </li>-->
        </ul>
    </div>

    <#-- 中 -->
    <div id="home"  class="col-md-6">
        <div id="text" class="panel panel-primary">
            <div id="div_title" class="panel-heading">
                <h3 class="panel-title">与所有人聊天窗口</h3>
            </div>
            <div class="panel-body" id="content">
            </div>
        </div>

        <textarea id="message" class="form-control" rows="4" placeholder="请输入发送内容"></textarea>

        <button class="btn btn-primary pull-right" style="margin-top: 10px" onclick="submit()" >发送</button>

    </div>



    <#-- 右 -->
    <div id="right" class="col-md-3">
        <button id="check" type="button" class="btn btn-lg btn-block">检查连接</button>
        <button id="sopen" type="button" class="btn btn-info btn-lg btn-block">打开连接</button>
        <button id="sclose" type="button" class="btn btn-success btn-lg btn-block">关闭连接</button>

        <button id="rebot" type="button" class="btn btn-warning btn-lg btn-block">打开机器人</button>
        <button id="clearmessage" type="button" class="btn btn-danger btn-lg btn-block">清屏</button>
        <button id="getout" type="button" class="btn btn-primary btn-lg btn-block">退出登录</button>

    </div>
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.js"></script>
    <#--<script type="text/javascript" src="http://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>-->
    <script src="${basePath}/layer/layer.js"></script>

<script type="text/javascript">

    var to = "all";
    var line = 0;
    var wsServer = null;
    var  ws = null;
    var isRebot = false;
    function getPerson(data,name) {
        to = data;
        if(data == "all"){
            $("#div_title H3").empty().append("与所有人聊天窗口");
        }else {
            $("#div_title H3").empty().append("与" + name + "聊天窗口");
        }
    }

    $(function() {
        $("#content").empty();
        wsServer = "ws://" + location.host+"${basePath}" + "/talkServer";
        ws = new WebSocket(wsServer); //创建WebSocket对象
        ws.onopen = function (evt) {
            layer.msg("成功建立连接!", { offset: 0});
        };
        ws.onmessage = function (evt) {
            analysisMessage(evt.data);  //解析后台传回的消息,并予以展示
        };
        ws.onerror = function (evt) {
            layer.msg("产生异常", { offset: 0});
            line++;
            if(line == 20){
                $("#content").empty();
                line = 1;
            }
            $("#content").append(  "ERROR!" + "</br>");
            ws.close(); //关闭TCP连接
            ws = null;
        };
        ws.onclose = function (evt) {
            layer.msg("已经关闭连接", { offset: 0});
            line++;
            if(line == 20){
                $("#content").empty();
                line = 1;
            }
            $("#content").append(  "Close!" + "</br>");
            ws.close(); //关闭TCP连接
            ws = null;
        };
    });

    function submit() {
        var text = $("#message").val().toString();
        if(text == null || text == ""){
            layer.msg("不能发送空白!", { offset: 0, shift: 6 });
            return;
        }

        var msg = to+"-"+text;

        if(ws != null){
            ws.send(msg);
            line++;
            if(line == 20){
                $("#content").empty();
                line = 1;
            }
            $("#content").append( "<a style='float:right'  >"+text + "</a><br/>");
            if(isRebot){
                tuling(text);
            }
            $("#message").val("");
        }else {
            line++;
            if(line == 20){
                $("#content").empty();
                line = 1;
            }
            $("#content").append( "<a style='float:left'  >没有连接</a><br/>");
        }

    }


    function analysisMessage(data) {
        if(data == "getUsers"){
            getUsers();
        }else {
            line++;
            if(line == 20){
                $("#content").empty();
                line = 1;
            }
            $("#content").append( "<a style='float:left'  >"+data + "</a><br/>");
        }
    }

    document.onkeydown = function(event){
        var e = event || window.event || arguments.callee.caller.arguments[0];
        if(e && e.keyCode == 13){ // enter 键
            submit();
        }
    };

    function getUsers() {
        $.post("${basePath}/talk/getUsers.json",{},function(result){
            $("#friends").empty().append("<li class=\"list-group-item\" >在线列表[共"+result.length+"人]</li>");
            $("#friends li:last-child").append("<a onclick=\"getPerson('all')\" class=\"btn btn-info btn-xs pull-right\">所有人</a>");
            for (var i=0;i<result.length;i++){
                $("#friends").append(" <li class=\"list-group-item\" >"+result[i].name+"</li>");
                $("#friends li:last-child").append("<a onclick=\"getPerson('"+result[i].id+"','"+result[i].name+"')\" class=\"btn btn-info btn-xs pull-right\">联系</a>");
            }
        });
    }

    $("#sopen").click(function () {
        if(ws == null){
            ws = new WebSocket(wsServer); //创建WebSocket对象
            ws.onopen = function (evt) {
                layer.msg("成功建立连接!", { offset: 0});
            };
            ws.onmessage = function (evt) {
                analysisMessage(evt.data);  //解析后台传回的消息,并予以展示
            };
            ws.onerror = function (evt) {
                layer.msg("产生异常", { offset: 0});
                line++;
                if(line == 20){
                    $("#content").empty();
                    line = 1;
                }
                $("#content").append(  "ERROR!" + "</br>");
                ws.close(); //关闭TCP连接
                ws = null;
            };
            ws.onclose = function (evt) {
                layer.msg("已经关闭连接", { offset: 0});
                line++;
                if(line == 20){
                    $("#content").empty();
                    line = 1;
                }
                $("#content").append(  "Close!" + "</br>");
                ws.close(); //关闭TCP连接
                ws = null;
            };
        }else{
            line++;
            if(line == 20){
                $("#content").empty();
                line = 1;
            }
            layer.msg("已有连接", { offset: 0, shift: 6 });
            $("#content").append( "<a style='float:left'  >已有连接</a><br/>");
            //提示
        }

    });

    $("#sclose").click(function () {
        if(ws != null){
            ws.close();
            ws = null;
            $("#friends").empty().append("<li class=\"list-group-item\" >在线列表</li>");
        }else{
            //提示
            line++;
            if(line == 20){
                $("#content").empty();
                line = 1;
            }
            layer.msg("没有连接", { offset: 0, shift: 6 });
            $("#content").append( "<a style='float:left'  >没有连接</a><br/>");
        }
    });

    $("#rebot").click(function () {
        if(isRebot){
            $("#rebot").empty().append("打开机器人");
            isRebot = false;
            line++;
            if(line == 20){
                $("#content").empty();
                line = 1;
            }
            layer.msg("机器人已退出聊天室", { offset: 0});
            $("#content").append( "<a style='float:left'  >机器人已退出聊天室</a><br/>");
        }else {
            $("#rebot").empty().append("关闭机器人");
            isRebot = true;
            line++;
            if(line == 20){
                $("#content").empty();
                line = 1;
            }
            layer.msg("机器人已进入聊天室", { offset: 0});
            $("#content").append( "<a style='float:left'  >机器人已进入聊天室</a><br/>");
        }
    });

    $("#clearmessage").click(function () {
        line = 0;
        $("#content").empty();
    });

    $("#check").click(function () {
        if(ws != null){
            layer.msg(ws.readyState == 0? "连接异常":"连接正常", { offset: 0});
        }else{
            layer.msg("连接未开启!", { offset: 0, shift: 6 });
        }
    });

    $("#getout").click(function () {
        $.post("${basePath}/user/doOut.json",{},function(data,status){
            if(data.success) {
                location.href = data.url;
            }
        });
    });

    /**
     * 图灵机器人
     * @param message
     */
    function tuling(message){
        var html;
        $.getJSON("http://www.tuling123.com/openapi/api?key=6ad8b4d96861f17d68270216c880d5e3&info=" + message,function(data){

            if(data.code == 100000){
                line++;
                if(line == 20){
                    $("#content").empty();
                    line = 1;
                }
                $("#content").append( "<a style='float:left'  >机器人:"+data.text+"</a><br/>");
            }
            if(data.code == 200000){
                line++;
                if(line == 20){
                    $("#content").empty();
                    line = 1;
                }
                $("#content").append( "<a style='float:left' href='"+data.url+"'  >机器人:"+data.text+"</a><br/>");
            }

        });
    }
</script>
</body>
</html>
