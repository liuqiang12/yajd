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
                url: contextPath+"/tXtSzController/queryPageList",
                data: "pageNo="+(pageIndex+1)+'&pageSize='+items_per_page,
                dataType: 'json',
                /*contentType: "application/x-www-form-urlencoded",*/
                success: function(msg){
                    var total = msg.total;
                    $.each(msg.rows,function(idx,row){
                        //操作人  操作时间 操作内容

                        var gridBody = "<tr class='addGrid_data_tr'>"+
                            "               <td>"+(idx+1) +"</td>"+
                            "               <td style='text-align:center;'>"+row.mc+"</td>";
                            if(row.qz == 1){
                                gridBody += "               <td><label><input type='radio' name='yes' checked onclick=\"szQz('"+row.id+"','1')\"> 是</label><label><input type='radio' name='yes'   onclick=\"szQz('"+row.id+"','0')\">否</label></td>";
                            }else{
                                gridBody += "               <td><label><input type='radio' name='yes'  onclick=\"szQz('"+row.id+"','1')\"> 是</label><label><input type='radio' name='yes' checked  onclick=\"szQz('"+row.id+"','0')\">否</label></td>";
                            }
                            gridBody +=
                            "           </tr>";
                        $("#grid_head_tr").after(gridBody);
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
        });
        function szQz(id,qz){
            /*ajax*/
            $.ajax({
                //提交数据的类型 POST GET
                type:"POST",
                async:false,
                //提交的网址
                url:contextPath+"/tXtSzController/updateSzQz",
                //提交的数据
                data:{
                    id:id,
                    qz:qz
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
    <div id="table" class="mt10">
        <div class="box span10 oh">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="list_table">
                <tr id="grid_head_tr">
                    <th style="width:10%;min-width:40px;">序号</th>
                    <th style="width:60%;min-width:100px;">功能配置</th>
                    <th style="width:20%;min-width:100px;">设置</th>
                </tr>
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