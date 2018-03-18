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
        $(function(){
            /*设置被选中的select*/
            $("#xb_form option[value='${ryEntity.xb.val}']").attr("selected",true);
            $("#fpryStatus option[value='${ryEntity.fpryStatus}']").attr("selected",true);
        })
    </script>
</head>
<body style="overflow-x:hidden;overflow-y:auto;">

<form id="singleForm" method="post" accept-charset="utf-8" >
    <div class="add_content">
        <div id="dialog">
            <h2 class="title">人员基本信息</h2>
            <div class="row">
                <p style="text-align:center;">（小提示：<span style="color:red;">*</span>为必填项）</p>
            </div>
            <table>
                <tr>
                    <td class="bt">单位名称<i style="color:red;font-style:normal;">*</i></td>
                    <td>
                       <input id="dwName" type="text" readonly="readonly" value="${ryEntity.xtDwEntity.jgMc}" style="width: 150px" class="validate[required,length[0,150]]">
                    </td>
                    <td class="bt">姓名</td>
                    <td>
                        <input type="text" readonly="readonly" value="${ryEntity.xm}" style="width: 150px"  name="xm" class="validate[required,length[0,100]]" >
                    </td>
                </tr>
                <tr>
                    <td class="bt">性别<i style="color:red;font-style:normal;">*</i></td>
                    <td>
                        <select id="xb_form" name="xb_form" style="padding:4px;border:1px solid #ccc;" class="validate[required]" >
                            <option value="1">男</option>
                            <option value="2">女</option>
                        </select>
                        <%--<input type="text" readonly="readonly" value="${ryEntity.xb}" style="width: 150px" class="validate[required,length[0,100]]" >--%>

                    </td>
                    <td class="bt">职务<i style="color:red;font-style:normal;">*</i></td>
                    <td><input type="text" readonly="readonly" value="${ryEntity.zw}" style="width: 150px" class="validate[required,length[0,100]]" ></td>
                </tr>
                <tr>
                    <td class="bt">联系方式<i style="color:red;font-style:normal;">*</i></td>
                    <td>
                        <input type="text" readonly="readonly" value="${ryEntity.lxfs}" style="width: 150px" class="validate[required,length[0,100]]" >
                    </td>
                    <td class="bt">备注<i style="color:red;font-style:normal;">*</i></td>
                    <td>
                        <input type="text" readonly="readonly" value="${ryEntity.bz}" style="width: 150px" class="validate[required,length[0,100]]" >
                    </td>
                </tr>
                <tr>
                    <td class="bt">人员类别<i style="color:red;font-style:normal;">*</i></td>
                    <td colspan="3">
                        <select id="fpryStatus" name="fpryStatus" style="padding:4px;border:1px solid #ccc;" class="validate[required]" >
                            <option value="">--</option>
                            <option value="0">系统人员</option>
                            <option value="1">分配人员</option>
                        </select>
                    </td>
                </tr>

            </table>
        </div>
    </div>
</form>
</body>
</html>