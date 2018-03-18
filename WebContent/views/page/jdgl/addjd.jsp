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

</head>
<body style="overflow-x:hidden;overflow-y:auto;">

<form id="singleForm" method="post" action="<%=request.getContextPath() %>/tJdJdxxController/savetJdJdxx"  enctype="multipart/form-data" accept-charset="utf-8" >
    <input id="id_" name="id" type="hidden" value=""/>

    <div class="add_content">
    <div id="dialog">
        <h2 class="title">新增接待信息</h2>
        <div class="row">
            <p style="text-align:center;">（小提示：<span style="color:red;">*</span>为必填项）</p>
        </div>
        <table>
            <tr>
                <td class="bt" style="min-width:110px;width:10%">发起单位<i style="color:red;font-style:normal;">*</i></td>
                <td style="min-width:200px;width:40%">
                    <input id="fid" name="fid" type="hidden" value="${xtRyEntity.xtDwEntity.id}" />
                    <input id="fName" name="fName" readonly="readonly" type="text" value="${xtRyEntity.xtDwEntity.jgMc}"  style="width:65%"  /><button class="fqdwBtn" onclick="openDwinfoWin()">发起单位</button>
                </td>
                <td class="bt" style="min-width:110px;width:10%">发起人<i style="color:red;font-style:normal;">*</i></td>
                <td style="min-width:200px;width:40%">
                    <input id="fqrId" name="fqrId" type="hidden" value="${xtRyEntity.id}" />
                    <input id="fqrName" name="fqrName" readonly="readonly" type="text"  value="${xtRyEntity.xm}" style="width:65%"  /><button class="fqdwBtn" onclick="openUserinfoWin()">发起人</button>
                </td>
            </tr>
            <tr>
                <td class="bt" style="min-width:110px;width:10%">开始时间<i style="color:red;font-style:normal;">*</i></td>
                <td style="min-width:200px;width:40%">
                    <input id="d5221" name="ksSj"  class="validate[required,custom[date]] Wdate" type="text" onFocus="var d5222=$dp.$('d5222');WdatePicker({onpicked:function(){d5222.focus();},maxDate:'#F{$dp.$D(\'d5222\')}',lang:'zh-cn'})"/>
                </td>
                <td class="bt" style="min-width:110px;width:10%">结束时间<i style="color:red;font-style:normal;">*</i></td>
                <td style="min-width:200px;width:40%">
                    <input id="d5222" name="jsSj" class="validate[required,custom[date]] Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'d5221\')}',lang:'zh-cn'})"/>
                </td>
            </tr>
            <tr>
                <td class="bt">标题</td>
                <td colspan="3">
                    <input type="text" style="width:670px;" name="bt" class="validate[required,length[0,200]]">
                </td>
            </tr>
            <tr>
                <td class="bt">带队领导<i style="color:red;font-style:normal;">*</i></td>
                <td>
                    <input type="text" name="ddld" class="validate[required,length[0,200]]">
                </td>
                <td class="bt">接待类型<i style="color:red;font-style:normal;">*</i></td>
                <td>
                    <select name="jdlx" id="jdlx" class="validate[required]" >
                        <option value="特殊接待">特殊接待</option>
                        <option value="一般接待">一般接待</option>
                        <option value="招商接待">商务接待</option>
                        <option value="参观接待">参观接待</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="bt">单位联系人<i style="color:red;font-style:normal;">*</i></td>
                <td>
                    <input type="text" name="dwlxr" class="validate[required,length[0,200]]" >
                </td>
                <td class="bt">联系手机号<i style="color:red;font-style:normal;">*</i></td>
                
                <td>
                	<input type="text" name="lxsjh"  class="validate[required,custom[mobilephone]]" >
                	<!-- 如果存在短号情况，就使用下方验证 -->
                	<!-- <input type="text" name="lxsjh"  class="validate[required,custom[onlyNumber]]" > -->
               	</td>
            </tr>
            <tr>
                <td class="bt">参观调研点<i style="color:red;font-style:normal;">*</i></td>
                <td><input type="text" name="cgdyd" class="validate[required,length[0,200]]"></td>
                <td class="bt">人数<i style="color:red;font-style:normal;">*</i></td>
                <td><input type="text" name="rs" class="validate[required,custom[onlyNumber]]"></td>
            </tr>
            <tr>
                <td class="bt">密级<i style="color:red;font-style:normal;">*</i></td>
                <td colspan="3">
                    <select name="mj" id="" style="padding:4px;border:1px solid #ccc;" class="validate[required]" >
                        <option value="1">一级</option>
                        <option value="2">二级</option>
                        <option value="3">三级</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td class="bt">建议方案附件<i style="color:red;font-style:normal;">*</i></td>
                <td><input style="width:76%" type="file" name="jyfafj"  class="validate[required]"  > </td>
                <td class="bt">分管领导签批件<i style="color:red;font-style:normal;">*</i></td>
                <td><input style="width:76%" type="file" name="fgldqpj" class="validate[required]"  > </td>
            </tr>
            <tr>
                <td class="bt">备注</td>
                <td colspan="3">
                    <textarea style="width:670px;height:100px;" name="bz"></textarea>
                </td>
            </tr>

        </table>
        <div class="row button_group"><button class="button" id="jdFromSubmit">保存</button><button class="button" id="toQueryList"">关闭</button></div>
    </div>
</div>
</form>
</body>
<script type="application/javascript">
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
            content: contextPath+"/tXtRyController/userOpenPlugin",
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
                    $("#fqrId").val(resJOSN['id']);
                    $("#fqrName").val(resJOSN['name']);
                    top.layer.close(index)
                }

            },no: function(index, layero){
                top.layer.close(index)
            }
        });
    }
   function openDwinfoWin(){
       var laySum = top.layer.open({
           type: 2,
           title: "单位选择",
           shadeClose: false,
           shade: 0.8,
           btn: ['确定','关闭'],
           maxmin : true,
           area: ['550px', '450px'],
           content: contextPath+"/jdGlController/dwOpenPlugin",
           /*弹出框*/
           cancel: function(index, layero){
               top.layer.close(index);
           },yes: function(index, layero){
               var childIframeid = layero.find('iframe')[0]['name'];
               var chidlwin = top.document.getElementById(childIframeid).contentWindow;
               var resJOSN = chidlwin.getCheckedNode();
               if(resJOSN == null){
                   top.layer.msg('至少选择一个单位', {
                       icon: 1,
                       time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                   });
               }else{
                   $("#fid").val(resJOSN['id']);
                   $("#fName").val(resJOSN['name']);
                   top.layer.close(index)
               }

           },no: function(index, layero){
               top.layer.close(index)
           }
       });
   }
    /*提交相关的数据到后台然后保存*/
    $(function () {
    	/** 直接跳转到接待待分配查询界面 **/
    	$("#toQueryList").click(function(){
    		top.document.getElementById("rightFrame").src = contextPath+"/jdGlController/menuLink/dfp_list/2";
        	top.document.getElementById("JDRW_CLOSE_ACT_LI_ID").className = "active";
        	top.document.getElementById("JDRW_CLOSE_NO_LI_ID").className = "";
        	var parentNode = top.document.getElementById("JDRW_CLOSE_ACT_LI_ID").parentNode;
        	parentNode.style.display="block";
        	parentNode.previousSibling.previousSibling.className = "active";
    	})
        $("#jdFromSubmit").click(function () {
            var access=true;
            access=$('#singleForm').validationEngine({returnIsValid:true});
            if(access==true){
                /* 【是否选择了附件信息】：验证 */
                if($('input[name="fgldqpj"]').val()==null || $('input[name="fgldqpj"]').val()==''){

                    top.layer.msg("必须上传[分管领导签批件]", {
                        icon: 1,
                        time: 3000 //3秒关闭（如果不配置，默认是3秒）
                    });
                    return false;
                }
                if($('input[name="jyfafj"]').val()==null || $('input[name="jyfafj"]').val()==''){
                    top.layer.msg("必须上传[建议方案附件]", {
                        icon: 1,
                        time: 3000 //3秒关闭（如果不配置，默认是3秒）
                    });

                    return false;
                }
                $("#singleForm").ajaxSubmit({
                    type: 'post',
                    url: contextPath+"/tJdJdxxController/savetJdJdxx" ,
                    success: function(data){
                        if(data.success){
                            /* top.layer.msg(data.msg, {
                                icon: 1,
                                time: 3000 //3秒关闭（如果不配置，默认是3秒）
                            }); */
                            if(!data.isExists){
                                var id = data['id'];
                                $("#id_").val(id);
                                alert(data.msg)
                                /* 跳转到查询界面 */
                            	top.document.getElementById("rightFrame").src = contextPath+"/jdGlController/menuLink/dfp_list/2";
                            	top.document.getElementById("JDRW_CLOSE_ACT_LI_ID").className = "active";
                            	top.document.getElementById("JDRW_CLOSE_NO_LI_ID").className = "";
                            	var parentNode = top.document.getElementById("JDRW_CLOSE_ACT_LI_ID").parentNode;
                            	parentNode.style.display="block";
                            	parentNode.previousSibling.previousSibling.className = "active"; 
                            }
                        }else{
                        	top.layer.msg("保存失败!", {
                                icon: 1,
                                time: 3000 //3秒关闭（如果不配置，默认是3秒）
                            });
                        }
                    },
                    error: function(XmlHttpRequest, textStatus, errorThrown){
                        top.layer.msg("后台报错，请联系管理员", {
                            icon: 1,
                            time: 3000 //3秒关闭（如果不配置，默认是3秒）
                        });
                    }
                });
            }else{
                top.layer.msg("表单验证不通过，请核查!", {
                    icon: 1,
                    time: 3000 //3秒关闭（如果不配置，默认是3秒）
                });
                return false;
            }
        });
    });
</script>
</html>