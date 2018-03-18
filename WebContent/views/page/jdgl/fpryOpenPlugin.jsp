<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html> <!-- Do not add ng-app here as we bootstrap AngularJS manually-->
<head>
    <title>接待管理系统</title>
    <meta charset="utf-8" />
    <jsp:include page="/views/home/Head.jsp"></jsp:include><!-- 日期控件 -->
    <script type="text/javascript" src="<%=request.getContextPath() %>/lib/My97Date/WdatePicker.js"></script>
    <style type="text/css">
        .dialog_1{
            width: auto !important;
            height: auto !important;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            /* 分配人员ID:jdxxEntity */
            var cbrId = "${jdxxEntity.cbrId}";
            var fpcbrSj = "${jdxxEntity.fpcbrSj}";
            if(cbrId){
                $("input:radio[attr='"+cbrId+"']").attr("checked",true)
            }
            //分配人员时间
            $("#d5221").val(fpcbrSj);
        })
        function form_sbmt_(){
            var resJSON = {};
            var access=true;
            access=$('#singleForm').validationEngine({returnIsValid:true});
            if(access==true){
                $("#singleForm").ajaxSubmit({
                    type: 'post',
                    async: false,
                    url: contextPath+"/tJdJdxxController/insertFpxx" ,
                    success: function(data){
                        resJSON['data'] = data;
                        if(data.success){
                            /* 其中保存完成后直接关闭窗口 */
                            top.layer.msg('成功', {
                                icon: 1,
                                time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                            });
                        }
                    },
                    error: function(XmlHttpRequest, textStatus, errorThrown){
                        alert( "error");
                    }
                });
            }
            resJSON['validation'] = access;
            return resJSON;
        }
        function changeBackColor(obj) {
			$(obj).siblings("span").removeClass("activeCls_001");
			$(obj).addClass("activeCls_001");
		}
    </script>
    <style type="text/css">
    	.activeCls_001{
    		border:1px #eee solid;
    		background-color: #ddd;
    	}
    	.borderCls_001{
    		border: 1px solid #aaa;
    	}
    </style>
</head>
<body style="overflow-x:hidden;overflow-y:auto;">
    <form id="singleForm" method="post" action="<%=request.getContextPath() %>/tJdJdxxController/insertFpxx" accept-charset="utf-8" >
        <input type="hidden" name="id" value="${id}">
        <div id="fpryDialog" class="dialog_1">
            <div class="content">
                <table>
                    <tr>
                        <th colspan="2">请选择分配人员</th>
                    </tr>
                    <tr>
                        <td class="bt">时间</td>
                        <td>
                            <input id="d5221" name="fpcbrSj" class="validate[required,custom[date]] Wdate" type="text" onFocus="WdatePicker({lang:'zh-cn'})"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="bt">人员列表</td>
                        <td>
                             <div style="text-align: left;">
                            <c:forEach items="${ryEntities}" var="item" varStatus="status">
                                 <span class="borderCls_001" onclick="changeBackColor(this)"><label for="radio-${status.index+1 }">${item.xm}</label><input type="radio" class="validate[required] radio" id="radio-${status.index+1 }" name="cbrId" attr="${item.id}" value="${item.id}" /></span>
                            </c:forEach>
                             </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>