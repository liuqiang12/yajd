<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html> <!-- Do not add ng-app here as we bootstrap AngularJS manually-->
<head>
    <title>接待管理系统</title>
    <meta charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/lib/css/reset.css">
    <link rel="stylesheet" href="<%=request.getContextPath() %>/lib/css/Site.css">
    <link rel="stylesheet" href="<%=request.getContextPath() %>/lib/css/pagination.css">
    <link rel="stylesheet" href="<%=request.getContextPath() %>/lib/css/easydialog.css">
    <script src="<%=request.getContextPath() %>/lib/js/jquery-1.8.1.min.js"></script>
    <script src="<%=request.getContextPath() %>/lib/js/jquery.pagination.new.js"></script>
    <script src="<%=request.getContextPath() %>/lib/js/common.js"></script>
    <!-- ztree形式 -->
    <script type="text/javascript" src="<%=request.getContextPath() %>/lib/zTree_v3/js/jquery.ztree.core.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/lib/zTree_v3/js/jquery.ztree.excheck.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/lib/zTree_v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <!-- 主要是针对于布局easyui -->
    <script type="text/javascript" src="<%=request.getContextPath() %>/lib/jquery-easyui-1.5/jquery.easyui.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/lib/jquery-easyui-1.5/themes/default/easyui.css" type="text/css">
    <link rel="stylesheet" href="<%=request.getContextPath() %>/lib/jquery-easyui-1.5/themes/icon.css" type="text/css">
    <script type="application/javascript">
        var contextPath = "${pageContext.request.contextPath}";

        var zTree ;
        var items_per_page = 8;//每页分页条数:每页三条记录
        var page_index = 0;////页号
        var setting = {
            view : {
                showLine : true,
                selectedMulti : false,
                dblClickExpand : false
            },
            check: {
                enable: true,
                nocheckInherit: false,
                chkStyle: "radio",  //单选框
                radioType: "all"   //对所有节点设置单选
            },
            data : {
                simpleData: {
                    enable: true,
                    idKey: "id",
                    pIdKey: "pid",
                    rootPId: 'root'
                }
            },
            callback : {
                onClick : this.onClick,
                beforeExpand: beforeExpand,
                onAsyncSuccess: onAsyncSuccess,
                onAsyncError: onAsyncError
            },
            async: {
                enable: false,
                url: getUrl
            }
        };
        //过滤节点的机制 直接return node表示不做任何过滤
        function filter(node) {
            return node;
        }

        function onClick(e, treeId, treeNode) {
            /*zTree.checkNode(zTree.getNodeByParam("id",treeNode.id, null), true, true);*/
            getDataList(0,treeNode.id);
        }
        /*  单位信息  */
        $(document).ready(function() {
            var data = eval("("+'${treeNode}'+")");
            zTree = $.fn.zTree.init($("#treeDemo"), setting, data);
            getDataList(page_index,null);
        });
        function beforeExpand(treeId, treeNode) {
            //alert("beforeExpand-----------");
            if (!treeNode.isAjaxing) {
                startTime = new Date();
                treeNode.times = 1;

                ajaxGetNodes(treeNode, "refresh");
                return true;
            } else {
                //alert("zTree 正在下载数据中，请稍后展开节点。。。");
                return false;
            }
        }
        //手动添加异步加载
        function ajaxGetNodes(treeNode, reloadType) {
            // alert("ajaxGetNodes-----------");
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            if (reloadType == "refresh") {
                zTree.updateNode(treeNode);
            }
            zTree.reAsyncChildNodes(treeNode, reloadType, true);
        }
        function getUrl(treeId, treeNode) {
            if(treeNode){
                return contextPath+"/tXtDwController/queryZtreeRecord.do?pid="+treeNode.id;
            }else{
                return contextPath+"/tXtDwController/queryZtreeRecord.do?pid=";
            }
        }
        function onAsyncSuccess(event, treeId, treeNode, msg) {
            //alert("onAsyncSuccess-----------");
            if (!msg || msg.length == 0) {
                return;
            }
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            if(treeNode){
                var totalCount = treeNode.count;
                if (treeNode.children.length < totalCount) {
                    setTimeout(function() {ajaxGetNodes(treeNode);}, perTime);
                } else {
                    treeNode.icon = "";
                    zTree.updateNode(treeNode);
                    zTree.selectNode(treeNode.children[0]);
                }
            }
        }
        function onAsyncError(event, treeId, treeNode, XMLHttpRequest, textStatus, errorThrown) {
            //alert("onAsyncError-----------");
            zTree = $.fn.zTree.getZTreeObj("treeDemo");
            // alert("异步获取数据出现异常。");
            treeNode.icon = "";
            zTree.updateNode(treeNode);
        }
        function getCheckedNode(){
            var treeObj=$.fn.zTree.getZTreeObj("treeDemo"),
                nodes=treeObj.getSelectedNodes();
            var resJOSN = {};
            for(var i=0;i<nodes.length;i++){
                resJOSN['id'] = nodes[i].id;
                resJOSN['name'] = nodes[i].name;
                return resJOSN;
            }
            return null;
        }
        function checkedRow(idx){
            $("#grid_row_"+idx).attr("checked", true);
        }
        function checkedSingleRow(idx){
            /* 去掉其他的选项 */
            $("input[id^='grid_row_']").each(function(){
                $(this).attr("checked", false);
            })
            $("#grid_row_"+idx).attr("checked", true);
        }
        /* 界面弹出框。显示人员详情 */
        function queryInfo(id){
            var laySum = top.layer.open({
                type: 2,
                title: "人员详情",
                shadeClose: false,
                shade: 0.8,
                btn: ['关闭'],
                maxmin : true,
                area: ['800px', '390px'],
                content: contextPath+"/tXtRyController/queryUserOpenPlugin?id="+id,
                /*弹出框*/
                cancel: function(index, layero){
                    top.layer.close(index);
                },no: function(index, layero){
                    top.layer.close(index)
                }
            });
        }
        /**
         * 编辑框
         * @param id
         */
        function editInfo(id) {
            var laySum = top.layer.open({
                type: 2,
                title: "编辑",
                shadeClose: false,
                shade: 0.8,
                btn: ['确定','关闭'],
                maxmin : true,
                area: ['800px', '390px'],
                content: contextPath+"/tXtRyController/editUserOpenPlugin?id="+id,
                /*弹出框*/
                cancel: function(index, layero){
                    top.layer.close(index);
                },yes: function(index, layero){
                    var childIframeid = layero.find('iframe')[0]['name'];
                    var chidlwin = top.document.getElementById(childIframeid).contentWindow;
                    var resJSON = chidlwin.form_sbmt_();
                    if(!resJSON['validation']){
                        top.layer.msg('请填写必填项!', {
                            icon: 1,
                            time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                        });
                    }else if(resJSON['data'].isExists){
                        top.layer.msg(resJSON['data'].msg, {
                            icon: 1,
                            time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                        });
                    } else if(resJSON['data'] && resJSON['data'].success && !resJSON['data'].isExists){
                        top.layer.msg(resJSON['data'].msg, {
                            icon: 1,
                            time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                        });
                        /* 删除成功后刷新grid */
                        getDataList(0,null);
                        top.layer.close(index)
                    }else{
                        //存在了相同的数据项或者后台数据报错
                        top.layer.msg(resJSON['data'].msg, {
                            icon: 1,
                            time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                        });
                    }

                },no: function(index, layero){
                    top.layer.close(index)
                }
            });
        }
        /**
         * 删除对象
         */
        function deleteInfo(id){
            top.layer.confirm('你确定要删除吗？', {
                btn: ['确定','取消'] //按钮
            }, function(index, layero){
                /*ajax*/
                $.ajax({
                    //提交数据的类型 POST GET
                    type:"POST",
                    async:false,
                    //提交的网址
                    url:contextPath+"/tXtRyController/delTXtRy",
                    //提交的数据
                    data:{
                        id:id
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
            }, function(index, layero){
                top.layer.close(index)
            });
        }
        function getSelectedGridRecord(){
            /* 获取被选中的人员信息 */
            var selectedInput = $("input:checkbox[id^='grid_row_']:checked");
            if(selectedInput && selectedInput.length > 0){
                var value  = $(selectedInput).val();
                var id = $(selectedInput).attr("id");
                /* 获取行号 */
                var row_idx = id.split("grid_row_")[1];
                var text = $("#grid_row_text_"+row_idx).val();
                var resJSON = {};
                resJSON['id'] = value;
                resJSON['name'] = text;
                return resJSON
            }else{
                return null;
            }
        }
        function getDataList(index,id){
            var pageIndex = index;
            $(".addGrid_data_tr").empty();
            $.ajax({
                type: "POST",
                url: contextPath+"/tXtRyController/queryPageList",
                data: "pageNo="+(pageIndex+1)+'&pageSize='+items_per_page+'&dwId='+id,
                dataType: 'json',
                async:false,
                /*contentType: "application/x-www-form-urlencoded",*/
                success: function(msg){
                    var total = msg.total;
                    var rows = msg.rows;
                    $.each(msg.rows,function(idx,row){
                         var gridBody = "<tr  onclick='checkedSingleRow("+idx+")' class='addGrid_data_tr'>"+
                        "<td style='text-align:left;'><input id='grid_row_text_"+idx+"' type='hidden' value='"+row.xm+"' /><input type='checkbox' id='grid_row_"+idx+"' value='"+row.id+"'></input>"+row.xm+"</td>"+
                        "   <td>"+(row.xb=='male'?'男':'女')+"</td>"+
                        "   <td>"+row.zw+"</td>"+
                        "   <td>"+row.lxfs+"</td>"+
                        "   <td>"+
                        "   <span class='btn_g'>"+
                        "   <button class='button btn_ptld' onclick=\"queryInfo('"+row.id+"')\"><img src='"+contextPath+"/lib/images/peo.png' alt=''></button>"+
                        "   <button class='button' onclick=\"editInfo('"+row.id+"')\" >"+
                        "   <img src='"+contextPath+"/lib/images/edit1.png' alt=''>"+
                        "   </button>"+
                        "   <button class='button' onclick=\"deleteInfo('"+row.id+"')\" >"+
                        "   <img src='"+contextPath+"/lib/images/del.png' alt=''>"+
                        "   </button>"+
                        "   </td>"+
                        "   </tr>";
                        $("#grid_head_tr").after(gridBody);
                    });
                    //分页-只初始化一次
                    if($("#Pagination").html().length == ''){
                        $("#Pagination").easyPagination(total, {
                            'items_per_page'      : items_per_page,
                            'num_display_entries' : 8,
                            'num_edge_entries'    : 1,
                            'prev_text'           : "上一页",
                            'next_text'           : "下一页",
                            'callback'            : pageselectCallback
                        });
                    }
                }
            });
        }
        function pageselectCallback(page_index, jq){
            getDataList(page_index,null);
        }
        /**
         * 选择人员表
         */
        function addRyClick(){
            /* 前提先选中左侧的单位 */
            var treeCheckedJSON = getCheckedNode();
            if(treeCheckedJSON == null){
                top.layer.msg('必须先选择所属单位!', {
                    icon: 1,
                    time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                });
                return false;
            }
            var laySum = top.layer.open({
                type: 2,
                title: "人员新增",
                shadeClose: false,
                shade: 0.8,
                btn: ['确定','关闭'],
                maxmin : true,
                area: ['750px', '450px'],
                content: contextPath+"/tXtRyController/userOpenFormPlugin?dwId="+treeCheckedJSON['id'],
                /*弹出框*/
                cancel: function(index, layero){
                    top.layer.close(index);
                },yes: function(index, layero){
                    var childIframeid = layero.find('iframe')[0]['name'];
                    var chidlwin = top.document.getElementById(childIframeid).contentWindow;
                    /* 保存form表单的数据 */
                    //console.log("==============");
                    var resJSON = chidlwin.form_sbmt_();

                    if(!resJSON['validation']){
                        top.layer.msg('请填写必填项!', {
                            icon: 1,
                            time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                        });
                    }else if(resJSON['data'].isExists){
                        top.layer.msg(resJSON['data'].msg, {
                            icon: 1,
                            time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                        });
                    } else if(resJSON['data'] && resJSON['data'].success && !resJSON['data'].isExists){
                        top.layer.msg(resJSON['data'].msg, {
                            icon: 1,
                            time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                        });
                        /* 删除成功后刷新grid */
                        getDataList(0,null);
                        top.layer.close(index)
                    }else{
                        //存在了相同的数据项或者后台数据报错
                        top.layer.msg(resJSON['data'].msg, {
                            icon: 1,
                            time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
                        });
                    }

                },no: function(index, layero){
                    top.layer.close(index)
                }
            });
        }
    </script>
</head>
<body style="overflow-x:hidden;overflow-y:auto;" class="easyui-layout">
    <!-- 左右布局 -->
    <div data-options="region:'west',title:'',split:true" style="width:200px;">
        <ul id="treeDemo" class="ztree"></ul>
    </div>
    <div data-options="region:'center',title:''">
        <!-- 查询toolbar：分页grid -->
        <div class="container">
            <div id="table" class="mt10">
                <div class="box span10 oh">
                    <div>
                        <a href="#" class="easyui-linkbutton" plain="true" icon="icon-add" onclick="addRyClick()">新增</a>
                    </div>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="list_table">
                        <tr id="grid_head_tr">
                            <th style="width:12%;min-width:40px;">名称</th>
                            <th style="width:2%;min-width:15px;">性别</th>
                            <th style="width:7%;min-width:40px;">职务</th>
                            <th style="width:5%;min-width:40px;">联系方式</th>
                            <th style="width:13%;min-width:150px;">操作</th>
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
    </div>
</body>
</html>