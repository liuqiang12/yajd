<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html> <!-- Do not add ng-app here as we bootstrap AngularJS manually-->
<head>
    <title>接待管理系统</title>
    <meta charset="utf-8" />
    <jsp:include page="/views/home/HeadGrid.jsp"></jsp:include>
    <script>
        var items_per_page = 8;//每页分页条数
        var page_index = 0;////页号
        function getDataList(index){
            var pageIndex = index;
            $(".addGrid_data_tr").empty();
            $.ajax({
                type: "POST",
                async:false,
                url: contextPath+"/tXtOperateController/queryPageList",
                data: "pageNo="+(pageIndex+1)+'&pageSize='+items_per_page,
                dataType: 'json',
                /*contentType: "application/x-www-form-urlencoded",*/
                success: function(msg){
                    var total = msg.total;
                    $.each(msg.rows,function(idx,row){
                        //操作人  操作时间 操作内容
                        var gridBody = "<tr class='addGrid_data_tr' >"+
                            "               <td>"+(idx+1) +"</td>"+
                            "               <td style='text-align:center;'>"+row.mc+"</td>";
                        if(row.isHold == 1){
                            gridBody +="    <td><input type='checkbox' id='"+row.id+"' checked onclick=\"changeStatus('"+row.id+"','0')\"></td>";
                        }else{
                            gridBody +="    <td><input type='checkbox' id='"+row.id+"' onclick=\"changeStatus('"+row.id+"','1')\"></td>";
                        }
                        gridBody += "   </tr>";
                        $("#grid_head_tr").before(gridBody);
                    });
                    //分页-只初始化一次
                    if($("#Pagination").html().length == ''){
                        $("#Pagination").pagination(total, {
                            'items_per_page'      : items_per_page,
                            'num_display_entries' : 10,
                            'num_edge_entries'    : 2,
                            'prev_text'           : "上一页",
                            'next_text'           : "下一页",
                            'callback'            : pageselectCallback
                        });
                    }
                }
            });
        }
        function pageselectCallback(page_index, jq){
            getDataList(page_index);
        }
        $(document).ready(function(){
            getDataList(page_index);
            getRoleList();
        });
        function getRoleList(){
            /* 加载角色列表 */
            $("#jsinfo_id").empty();
            $.ajax({
                type: "POST",
                async:false,
                url: contextPath+"/tXtJsController/queryList",
                dataType: 'json',
                success: function(msg){
                    $.each(msg.rows,function(idx,row){
                        $("#jsinfo_id").append("<option value='"+row.id+"'>"+row.mc+"</option>");
                    })

                }
            });
        }
        function changeStatus(id,isHold){
            /**
             * 修改状态后再刷新
             */
            $.ajax({
                //提交数据的类型 POST GET
                type:"POST",
                async:false,
                //提交的网址
                url:contextPath+"/tXtOperateController/updateOperateIsHold",
                //提交的数据
                data:{
                    id:id,
                    isHold:isHold
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
                    /* 删除成功后刷新grid */
                    getDataList(page_index,null);
                },
                //调用执行后调用的函数
                complete: function(XMLHttpRequest, textStatus){
                },
                //调用出错执行的函数
                error: function(){
                    //请求出错处理
                }
            });
        }
    </script>
</head>
<body style="overflow:hidden;">
<div class="container">
    <p class="qxfp_title">功能分配：
        <%--<select name="" id="jsinfo_id">--%>
            <%--<option value="系统管理员">系统管理员</option>
            <option value="接待办管理人员">接待办管理人员</option>
            <option value="接待办普通人员">接待办普通人员</option>
            <option value="其他单位人员">其他单位人员</option>--%>
        <%--</select>--%>
    </p>
    <div id="table" class="mt10">
        <div class="box span10 oh">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="list_table">
                <tr>
                    <th style="width:40px;">序号</th>
                    <th style="width:100px;">功能名称</th>
                    <th>详细名单</th>
                    <th style="width:100px;">选择人员</th>
                </tr>
                <tr id="grid_head_tr"></tr>
            </table>
        </div>
    </div>
</div>
<div id="Pagin">
    <div id="pages" class="pages">
        <div id="Pagination" class="pagination"></div>
    </div>
</div>
</body>
</html>