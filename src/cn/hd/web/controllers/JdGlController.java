package cn.hd.web.controllers;

import cn.hd.common.constant.TreeNode;
import cn.hd.common.enumeration.ZtreeEnum;
import cn.hd.entity.TXtRyEntity;
import cn.hd.module.repository.service.TXtRyService;
import cn.hd.module.repository.service.ZTreeService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by DELL on 2017/12/17.
 * 刘强:接待管理
 */
@Controller
@RequestMapping("jdGlController")
public class JdGlController extends BaseController{
    protected Logger log = Logger.getLogger(this.getClass().getName());
    @Autowired
    private ZTreeService zTreeService;
    @Autowired
    private TXtRyService ryService;//人员信息
    /**
     * 菜单跳转方法，跳转规则是.XXXX.do?URL=xxx:
     */
    @RequestMapping("menuLink/{url}/{module}")
    public String menuLink_xzjd(@PathVariable String url,@PathVariable Integer module,HttpServletRequest request, org.springframework.ui.Model model){
        /*  菜单链接:模块功能  */
        try{
            jlLog(module,url);
        }catch (Exception e){
            e.printStackTrace();
        }
       return jdglPrefix+url;
    }
    @RequestMapping("createJdglModel")
    public String createJdglModel(){
        System.out.println("获取门户session用户   模拟");
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("flag",1);
        TXtRyEntity xtRyEntity = ryService.getAuthUserByFlag("from TXtRyEntity t where t.flag = :flag",params);
        /* 系统人员 */
        model.addAttribute("xtRyEntity",xtRyEntity);
        return jdglPrefix+"addjd";
    }


    /**
     *
     */
    @RequestMapping("dwOpenPlugin")
    public String dwOpenPlugin(HttpServletRequest request, org.springframework.ui.Model model){
        /*  菜单链接:模块功能  */
        log.debug("。。。。。。。。。。。。。[构建相应的树形数据]。。。。。。。。。。。。。");
        TreeNode treeNode = new TreeNode();
        treeNode.setName("单位信息");
        treeNode.setNodeType("root");
        treeNode.setIsParent("true");
        treeNode.setIsedit("true");
        treeNode.setOpen("true");
        treeNode.setTitle("单位信息");
        treeNode.setPid("---");
        try {
            List<TreeNode> treeNodes =  zTreeService.getTree(treeNode,ZtreeEnum.XTDW,null,"false");
            /*treeNode.setChildren(treeNodes);*/
        } catch (Exception e) {
            e.printStackTrace();
        }
        model.addAttribute("treeNode",net.sf.json.JSONObject.fromObject(treeNode));
        return jdglPrefix+"dwOpenPlugin";
    }

    @RequestMapping("index")
    public String index(){
        return jdglPrefix+"index";
    }
}
