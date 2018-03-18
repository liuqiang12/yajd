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
    <input id="id_" name="id" type="hidden" value="${jdxxEntity.id}"/>
    <input id="jdxxBzText_" name="jdxxBzText" type="hidden" value="${jdxxEntity.jdxxBz}"/>
    <div class="add_content">
        <div id="dialog">
            <h2 class="title">编辑接待信息</h2>
            <div class="row">
                <p style="text-align:center;">（小提示：<span style="color:red;">*</span>为必填项）</p>
            </div>
            <table>
                <tr>
                    <td class="bt" style="min-width:110px;width:10%">发起单位<i style="color:red;font-style:normal;">*</i></td>
                    <td style="min-width:200px;width:40%">
                        <input id="fid" name="fid" type="hidden" value="${jdxxEntity.lrdwEntity.id}" />
                        <input id="fName" name="fName" readonly="readonly" type="text"  style="width:65%" value="${jdxxEntity.lrdwEntity.jgMc}" /><button class="fqdwBtn" onclick="openDwinfoWin()">发起单位</button>
                    </td>
                    <td class="bt" style="min-width:110px;width:10%">发起人<i style="color:red;font-style:normal;">*</i></td>
                    <td style="min-width:200px;width:40%">
                        <input id="fqrId" name="fqrId" type="hidden" value="${jdxxEntity.ryEntity.id}" />
                        <input id="fqrName" name="fqrName" readonly="readonly" type="text"  style="width:65%" value="${jdxxEntity.ryEntity.xm}" /><button class="fqdwBtn" onclick="openUserinfoWin()">发起人</button>
                    </td>
                </tr>
                <tr>
                    <td class="bt" style="min-width:110px;width:10%">开始时间<i style="color:red;font-style:normal;">*</i></td>
                    <td style="min-width:200px;width:40%">
                        <input id="d5221" name="ksSj" value="${jdxxEntity.ksSj}"  class="validate[required,custom[date]] Wdate" type="text" onFocus="var d5222=$dp.$('d5222');WdatePicker({onpicked:function(){d5222.focus();},maxDate:'#F{$dp.$D(\'d5222\')}',lang:'zh-cn'})"/>
                    </td>
                    <td class="bt" style="min-width:110px;width:10%">结束时间<i style="color:red;font-style:normal;">*</i></td>
                    <td style="min-width:200px;width:40%">
                        <input id="d5222" name="jsSj" value="${jdxxEntity.jsSj}" class="validate[required,custom[date]] Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'d5221\')}',lang:'zh-cn'})"/>
                    </td>
                </tr>
                <tr>
                    <td class="bt">标题</td>
                    <td colspan="3">
                        <input type="text" style="width:670px;"  value="${jdxxEntity.bt}" name="bt" class="validate[required,length[0,200]]">
                    </td>
                </tr>
                <tr>
                    <td class="bt">带队领导<i style="color:red;font-style:normal;">*</i></td>
                    <td>
                        <input type="text" name="ddld" value="${jdxxEntity.ddld}" class="validate[required,length[0,200]]">
                    </td>
                    <td class="bt">接待类型<i style="color:red;font-style:normal;">*</i></td>
                    <td>
                        <select name="jdlx" id="jdlx" class="validate[required]" value="${jdxxEntity.jdlx}" >
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
                        <input type="text" name="dwlxr" class="validate[required,length[0,200]]" value="${jdxxEntity.dwlxr}" >
                    </td>
                    <td class="bt">联系手机号<i style="color:red;font-style:normal;">*</i></td>
                    <td><input type="text" name="lxsjh"  class="validate[required,custom[onlyNumber]]" value="${jdxxEntity.lxsjh}" ></td>
                </tr>
                <tr>
                    <td class="bt">参观调研点<i style="color:red;font-style:normal;">*</i></td>
                    <td><input type="text" name="cgdyd" class="validate[required,length[0,200]]" value="${jdxxEntity.cgdyd}"></td>
                    <td class="bt">人数<i style="color:red;font-style:normal;">*</i></td>
                    <td><input type="text" name="rs" class="validate[required,custom[onlyNumber]]" value="${jdxxEntity.rs}"></td>
                </tr>
                <tr>
                    <td class="bt">密级<i style="color:red;font-style:normal;">*</i></td>
                    <td colspan="3">
                        <select name="mj" id="" style="padding:4px;border:1px solid #ccc;" class="validate[required]" value="${jdxxEntity.mj}" >
                            <option value="1">一级</option>
                            <option value="2">二级</option>
                            <option value="3">三级</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="bt">建议方案附件<i style="color:red;font-style:normal;">*</i></td>
                    <!-- 手动获取附件名称。此时点击附件名称可以下载附件 -->
                    <td>
                        <span onclick="downFile('T_JD_JDXX','${jyfafj_wjEntity.relationalValue}','jyfafj')" title="${jyfafj_fjEntity.mc}" id="jyfafj_xxx_text">${jyfafj_fjEntity.nickMc}</span><!-- a标签，目的是可以下载附件 -->
                        <c:if test="${not empty jyfafj_fjEntity.nickMc}">
                        <span style="color: red" id="jyfafj_file_id" onclick="deleteFile('T_JD_JDXX','${jyfafj_wjEntity.relationalValue}','jyfafj',this)">删除</span>
                        </c:if><input style="width:76%" type="file" name="jyfafj"  class="validate[required]"  ><!-- file目的是重新上传附件 -->
                    </td>
                    <td class="bt">分管领导签批件<i style="color:red;font-style:normal;">*</i></td>
                    <td>
                        <span onclick="downFile('T_JD_JDXX','${fgldqpj_wjEntity.relationalValue}','fgldqpj')" title="${fgldqpj_fjEntity.mc}" id="fgldqpj_xxx_text">${fgldqpj_fjEntity.nickMc}</span><!-- a标签，目的是可以下载附件 -->
                        <c:if test="${not empty fgldqpj_fjEntity.nickMc}">
                        <span style="color: red" onclick="deleteFile('T_JD_JDXX','${fgldqpj_wjEntity.relationalValue}','fgldqpj',this)">删除</span>
                        </c:if><input style="width:76%" type="file" name="fgldqpj"  class="validate[required]"  ><!-- file目的是重新上传附件 -->
                    </td>
                </tr>
                <tr>
                    <td class="bt">备注</td>
                    <td colspan="3">
                        <textarea style="width:670px;height:100px;" name="bz" value="${jdxxEntity.bz}">${jdxxEntity.bz}</textarea>
                    </td>
                </tr>

            </table>
        </div>
    </div>
</form>
</body>
<script type="application/javascript">
	/* 删除附件 */
	function deleteFile(logicTablename,relationalValue,ogicColumn,obj){
     	/* ajax */
     	top.layer.confirm('你确定要删除附件吗?', {
            btn: ['确定','取消'] //按钮
        }, function(index, layero){
            /*ajax*/
            $.ajax({
                //提交数据的类型 POST GET
                type:"POST",
                //提交的网址
                url:contextPath+"/tWjWjController/delLocalFile",
                //提交的数据
                async:false,
                data:{
                	logicTablename:logicTablename,
                	relationalValue:relationalValue,
                	ogicColumn:ogicColumn
                },
                //返回数据的格式
                datatype: "json",//"xml", "html", "script", "json", "jsonp", "text".
                //在请求之前调用的函数
                beforeSend:function(){
                },
                //成功返回之后调用的函数
                success:function(data){
                    //console.log(data)
                    //提示删除成功
                    top.layer.msg(data.msg, {
                        icon: 1,
                        time: 3000 //3秒关闭（如果不配置，默认是3秒）
                    });
                    if(data.success){
                    	 $(obj).remove();
                    	 $("#"+ogicColumn+"_xxx_text").text('');
                    }
                },
                //调用执行后调用的函数
                complete: function(XMLHttpRequest, textStatus){
                },
                //调用出错执行的函数
                error: function(){
                    //请求出错处理
                }
            });
        }, function(index, layero){
            top.layer.close(index)
        });
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
    function form_sbmt_(){
        var resJSON = {};
        var access=true;
        access=$('#singleForm').validationEngine({returnIsValid:true});
        if(access==true){
            $("#singleForm").ajaxSubmit({
                type: 'post',
                async: false,
                url: contextPath+"/tJdJdxxController/savetJdJdxx" ,
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
</html>