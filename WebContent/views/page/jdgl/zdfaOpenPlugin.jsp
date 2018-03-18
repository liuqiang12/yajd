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
            var zdfaSj = "${jdxxEntity.zdfaSj}";
            $("#d5221").val(zdfaSj);
        })
        function form_sbmt_(){
            var resJSON = {};
            var access=true;
            access=$('#singleForm').validationEngine({returnIsValid:true});
            if(access==true){
                if($('input[name="zdfafj"]').val()==null || $('input[name="zdfafj"]').val()==''){
                    top.layer.msg("必须上传[制定方案]", {
                        icon: 1,
                        time: 3000 //3秒关闭（如果不配置，默认是3秒）
                    });
                    return false;
                }

                $("#singleForm").ajaxSubmit({
                    type: 'post',
                    async: false,
                    url: contextPath+"/tJdJdxxController/insertZdfa" ,
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
                content: contextPath+"/tXtRyController/userSelectOpenPlugin",
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
    <form id="singleForm" method="post" action="<%=request.getContextPath() %>/tJdJdxxController/insertZdfa" accept-charset="utf-8" >
        <input type="hidden" name="id" value="${id}">
        <div id="fpryDialog" class="dialog_1">
            <div class="content">
                <table>
                    <tr>
                        <th colspan="2">请上传接待方案</th>
                    </tr>
                    <tr>
                        <td class="bt">时间</td>
                        <td>
                            <input id="d5221" name="zdfaSj" class="validate[required,custom[date]] Wdate" type="text" onFocus="WdatePicker({lang:'zh-cn'})"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="bt">上传方案</td>
                        <td>
                            <span onclick="downFile('T_JD_JDXX','${zdfafj_wjEntity.relationalValue}','zdfafj')" title="${zdfafj_fjEntity.mc}">${zdfafj_fjEntity.nickMc}</span><!-- a标签，目的是可以下载附件 -->
                            <input type="file" name="zdfafj" id="zdfafj"  class="validate[required] fj_inp"  ><!-- 制定方案附件 -->
                            <!-- 附件file --><%--
                            <button class="button btn_ll">添加附件</button>--%>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>