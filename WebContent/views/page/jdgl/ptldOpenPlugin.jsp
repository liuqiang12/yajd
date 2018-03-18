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
        function form_sbmt_(){
            var resJSON = {};
            var access=true;
            access=$('#singleForm').validationEngine({returnIsValid:true});
            if(access==true){
                $("#singleForm").ajaxSubmit({
                    type: 'post',
                    async: false,
                    url: contextPath+"/tJdJdxxController/insertPtld" ,
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
        function openUserinfoWin(){
            /**
             * 发起人
             */
            var laySum = top.layer.open({
                type: 2,
                title: "人员选择",
                shadeClose: false,
                shade: 0.8,
                btn: ['确定','关闭'],
                maxmin : true,
                area: ['880px', '550px'],
                content: contextPath+"/tXtRyController/userSelectOpenPlugin_Query",
                /*弹出框*/
                cancel: function(index, layero){
                    top.layer.close(index);
                },yes: function(index, layero){
                    var childIframeid = layero.find('iframe')[0]['name'];
                    var chidlwin = top.document.getElementById(childIframeid).contentWindow;
                    var resJOSN = chidlwin.getSelectedGridRecord();
                    if(resJOSN == null){
                        top.layer.msg('必须选择发起人名称', {
                            icon: 1,
                            time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                        });
                    }else{
                        $("#ptldId").val(resJOSN['id']);
                        $("#ptldMc").val(resJOSN['name']);
                        top.layer.close(index)
                    }

                },no: function(index, layero){
                    top.layer.close(index)
                }
            });
        }
    </script>
</head>
<body style="overflow-x:hidden;overflow-y:auto;">
    <form id="singleForm" method="post" action="<%=request.getContextPath() %>/tJdJdxxController/insertPtld" accept-charset="utf-8" >
        <input type="hidden" name="id" value="${id}">
        <div id="fpryDialog" class="dialog_1">
            <div class="content">
                <table>
                    <tr>
                        <th colspan="2">请填写陪同领导</th>
                    </tr>
                    <tr>
                        <td>
                        <!-- 陪同领导ptldMc: -->
                        <input id="ptldId" name="ptldId" type="hidden" readonly="readonly" value="${jdxxEntity.ptldId}">
                        <input id="ptldMc" name="ptldMc" type="text" readonly="readonly" style="width: 150px" class="validate[required,length[0,50]]" value="${jdxxEntity.ptldMc}">
                        <a href="#" class="easyui-linkbutton" plain="true" icon="icon-add" onclick="openUserinfoWin()">选择</a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>