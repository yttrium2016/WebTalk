<#-- 取得 应用的绝对根路径 -->
<#assign basePath=request.contextPath>
<!DOCTYPE html>
<html lang="zh" class="no-js">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="http://www.jq22.com/demo/jQuery-tcc20160407/css/normalize.css" />
    <link rel="stylesheet" type="text/css" href="http://www.jq22.com/demo/jQuery-tcc20160407/css/demo.css" />
    <link rel="stylesheet" type="text/css" href="http://www.jq22.com/demo/jQuery-tcc20160407/css/component.css" />
    <link rel="stylesheet" type="text/css" href="http://www.jq22.com/demo/jQuery-tcc20160407/css/content.css" />
    <script src="http://www.jq22.com/demo/jQuery-tcc20160407/js/modernizr.custom.js"></script>
    <script src="${basePath}/js/jquery-3.1.1.min.js"></script>

</head>
<body>
<div class="container" style="height: 50%;">
<#--    <header class="codrops-header">
        <h1>Morphing Buttons Concept</h1>
        <p>Inspiration for revealing content by morphing the action element. Examples:</p>
        <nav class="codrops-demos">
            <a class="current-demo" href="index.html">Login/Signup</a>
            <a href="index2.html">Terms</a>
            <a href="index3.html">Info Overlay</a>
            <a href="index4.html">Subscribe</a>
            <a href="index5.html">Share</a>
            <a href="index6.html">Video Player</a>
            <a href="index7.html">Sidebar Settings</a>
        </nav>
    </header>-->
    <section style="height: 350px; margin-top: 130px;">
        <p>欢迎来到聊天室系统 </p>
        <div class="mockup-content">
            <div class="morph-button morph-button-modal morph-button-modal-2 morph-button-fixed">
                <button type="button">登录</button>
                <div class="morph-content">
                    <div>
                        <div class="content-style-form content-style-form-1">
                        	<span class="icon icon-close" >关闭窗口</span>
                            <h2>登录</h2>
                            <form id="login">
                                <p><label>登录名</label><input name="loginName" type="text" /></p>
                                <p><label>密码</label><input name="password" type="password" /></p>
                                <p><button onclick="login();">登录</button></p>
                            </form>
                        </div>
                    </div>
                </div>
            </div><!-- morph-button -->
            <strong class="joiner">or</strong>
            <div class="morph-button morph-button-modal morph-button-modal-3 morph-button-fixed">
                <button type="button">注册</button>
                <div class="morph-content">
                    <div>
                        <div class="content-style-form content-style-form-2">
                            <span class="icon icon-close">关闭窗口</span>
                            <h2>注册</h2>
                            <form id="sign">
                                <p><label>用户名</label><input name="loginName" type="text" /></p>
                                <p><label>密码</label><input name="password" type="password" /></p>
                                <p><label>确认密码</label><input name="repassword" type="password" /></p>
                                <p><button  onclick="sign()">注册</button></p>
                            </form>
                        </div>
                    </div>
                </div>
            </div><!-- morph-button -->
        </div><!-- /form-mockup -->
    </section>
</div><!-- /container -->
<script src="http://www.jq22.com/demo/jQuery-tcc20160407/js/classie.js"></script>
<script src="http://www.jq22.com/demo/jQuery-tcc20160407/js/uiMorphingButton_fixed.js"></script>
<script src="${basePath}/layer/layer.js"></script>
<script>

	function login() {
	    var res = $("#login").serialize();
        $.post("${basePath}/user/doLogin.json",res,function(data,status){

            if(data.success) {

                layer.msg(data.message,{ }, function(){
                    //do something
                    location.href = data.url;
                });
            }else {
                layer.msg(data.message, { offset: 0});
            }
        });
    }

    function sign() {
        var res = $("#sign").serialize();
        $.post("${basePath}/user/doSign.json",res,function(data,status){

            if(data.success) {
                layer.msg(data.message,{ offset: 0}, function(){
                    //do something
                    location.href = data.url;
                });
            }else {
                layer.msg(data.message, { offset: 0});
            }
        });
    }

    (function() {
        var docElem = window.document.documentElement, didScroll, scrollPosition;


        // trick to prevent scrolling when opening/closing button
        function noScrollFn() {
            window.scrollTo( scrollPosition ? scrollPosition.x : 0, scrollPosition ? scrollPosition.y : 0 );
        }

        function noScroll() {
            window.removeEventListener( 'scroll', scrollHandler );
            window.addEventListener( 'scroll', noScrollFn );
        }

        function scrollFn() {
            window.addEventListener( 'scroll', scrollHandler );
        }

        function canScroll() {
            window.removeEventListener( 'scroll', noScrollFn );
            scrollFn();
        }

        function scrollHandler() {
            if( !didScroll ) {
                didScroll = true;
                setTimeout( function() { scrollPage(); }, 60 );
            }
        };

        function scrollPage() {
            scrollPosition = { x : window.pageXOffset || docElem.scrollLeft, y : window.pageYOffset || docElem.scrollTop };
            didScroll = false;
        };

        scrollFn();

        [].slice.call( document.querySelectorAll( '.morph-button' ) ).forEach( function( bttn ) {
            new UIMorphingButton( bttn, {
                closeEl : '.icon-close',
                onBeforeOpen : function() {
                    // don't allow to scroll
                    noScroll();
                },
                onAfterOpen : function() {
                    // can scroll again
                    canScroll();
                },
                onBeforeClose : function() {
                    // don't allow to scroll
                    noScroll();
                },
                onAfterClose : function() {
                    // can scroll again
                    canScroll();
                }
            } );
        } );

        // for demo purposes only
        [].slice.call( document.querySelectorAll( 'form button' ) ).forEach( function( bttn ) {
            bttn.addEventListener( 'click', function( ev ) { ev.preventDefault(); } );
        } );
    })();
</script>
</body>
</html>