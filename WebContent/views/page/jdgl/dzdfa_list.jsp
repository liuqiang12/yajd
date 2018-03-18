<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>接待管理系统</title>
    <meta charset="utf-8" />
    <jsp:include page="/views/home/HeadGrid.jsp"></jsp:include>
</head>
<meta charset="UTF-8">
<script>
    var items_per_page = 8;//每页分页条数
    var page_index = 0;////页号
    function getDataList(index){
        var pageIndex = index;
        $(".addGrid_data_tr").empty();
        $.ajax({
            type: "POST",
            url: contextPath+"/tJdJdxxController/queryPageList?jdxxBzInt=1",
            data: "pageNo="+(pageIndex+1)+'&pageSize='+items_per_page,
            dataType: 'json',
            async:false,
            /*contentType: "application/x-www-form-urlencoded",*/
            success: function(msg){
                var total = msg.total;
                $.each(msg.rows,function(idx,row){
                    //设置相应的界面:录入单位
                    var cbrName = row.cbrName==null?"":row.cbrName;
                    var ptldMc = row.ptldMc==null?"":row.ptldMc;
                    var ddld = row.ddld==null?"":row.ddld;
                    var bz = row.bz==null?"":row.bz;
                    var gridBody = "<tr class='addGrid_data_tr'>"+
                        "           <td style='text-align:left;'>"+row.lrdwEntity.jgMc+"</td>"+
                        "                   <td>"+getFormatDateByLong(row.ksSj, "yyyy-MM-dd")+"</td>"+
                        "                   <td>"+getFormatDateByLong(row.jsSj, "yyyy-MM-dd")+"</td>"+
                        "                   <td style='text-align:left;'>"+row.bt+"</td>"+
                        "                   <td>"+ddld+"</td>"+
                        "                   <td>"+ptldMc+"</td>"+
                        "                   <td><a href='javascript:void(0);' onclick=\"downFile('T_JD_JDXX','"+row.id+"','fgldqpj')\"><img src='"+contextPath+"/lib/images/jpg.png' alt=''></a></td>"+
                        "                   <td><a href='javascript:void(0);' onclick=\"downFile('T_JD_JDXX','"+row.id+"','zdfafj')\"><img src='"+contextPath+"/lib/images/word.png' alt=''></a></td>"+
                        "                   <td style'text-align:left;'>"+bz+"</td>"+
                        "                   <td></td>"+
                        "                   <td>"+cbrName+"</td>"+
                        "                   <td class='btn_group'>" +
                        "                       <span class='btn_g'>" +
                        "                           <button class='button btn_zdfa' onclick=\"zdfaWin('"+row.id+"')\" >制定方案</button>" +

                        "                       </span>" +
                       /*  "                       <span class='btn_g'>" +
                        "                           <button class='button btn_fpry' onclick=\"fhsybWin('"+row.id+"')\" >返回上一步</button>" +
                        "                       </span>" + */
                        "                   <button class='button btn_ptld' onclick=\"ptld('"+row.id+"')\">" +
                        "                        <img src='"+contextPath+"/lib/images/peo.png' alt=''>" +
                        "                   </button>" +
                        "                    <button class='button' onclick=\"jdxxEdit('"+row.id+"')\">" +
                        "                       <img src='"+contextPath+"/lib/images/edit1.png' alt='' />"+
                        "                   </button>" +
                        "                   <button class='button' onclick=\"jdxxDelete('"+row.id+"')\">" +
                        "                       <img src='"+contextPath+"/lib/images/del.png' alt=''/>"+
                        "                   </button>" +
                        "                   </td>"+
                        "                </tr>";

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
    /**
     *
     * */
    function zdfaWin(id){
        /*
         制定方案
         */
        var laySum = top.layer.open({
            type: 2,
            title: "制定方案",
            shadeClose: false,
            shade: 0.8,
            btn: ['确定','关闭'],
            maxmin : true,
            area: ['450px', '350px'],
            content: contextPath+"/tJdJdxxController/zdfaOpenPlugin?id="+id,
            /*弹出框*/
            cancel: function(index, layero){
                top.layer.close(index);
            },yes: function(index, layero){
                var childIframeid = layero.find('iframe')[0]['name'];
                var chidlwin = top.document.getElementById(childIframeid).contentWindow;
                var resJSON = chidlwin.form_sbmt_();
                /*是否保存成功，如果保存成功就关闭窗口然后刷新列表*/
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


                /*var resJOSN = chidlwin.getSelectedGridRecord();   */
            },no: function(index, layero){
                top.layer.close(index)
            }
        });
    }
    function pageselectCallback(page_index, jq){
        getDataList(page_index);
    }
    $(document).ready(function(){
        getDataList(page_index);
    });
    function fpryWin(id){
        /*
         *   分配人员
         * */
        var laySum = top.layer.open({
            type: 2,
            title: "分配人员",
            shadeClose: false,
            shade: 0.8,
            btn: ['确定','关闭'],
            maxmin : true,
            area: ['880px', '550px'],
            content: contextPath+"/tJdJdxxController/fpryOpenPlugin?id="+id,
            /*弹出框*/
            cancel: function(index, layero){
                top.layer.close(index);
            },yes: function(index, layero){
                var childIframeid = layero.find('iframe')[0]['name'];
                var chidlwin = top.document.getElementById(childIframeid).contentWindow;
                var resJSON = chidlwin.form_sbmt_();
                /*是否保存成功，如果保存成功就关闭窗口然后刷新列表*/
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


                /*var resJOSN = chidlwin.getSelectedGridRecord();   */
            },no: function(index, layero){
                top.layer.close(index)
            }
        });
    }
    /**
     *
     * */
    function fsWin(id){
        /*初审*/
        top.layer.confirm('是否通过复审', {
            btn: ['确定','取消'] //按钮
        }, function(index, layero){
            /*ajax*/
            $.ajax({
                //提交数据的类型 POST GET
                type:"POST",
                async:false,
                //提交的网址
                url:contextPath+"/tJdJdxxController/fsUpdate",
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




    /**
     *
     * @param id
     */
    function ptld(id) {
        /*
         *  陪同领导
         * */
        var laySum = top.layer.open({
            type: 2,
            title: "陪同领导",
            shadeClose: false,
            shade: 0.8,
            btn: ['确定','关闭'],
            maxmin : true,
            area: ['450px', '250px'],
            content: contextPath+"/tJdJdxxController/ptldOpenPlugin?id="+id,
            /*弹出框*/
            cancel: function(index, layero){
                top.layer.close(index);
            },yes: function(index, layero){
                var childIframeid = layero.find('iframe')[0]['name'];
                var chidlwin = top.document.getElementById(childIframeid).contentWindow;
                var resJSON = chidlwin.form_sbmt_();
                /*是否保存成功，如果保存成功就关闭窗口然后刷新列表*/
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


                /*var resJOSN = chidlwin.getSelectedGridRecord();   */
            },no: function(index, layero){
                top.layer.close(index)
            }
        });
    }
    /**
     * 编辑弹出界面
     **/
    function jdxxEdit(id){
        /*
         *  陪同领导
         * */
        var laySum = top.layer.open({
            type: 2,
            title: "接待编辑",
            shadeClose: false,
            shade: 0.8,
            btn: ['确定','关闭'],
            maxmin : true,
            area: ['900px', '550px'],
            content: contextPath+"/tJdJdxxController/editOpenPlugin?id="+id,
            /*弹出框*/
            cancel: function(index, layero){
                top.layer.close(index);
            },yes: function(index, layero){
                var childIframeid = layero.find('iframe')[0]['name'];
                var chidlwin = top.document.getElementById(childIframeid).contentWindow;
                var resJSON = chidlwin.form_sbmt_();
                /*是否保存成功，如果保存成功就关闭窗口然后刷新列表*/
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


                /*var resJOSN = chidlwin.getSelectedGridRecord();   */
            },no: function(index, layero){
                top.layer.close(index)
            }
        });
    }
    function jdxxDelete(id) {
        /** 确定要删除吗 **/
        top.layer.confirm('你确定要删除吗？', {
            btn: ['确定','取消'] //按钮
        }, function(index, layero){
            /*ajax*/
            $.ajax({
                //提交数据的类型 POST GET
                type:"POST",
                //提交的网址
                url:contextPath+"/tJdJdxxController/delTJdJdxx",
                //提交的数据
                async:false,
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
</script>
</head>
<body style="overflow:hidden;">
<div class="container">
    <div id="table" class="mt10">
        <div class="box span10 oh">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="list_table">
                <tr id="grid_head_tr">
                    <th style="width:12%;min-width:40px;">录入<br/>单位</th>
                    <th style="width:7%;min-width:40px;">开始<br/>时间</th>
                    <th style="width:7%;min-width:40px;">结束<br/>时间</th>
                    <th style="width:25%;min-width:40px;">标题</th>
                    <th style="width:5%;min-width:40px;">带队<br/>领导</th>
                    <th style="width:5%;min-width:40px;">陪同<br/>领导</th>
                    <th style="width:3%;min-width:40px;">领导<br/>批示</th>
                    <th style="width:3%;min-width:40px;">建议<br/>方案</th>
                    <th style="width:10%;min-width:40px;">备注<br/>事项</th>
                    <th style="width:5%;min-width:40px;">接待<br/>方案</th>
                    <th style="width:5%;min-width:40px;">接待<br/>人员</th>
                    <th style="width:13%;min-width:302px;">操作</th>
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

<!--分配人员弹出框-->
<div id="fpryDialog" class="dialog_1" style="display:none;">
    <h3 class="title">分配人员 <a class="close" href="javascript:;"><img src="<%=request.getContextPath() %>/lib/images/close.png" alt=""></a></h3>
    <div class="content">
        <table>
            <tr>
                <th colspan="2">请选择分配人员</th>
            </tr>
            <tr>
                <td class="bt">时间</td>
                <td><input type="text" calendar="YYYY-MM-DD"></td>
            </tr>
            <tr>
                <td class="bt">人员列表</td>
                <td>
                    <label><input type="radio" name="peo">关晓松</label>
                    <label><input type="radio" name="peo">王茜</label>
                    <label><input type="radio" name="peo">程访</label>
                    <label><input type="radio" name="peo">胡婧</label>
                    <label><input type="radio" name="peo">刘波</label>
                    <label><input type="radio" name="peo">蒲秋威</label>
                    <label><input type="radio" name="peo">宋东琴</label>
                </td>
            </tr>
        </table>
        <div class="btn">
            <button class="button">提交</button>
        </div>
    </div>
</div>


<!--陪同领导弹出框-->
<div id="txldDialog" style="display:none;">
    <h3 class="title">填写陪同领导 <a class="close" href="javascript:;"><img src="<%=request.getContextPath() %>/lib/images/close.png" alt=""></a></h3>
    <div class="content">
        <table>
            <tr>
                <th colspan="2">请填写陪同领导</th>
            </tr>
            <tr>
                <td class="bt">陪同领导</td>
                <td><input type="text"></td>
            </tr>
        </table>
        <div class="btn">
            <button class="button">提交</button>
        </div>
    </div>
</div>
<script>
    $('.btn_fpry').click(function(){
        easyDialog.open({
            container : 'fpryDialog',
            drag : true,
            fixed : false
        });
    });
    $('.btn_ptld').click(function(){
        easyDialog.open({
            container : 'txldDialog',
            drag : true,
            fixed : false
        });
    });

    $('.close').click(function(){
        easyDialog.close();
    })
</script>
</body>
</html>