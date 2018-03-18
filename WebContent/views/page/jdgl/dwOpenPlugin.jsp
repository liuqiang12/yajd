<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html> <!-- Do not add ng-app here as we bootstrap AngularJS manually-->
<head>
    <title>接待管理系统</title>
    <meta charset="utf-8" />
    <jsp:include page="/views/home/Head.jsp"></jsp:include>
    <!-- ztree形式 -->
    <script type="text/javascript" src="<%=request.getContextPath() %>/lib/zTree_v3/js/jquery.ztree.core.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/lib/zTree_v3/js/jquery.ztree.excheck.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/lib/zTree_v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <!-- 主要是针对于布局easyui -->
    <script type="text/javascript" src="<%=request.getContextPath() %>/lib/jquery-easyui-1.5/jquery.easyui.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/lib/jquery-easyui-1.5/themes/default/easyui.css" type="text/css">
    <link rel="stylesheet" href="<%=request.getContextPath() %>/lib/jquery-easyui-1.5/themes/icon.css" type="text/css">
    <script type="application/javascript">
        var zTree ;
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
            zTree.checkNode(zTree.getNodeByParam("id",treeNode.id, null), true, true);
        }
        /*  单位信息  */
        $(document).ready(function() {
            var data = eval("("+'${treeNode}'+")");
            zTree = $.fn.zTree.init($("#treeDemo"), setting, data);
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
                nodes=treeObj.getCheckedNodes(true);
            var resJOSN = {};
            for(var i=0;i<nodes.length;i++){
                resJOSN['id'] = nodes[i].id;
                resJOSN['name'] = nodes[i].name;
                return resJOSN;
            }
            return null;
        }
        function addDwClick(){
            /* 弹出框 */
            var laySum = top.layer.open({
                type: 2,
                title: "单位新增",
                shadeClose: false,
                shade: 0.8,
                btn: ['确定','关闭'],
                maxmin : true,
                area: ['750px', '350px'],
                content: contextPath+"/tXtDwController/layerDwFormWin",
                /*弹出框*/
                cancel: function(index, layero){
                    top.layer.close(index);
                },yes: function(index, layero){
                    var childIframeid = layero.find('iframe')[0]['name'];
                    var chidlwin = top.document.getElementById(childIframeid).contentWindow;
                    /*  验证是否需要关闭窗口 */
                    var resJSON = chidlwin.form_sbmt();

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
                        //然后刷新tree 数据
                        $.ajax({
                            type: "post",
                            url: contextPath+"/tXtDwController/queryZtreeRecord.do",
                            dataType: "json",
                            async:false,
                            success: function (data) {
                                zTreeObj = $.fn.zTree.init($("#treeDemo"), setting, eval(data));
                            }
                        });
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
<body style="overflow-x:hidden;overflow-y:auto;">
    <div>
        <a href="#" class="easyui-linkbutton" plain="true" icon="icon-add" onclick="addDwClick()">新增</a>
    </div>
    <ul id="treeDemo" class="ztree"></ul>
</body>
</html>