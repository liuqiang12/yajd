package cn.hd.web.controllers;

import cn.hd.common.enumeration.JdxxBzEnum;
import cn.hd.common.page.PageBean;
import cn.hd.entity.*;
import cn.hd.module.repository.service.TJdJdxxService;
import cn.hd.module.repository.service.TWjFjService;
import cn.hd.module.repository.service.TWjWjService;
import cn.hd.module.repository.service.TXtRyService;
import cn.hd.utils.ResponseJSON;
import org.apache.log4j.Logger;
import org.codehaus.jackson.map.annotate.JsonSerialize;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("tJdJdxxController")
public class TJdJdxxController extends BaseController {
    protected Logger log = Logger.getLogger(this.getClass().getName());
    @Autowired
    private TJdJdxxService tJdJdxxService;
    @Autowired
    private TXtRyService ryService;//系统人员
    @Autowired
    private TWjWjService wjService;//文件附件表
    @Autowired
    private TWjFjService fjService;//附件主表结构

    /**
     * 新增业务
     *
     * @param tJdJdxx
     * @return
     */
    @RequestMapping(value = "savetJdJdxx",produces = "application/json; charset=UTF-8")
    @ResponseBody
    public ResponseJSON savetJdJdxx(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception {
        log.debug("。。。。。。。。。。。。。新增业务。。。。。。。。。。。。。");
        ResponseJSON responseJSON = new ResponseJSON();
        if (tJdJdxx.getId() == "" || "".equals(tJdJdxx.getId())){
            tJdJdxx.setId(null);
        }
        try {
            /* 后台验证。是否应存在了相应的标题:避免重复提交 */
            Boolean isExistsByBt = tJdJdxxService.isExistsByBt(tJdJdxx);
            if(isExistsByBt){
                /* 已经存在了数据。不能再次保存 */
                responseJSON.setSuccess(Boolean.TRUE);
                Map<String,Object> resMap = new HashMap<String,Object>();
                responseJSON.setIsExists(true);
                responseJSON.setMsg("存在相同数据:"+tJdJdxx.getBt());
                responseJSON.setId(tJdJdxx.getId());
            }else{
                String fid = request.getParameter("fid");//录入单位ID
                String fqrId = request.getParameter("fqrId");//发起人ID

                /** 发起单位 **/
                TXtDwEntity xtDwEntity = new TXtDwEntity();
                xtDwEntity.setId(fid);
                tJdJdxx.setLrdwEntity(xtDwEntity);
                /** 发起人 **/
                TXtRyEntity ryEntity = new TXtRyEntity();
                ryEntity.setId(fqrId);
                tJdJdxx.setRyEntity(ryEntity);
                //默认情况是带分配
                if(tJdJdxx.getJdxxBzText() == null){
                	tJdJdxx.setJdxxBz(JdxxBzEnum.DFPRY);
                }else if(tJdJdxx.getJdxxBzText().equals("DFPRY")){
                	tJdJdxx.setJdxxBz(JdxxBzEnum.DFPRY);
                }else if(tJdJdxx.getJdxxBzText().equals("DZDFA")){
                	tJdJdxx.setJdxxBz(JdxxBzEnum.DZDFA);
                }else if(tJdJdxx.getJdxxBzText().equals("DCS")){
                	tJdJdxx.setJdxxBz(JdxxBzEnum.DCS);
                }else if(tJdJdxx.getJdxxBzText().equals("DFS")){
                	tJdJdxx.setJdxxBz(JdxxBzEnum.DFS);
                }else if(tJdJdxx.getJdxxBzText().equals("FSWC")){
                	tJdJdxx.setJdxxBz(JdxxBzEnum.FSWC);
                }
                
                responseJSON = tJdJdxxService.saveTJdJdxx(tJdJdxx,request);
                responseJSON.setId(tJdJdxx.getId());
            }
        } catch (Exception e) {
            e.printStackTrace();
            responseJSON.setSuccess(Boolean.FALSE);
            responseJSON.setMsg("保存失败!");
        } finally {
            /* 日志控制信息:日志控制不需要和业务事物同步 */
            ((BaseController) AopContext.currentProxy()).addLog(responseJSON.getT_xt_rz());
        };
        return responseJSON;
    }

    /**
     * 分配人员信息
     * @param tJdJdxx
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "insertFpxx",produces = "application/json; charset=UTF-8")
    @ResponseBody
    public ResponseJSON insertFpxx(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception {
        log.debug("。。。。。。。。。。。。。新增业务。。。。。。。。。。。。。");
        ResponseJSON responseJSON = new ResponseJSON();
        if (tJdJdxx.getId() == "" || "".equals(tJdJdxx.getId())){
            try {
                PrintWriter out = response.getWriter();
                response.setContentType("text/html; charset=utf-8");
                out.print("<script>" +
                        "top.layer.msg('数据缺失，请查看数据！', {\n" +
                        "                icon: 2,\n" +
                        "                time: 1500\n" +
                        "          });</script>");
                out.flush();
                out.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        try {
            TJdJdxxEntity tJdJdxxTmp = tJdJdxx;//tJdJdxxService.findById(tJdJdxx.getId());
            /* 承办人ID */
            String cbrId = request.getParameter("cbrId");
            TXtRyEntity cbryEntity = ryService.findById(cbrId);

            tJdJdxxTmp.setCbrName(cbryEntity.getXm());
            tJdJdxxTmp.setCbdwId(cbrId);
            /*tJdJdxxTmp.setCbdwId(cbryEntity.getXtDwEntity().getId());*/
            tJdJdxxTmp.setJdxxBz(JdxxBzEnum.DZDFA);
            tJdJdxxTmp.setFpcbrSj(tJdJdxx.getFpcbrSj());
            responseJSON = tJdJdxxService.updateTJdJdxx(tJdJdxxTmp);
        } catch (Exception e) {
            e.printStackTrace();
            responseJSON.setSuccess(Boolean.FALSE);
            responseJSON.setMsg("保存失败!");
        } finally {
            /* 日志控制信息:日志控制不需要和业务事物同步 */
            ((BaseController) AopContext.currentProxy()).addLog(responseJSON.getT_xt_rz());
        };
        return responseJSON;
    }

    /**
     * 陪同领导信息
     * @param tJdJdxx
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "insertPtld",produces = "application/json; charset=UTF-8")
    @ResponseBody
    public ResponseJSON insertPtld(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception {
        log.debug("。。。。。。。。。。。。。陪同领导。。。。。。。。。。。。。");
        ResponseJSON responseJSON = new ResponseJSON();
        if (tJdJdxx.getId() == "" || "".equals(tJdJdxx.getId())){
            try {
                PrintWriter out = response.getWriter();
                response.setContentType("text/html; charset=utf-8");
                out.print("<script>" +
                        "top.layer.msg('数据缺失，请查看数据！', {\n" +
                        "                icon: 2,\n" +
                        "                time: 1500\n" +
                        "          });</script>");
                out.flush();
                out.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        try {
            String ptldId = request.getParameter("ptldId");
            String ptldMc = request.getParameter("ptldMc");
            tJdJdxx.setPtldId(ptldId);
            tJdJdxx.setPtldMc(ptldMc);
            responseJSON = tJdJdxxService.updateTJdJdxxPtld(tJdJdxx);
            responseJSON.setMsg("成功增加陪同领导!");
        } catch (Exception e) {
            e.printStackTrace();
            responseJSON.setSuccess(Boolean.FALSE);
            responseJSON.setMsg("保存失败!");
        } finally {
            /* 日志控制信息:日志控制不需要和业务事物同步 */
            ((BaseController) AopContext.currentProxy()).addLog(responseJSON.getT_xt_rz());
        };
        return responseJSON;
    }

    /**
     * 指定方案
     * @param tJdJdxx
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "insertZdfa",produces = "application/json; charset=UTF-8")
    @ResponseBody
    public ResponseJSON insertZdfa(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception {
        log.debug("。。。。。。。。。。。。。指定方案。。。。。。。。。。。。。");
        ResponseJSON responseJSON = new ResponseJSON();
        if (tJdJdxx.getId() == "" || "".equals(tJdJdxx.getId())){
            try {
                PrintWriter out = response.getWriter();
                response.setContentType("text/html; charset=utf-8");
                out.print("<script>" +
                        "top.layer.msg('数据缺失，请查看数据！', {\n" +
                        "                icon: 2,\n" +
                        "                time: 1500\n" +
                        "          });</script>");
                out.flush();
                out.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        try {
            responseJSON = tJdJdxxService.updateTJdJdxxZdfn(tJdJdxx,request);
            responseJSON.setMsg("制定方案成功!");
        } catch (Exception e) {
            e.printStackTrace();
            responseJSON.setSuccess(Boolean.FALSE);
            responseJSON.setMsg("保存失败!");
        } finally {
            /* 日志控制信息:日志控制不需要和业务事物同步 */
            ((BaseController) AopContext.currentProxy()).addLog(responseJSON.getT_xt_rz());
        };
        return responseJSON;
    }

    /**
     * 修改业务
     *
     * @param tJdJdxx
     * @return
     */
    @RequestMapping(value = "updateTJdJdxx")
    @ResponseBody
    public ResponseJSON updateTJdJdxx(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception {
        log.debug("。。。。。。。。。。。。。修改业务。。。。。。。。。。。。。");
        ResponseJSON responseJSON = new ResponseJSON();
        try {
            responseJSON = tJdJdxxService.updateTJdJdxx(tJdJdxx);
        } catch (Exception e) {
            e.printStackTrace();
            responseJSON.setSuccess(Boolean.FALSE);
            responseJSON.setMsg("修改失败!");
        } finally {
/* 日志控制信息:日志控制不需要和业务事物同步 */
            ((BaseController) AopContext.currentProxy()).addLog(responseJSON.getT_xt_rz());
        }
        ;
        return responseJSON;
    }

    /**
     * 删除业务
     *
     * @param tJdJdxx
     * @return
     */
    @RequestMapping(value = "delTJdJdxx")
    @ResponseBody
    public ResponseJSON delLocalIspCustomer(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception {
        log.debug("。。。。。。。。。。。。。删除业务。。。。。。。。。。。。。");
        ResponseJSON responseJSON = new ResponseJSON();
        try {
            responseJSON = tJdJdxxService.delTJdJdxx(tJdJdxx);
        } catch (Exception e) {
            e.printStackTrace();
            responseJSON.setSuccess(Boolean.FALSE);
            responseJSON.setMsg("删除失败!");
        } finally {
        /* 日志控制信息:日志控制不需要和业务事物同步 */
            ((BaseController) AopContext.currentProxy()).addLog(responseJSON.getT_xt_rz());
        }
        ;
        return responseJSON;
    }

    /**
     * 初审
     *
     * @param tJdJdxx
     * @return
     */
    @RequestMapping(value = "csUpdate")
    @ResponseBody
    public ResponseJSON csUpdate(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception {
        log.debug("。。。。。。。。。。。。。初审。。。。。。。。。。。。。");
        ResponseJSON responseJSON = new ResponseJSON();
        try {
            /**
             * update状态
             */
            responseJSON = tJdJdxxService.csUpdate(tJdJdxx);
            responseJSON.setMsg("初审成功!");
        } catch (Exception e) {
            e.printStackTrace();
            responseJSON.setSuccess(Boolean.FALSE);
            responseJSON.setMsg("初审失败!");
        } finally {
        /* 日志控制信息:日志控制不需要和业务事物同步 */
            ((BaseController) AopContext.currentProxy()).addLog(responseJSON.getT_xt_rz());
        }
        ;
        return responseJSON;
    }
    /**
     * 初审
     *
     * @param tJdJdxx
     * @return
     */
    @RequestMapping(value = "fsUpdate")
    @ResponseBody
    public ResponseJSON fsUpdate(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception {
        log.debug("。。。。。。。。。。。。。复审。。。。。。。。。。。。。");
        ResponseJSON responseJSON = new ResponseJSON();
        try {
            /**
             * update状态
             */

            responseJSON = tJdJdxxService.fsUpdate(tJdJdxx);
            responseJSON.setMsg("复审成功!");
        } catch (Exception e) {
            e.printStackTrace();
            responseJSON.setSuccess(Boolean.FALSE);
            responseJSON.setMsg("复审失败!");
        } finally {
        /* 日志控制信息:日志控制不需要和业务事物同步 */
            ((BaseController) AopContext.currentProxy()).addLog(responseJSON.getT_xt_rz());
        }
        ;
        return responseJSON;
    }
    /**
     * 初审
     *
     * @param tJdJdxx
     * @return
     */
    @RequestMapping(value = "wcUpdate")
    @ResponseBody
    public ResponseJSON wcUpdate(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception {
        log.debug("。。。。。。。。。。。。。完成。。。。。。。。。。。。。");
        ResponseJSON responseJSON = new ResponseJSON();
        try {
            /**
             * update状态
             */

            responseJSON = tJdJdxxService.wcUpdate(tJdJdxx);
        } catch (Exception e) {
            e.printStackTrace();
            responseJSON.setSuccess(Boolean.FALSE);
            responseJSON.setMsg("完成失败!");
        } finally {
        /* 日志控制信息:日志控制不需要和业务事物同步 */
            ((BaseController) AopContext.currentProxy()).addLog(responseJSON.getT_xt_rz());
        }
        ;
        return responseJSON;
    }





    /**
     * 分页查询列表:待分配任务
     *
     * @param tJdJdxx
     * @return
     */
    @RequestMapping(value = "queryPageList")
    @JsonSerialize(include=JsonSerialize.Inclusion.NON_NULL)
    @ResponseBody
    public Map<String, Object> queryPageList(TJdJdxxEntity tJdJdxx, HttpServletRequest request, PageBean<TJdJdxxEntity> pageBean) throws Exception {
        log.debug("。。。。。。。。。。。。。分页查询列表。。。。。。。。。。。。。");
        ResponseJSON responseJSON = new ResponseJSON();
        try {
            Map<String, Object> paramMap = new HashMap<String, Object>();/****分页参数*****/
            if(tJdJdxx.getJdxxBzInt() == 0){
                paramMap.put("jdxxBz", JdxxBzEnum.DFPRY);
            }else if(tJdJdxx.getJdxxBzInt() == 1){
                paramMap.put("jdxxBz", JdxxBzEnum.DZDFA);
            }else if(tJdJdxx.getJdxxBzInt() == 2){
                paramMap.put("jdxxBz", JdxxBzEnum.DCS);
            }else if(tJdJdxx.getJdxxBzInt() == 3){
                paramMap.put("jdxxBz", JdxxBzEnum.DFS);
            }else if(tJdJdxx.getJdxxBzInt() == 4){
                paramMap.put("jdxxBz", JdxxBzEnum.FSWC);
            }
            responseJSON = tJdJdxxService.queryPageList(paramMap, pageBean.getPageNo(), pageBean.getPageSize());
        } catch (Exception e) {
            e.printStackTrace();
            responseJSON.setSuccess(Boolean.FALSE);
            responseJSON.setMsg("查询失败!");
        } finally {
        /* 日志控制信息:日志控制不需要和业务事物同步 */
           // ((BaseController) AopContext.currentProxy()).addLog(responseJSON.getT_xt_rz());
        };
        return responseJSON.getResult();
    }
    /**
     * 返回上一步
     *
     * @param tJdJdxx
     * @return
     */
    @RequestMapping(value = "fhsybWin")
    @ResponseBody
    public ResponseJSON fhsybWin(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception {
        log.debug("。。。。。。。。。。。。。返回上一步。。。。。。。。。。。。。");
        ResponseJSON responseJSON = new ResponseJSON();
        try {
            tJdJdxx = tJdJdxxService.findById(tJdJdxx.getId());
            Integer jdxxBz = tJdJdxx.getJdxxBz().getVal();
            if(jdxxBz == 1){
                tJdJdxx.setJdxxBz(JdxxBzEnum.DFPRY);
            }else if(jdxxBz == 2){
                tJdJdxx.setJdxxBz(JdxxBzEnum.DZDFA);
            }else if(jdxxBz == 3){
                tJdJdxx.setJdxxBz(JdxxBzEnum.DCS);
            }else if(jdxxBz == 4){
                tJdJdxx.setJdxxBz(JdxxBzEnum.DFS);
            }
            System.out.println("上一步:"+tJdJdxx.getJdxxBz().getDescription());
            responseJSON = tJdJdxxService.updateForJdxxBz(tJdJdxx);
            responseJSON.setMsg("返回成功!");
        } catch (Exception e) {
            e.printStackTrace();
            responseJSON.setSuccess(Boolean.FALSE);
            responseJSON.setMsg("失败!");
        } finally {
        /* 日志控制信息:日志控制不需要和业务事物同步 */
            ((BaseController) AopContext.currentProxy()).addLog(responseJSON.getT_xt_rz());
        }
        ;
        return responseJSON;
    }


    /**
     * 查询所有数据列表
     *
     * @param tJdJdxx
     * @return
     */
    @RequestMapping(value = "queryList")
    @ResponseBody
    public Map<String, Object> queryList(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception {
        log.debug("。。。。。。。。。。。。。查询所有数据列表。。。。。。。。。。。。。");
        ResponseJSON responseJSON = new ResponseJSON();
        try {
            Map<String, Object> paramMap = new HashMap<String, Object>();/****分页参数*****/
            responseJSON = tJdJdxxService.queryList(paramMap);
        } catch (Exception e) {
            e.printStackTrace();
            responseJSON.setSuccess(Boolean.FALSE);
            responseJSON.setMsg("查询失败!");
        } finally {
    /* 日志控制信息:日志控制不需要和业务事物同步 */
           // ((BaseController) AopContext.currentProxy()).addLog(responseJSON.getT_xt_rz());
        }
        ;
        return responseJSON.getResult();
    }
    //
    @RequestMapping("fpryOpenPlugin")
    public String fpryOpenPlugin(){
        /* 加载分配人员数据:分配人员查询 */
        List<TXtRyEntity> ryEntities = ryService.findByFpryStatus(1);
        String id = request.getParameter("id");
        model.addAttribute("id",id);
        model.addAttribute("ryEntities",ryEntities);
        //分配人员
        TJdJdxxEntity jdxxEntity = tJdJdxxService.findById(id);
        model.addAttribute("jdxxEntity",jdxxEntity);
        return jdglPrefix+"fpryOpenPlugin";
    }

    /**
     * 制定方案
     * @return
     */
    @RequestMapping("zdfaOpenPlugin")
    public String zdfaOpenPlugin(){
        String id = request.getParameter("id");
        model.addAttribute("id",id);
        //上传时间
        TJdJdxxEntity jdxxEntity = tJdJdxxService.findById(id);
        model.addAttribute("jdxxEntity",jdxxEntity);
        /* 制定方案附件 */
        List<TWjFjEntity> fjEntities = fjService.findZdfaJdxxByJdxxId(id);
        if(fjEntities != null && !fjEntities.isEmpty()){
            //制定方案附件Id和名称
            TWjFjEntity fjEntity = fjEntities.get(0);
            TWjWjEntity wjEntity = fjEntity.getWjWjEntity()!=null?fjEntity.getWjWjEntity():null;
            model.addAttribute("zdfafj_fjEntity",fjEntity);
            model.addAttribute("zdfafj_wjEntity",wjEntity);
        }
        return jdglPrefix+"zdfaOpenPlugin";
    }

    /**
     * 陪同领导界面
     * @return
     */
    @RequestMapping("ptldOpenPlugin")
    public String ptldOpenPlugin(){
        String id = request.getParameter("id");
        model.addAttribute("id",id);
        //获取陪同领导信息
        TJdJdxxEntity jdxxEntity = tJdJdxxService.findById(id);
        model.addAttribute("jdxxEntity",jdxxEntity);
        return jdglPrefix+"ptldOpenPlugin";
    }
    /**
     * 编辑接待基本信息
     * @return
     */
    @RequestMapping("editOpenPlugin")
    public String editOpenPlugin(){
        String id = request.getParameter("id");
        TJdJdxxEntity jdxxEntity = tJdJdxxService.findById(id);
        /* 【文件附件信息】:通过主控方获取数据 */
        //List<TWjFjEntity> fjEntities = fjService.findByJdxxId(id);
        //List<TWjWjEntity> wjEntities = wjService.findByJdxxId(id);
        List<TWjFjEntity> fjEntities = fjService.findByJdxxId(id);
        model.addAttribute("jdxxEntity",jdxxEntity);
        /*设置附件信息model*/
        for(int i = 0;i < fjEntities.size(); i++){
            TWjFjEntity fjEntity = fjEntities.get(i);
            TWjWjEntity wjEntity = fjEntity.getWjWjEntity();
            if(wjEntity.getOgicColumn() != null && "fgldqpj".equals(wjEntity.getOgicColumn())){
                model.addAttribute("fgldqpj_fjEntity",fjEntity);
                model.addAttribute("fgldqpj_wjEntity",wjEntity);
            }else if(wjEntity.getOgicColumn() != null && "jyfafj".equals(wjEntity.getOgicColumn())){
                model.addAttribute("jyfafj_fjEntity",fjEntity);
                model.addAttribute("jyfafj_wjEntity",wjEntity);
            }
        }
        return jdglPrefix+"editOpenPlugin";
    }


}
