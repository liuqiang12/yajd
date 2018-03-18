<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html> <!-- Do not add ng-app here as we bootstrap AngularJS manually-->
<head>
    <title>管理系统</title>
    <meta charset="utf-8" />
    <jsp:include page="/views/home/Head.jsp"></jsp:include>

</head>
    <meta charset="utf-8" />
    <title></title>
    <script type="text/ecmascript">
        $(document).ready(function () {
            setBodyHeight();
            setCurrentHeaderMenu();
            setBgHover();
            addHeaderMenuClick();
            //setBodyContentH();
        });

        $(window).resize(function () {
            setBodyHeight();
            //setBodyContentH();
        });

        function setBodyContentH(){
            var h=$('#body_content').height()-40;
            $('#rightFrame').css({height:h});
        }
        $(function(){
        	/****** 配置所有的 ul.menucls li点击按钮事件 *******/
        	$("ul.menucls li").click(function(){
        		var adom = $(this).find("a").attr("href");
        		if(adom != 'javascript:;' && adom != 'void(0)'){
        			$("#rightFrame").attr("src",adom);
        		}
        	})
        })
    </script>
</head>
<body style="overflow:hidden;">
    <jsp:include page="/views/home/Jdgl-Head.jsp"></jsp:include>
    <div id="body">
        <div id="body_left">
            <div class="menu">
                <p class="nav_title">栏目导航</p>
                <ul class="add_jd menucls">
                    <li class="xx">
                        <!-- 后台跳转 -->
                        <a class="active" href="<%=request.getContextPath() %>/jdGlController/createJdglModel" target="rightFrame" id="JDRW_CLOSE_NO_LI_ID">
                            <i></i>新增接待
                        </a>
                    </li>
                </ul>
                <ul class="task">
                    <li><a href="javascript:;" target="rightFrame"><i></i>接待任务管理</a>
                        <ul class="menucls">
                            <li class="active" id="JDRW_CLOSE_ACT_LI_ID"><a href="<%=request.getContextPath() %>/jdGlController/menuLink/dfp_list/2" target="rightFrame">待分配</a></li>
                            <li><a href="<%=request.getContextPath() %>/jdGlController/menuLink/dzdfa_list/3" target="rightFrame">待制定方案</a></li>
                            <li><a href="<%=request.getContextPath() %>/jdGlController/menuLink/dcs_list/4" target="rightFrame">待初审</a></li>
                            <li><a href="<%=request.getContextPath() %>/jdGlController/menuLink/dfs_list/5"  target="rightFrame">待复审</a></li>
                            <li><a href="<%=request.getContextPath() %>/jdGlController/menuLink/ywc_list/6" target="rightFrame" style="border:none;">已完成</a></li>
                        </ul>
                    </li>
                </ul>
                <ul class="share">
                    <li><a href="javascript:;" target="rightFrame"><i></i>资料共享</a>
                        <ul class="menucls">
                            <li><a href="javascript:;" target="rightFrame">流程说明</a></li>
                            <li><a href="javascript:;" target="rightFrame">接待实施细则</a></li>
                            <li><a href="javascript:;" target="rightFrame">接待方案模板</a></li>
                            <li><a href="javascript:;" target="rightFrame" style="border:none;">参观点介绍</a></li>
                        </ul>
                    </li>

                </ul>
                <ul class="import menucls">
                    <li><a href="void(0)" target="rightFrame"><i></i>接待大事记</a></li>
                </ul>
                <ul class="log menucls">
                    <li><a href="<%=request.getContextPath() %>/jdGlController/menuLink/log/12"  target="rightFrame"><i></i>系统日志</a></li>
                </ul>
                <ul class="system">
                    <li><a href="javascript:;" target="rightFrame"><i></i>系统管理</a>
                        <ul class="menucls">
                            <li><a href="<%=request.getContextPath() %>/jdGlController/menuLink/system/12"  target="rightFrame">功能配置</a></li>
                            <li><a href="<%=request.getContextPath() %>/jdGlController/menuLink/power/13"  target="rightFrame">权限管理</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
        <div id="body_content">
            <jsp:include page="/views/home/Jdgl-Search.jsp"></jsp:include>
            <iframe id="rightFrame" title="rightFrame" name="rightFrame" src="<%=request.getContextPath() %>/jdGlController/menuLink/dfp_list/2" frameborder="0"></iframe>
        </div>
    </div>
    <jsp:include page="/views/home/Jdgl-Footer.jsp"></jsp:include>
    <script>
        $(function(){
            $('.menu>ul>li ul li').click(function(){
                $(this).addClass('active').siblings().removeClass('active');
                $(this).parent().siblings().find('dd').removeClass('active');
            });
            $('.menu>ul>li>a').click(function(){
                $(this).addClass('active');
                $(this).parent().parent().siblings().find('a:first').removeClass('active');
                $(this).siblings().show();
                $(this).parent().parent().siblings().find('ul').hide();
                $('li').removeClass('active');
            });

            setSize();
            $(window).resize(function(){
                setSize();
            })
        });
        function setSize(){
            $('#rightFrame').css({
                height:$('#body_content').height()-40,
                width:$('#body_content').width()
            })
        }
    </script>
</body>
</html>
