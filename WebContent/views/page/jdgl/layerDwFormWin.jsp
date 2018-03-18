<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html> <!-- Do not add ng-app here as we bootstrap AngularJS manually-->
<head>
    <title>接待管理系统</title>
    <meta charset="utf-8" />
    <jsp:include page="/views/home/Head.jsp"></jsp:include>
    <!-- 日期控件 -->
    <script type="text/javascript" src="<%=request.getContextPath() %>/lib/My97Date/WdatePicker.js"></script>
    <!-- 主要是针对于布局easyui -->
    <script type="text/javascript" src="<%=request.getContextPath() %>/lib/jquery-easyui-1.5/jquery.easyui.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/lib/jquery-easyui-1.5/themes/default/easyui.css" type="text/css">
    <link rel="stylesheet" href="<%=request.getContextPath() %>/lib/jquery-easyui-1.5/themes/icon.css" type="text/css">
    <script type="text/javascript">
        function openParentWin(){
            /* 选择树形结构 */
            var laySum = top.layer.open({
                type: 2,
                title: "单位新增",
                shadeClose: false,
                shade: 0.8,
                btn: ['确定','关闭'],
                maxmin : true,
                area: ['750px', '350px'],
                content: contextPath+"/tXtDwController/layerDwTreeWin",
                /*弹出框*/
                cancel: function(index, layero){
                    top.layer.close(index);
                },yes: function(index, layero){
                    var childIframeid = layero.find('iframe')[0]['name'];
                    var chidlwin = top.document.getElementById(childIframeid).contentWindow;
                    var resJOSN = chidlwin.getCheckedNode();
                    if(resJOSN == null){
                        top.layer.msg('没有选择父级单位，则默认作为一级单位!', {
                            icon: 1,
                            time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                        });
                    }else{
                        $("#parentId").val(resJOSN['id']);
                        $("#parentName").val(resJOSN['name']);
                    }
                    top.layer.close(index)
                },no: function(index, layero){
                    top.layer.close(index)
                }
            });
        }
        function form_sbmt(){
            var resJSON = {};
            var access=true;
            access=$('#singleForm').validationEngine({returnIsValid:true});
            if(access==true){
                $("#singleForm").ajaxSubmit({
                    type: 'post',
                    async: false,
                    url: contextPath+"/tXtDwController/savetXtDw" ,
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
    </script>
</head>
<body style="overflow-x:hidden;overflow-y:auto;">

<form id="singleForm" method="post" action="<%=request.getContextPath() %>/tXtDwController/savetXtDw" accept-charset="utf-8" >
    <div class="add_content">
        <div id="dialog">
            <h2 class="title">单位基本信息</h2>
            <div class="row">
                <p style="text-align:center;">（小提示：<span style="color:red;">*</span>为必填项）</p>
            </div>
            <table>
                <tr>
                    <td class="bt">单位名称<i style="color:red;font-style:normal;">*</i></td>
                    <td  >
                        <input type="text" style="width: 150px"  name="jgMc" class="validate[required,length[0,150]]">
                    </td>

                    <td class="bt">上级单位</td>
                    <td>
                        <input id="parentId" name="parentId" type="hidden"   />
                        <input id="parentName"  style="width: 150px"  readonly="readonly" type="text"   /><a href="#" class="easyui-linkbutton" plain="true" icon="icon-add" onclick="openParentWin()">新增</a>
                    </td>
                </tr>
                <tr>
                    <td class="bt">单位联系人<i style="color:red;font-style:normal;">*</i></td>
                    <td>
                        <input type="text" style="width: 150px"  name="dwlxr" class="validate[required,length[0,200]]" >
                    </td>
                    <td class="bt">联系手机号<i style="color:red;font-style:normal;">*</i></td>
                    <td><input type="text" style="width: 150px"  name="jgLxrHm"  class="validate[required,custom[onlyNumber]]" ></td>
                </tr>

            </table>
        </div>
    </div>
</form>
</body>
</html>