package cn.hd.module.repository.service.impl;

import cn.hd.common.constant.DevContext;
import cn.hd.common.enumeration.JdxxBzEnum;
import cn.hd.common.enumeration.ModuleEnum;
import cn.hd.common.enumeration.OpTypeEnum;
import cn.hd.common.util.BasicImplDao;
import cn.hd.entity.*;
import cn.hd.module.repository.dao.TAttachConfigDao;
import cn.hd.module.repository.dao.TJdJdxxDao;
import cn.hd.module.repository.dao.TWjFjDao;
import cn.hd.module.repository.dao.TWjWjDao;
import cn.hd.module.repository.service.FileService;
import cn.hd.module.repository.service.TJdJdxxService;
import cn.hd.utils.BasicEncodeUtils;
import cn.hd.utils.DateHelper;
import cn.hd.utils.GsonUtil;
import cn.hd.utils.ResponseJSON;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;

import java.io.File;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 动态生成   接待信息表
 */
@Service("tJdJdxxService")
@Transactional(propagation = Propagation.REQUIRED, readOnly = false, rollbackFor = Exception.class)
public class TJdJdxxServiceImpl extends BasicImplDao<TJdJdxxEntity> implements TJdJdxxService {
    protected Logger log = Logger.getLogger(this.getClass().getName());
    /**
     * 注入持久层
     **/
    @Autowired
    private TJdJdxxDao tJdJdxxDao;
    @Autowired
    private TAttachConfigDao attachConfigDao;
    @Autowired
    private TWjFjDao tWjFjDao;
    @Autowired
    private TWjWjDao tWjWjDao;
    @Autowired
    private FileService fileService;

    /**
     * 保存
     *
     * @param tJdJdxx
     * @return
     * @throws Exception
     */
    @Override
    public ResponseJSON saveTJdJdxx(TJdJdxxEntity tJdJdxx,HttpServletRequest request) throws Exception {
        ResponseJSON responseJSON = new ResponseJSON();
        T_xt_rz rz = new T_xt_rz();
        tJdJdxx.setFqSj(new Date());/*发起时间*/
        //tJdJdxx.setJdxxBz(JdxxBzEnum.DFPRY);
        if(tJdJdxx.getId() != null && !"".equals(tJdJdxx.getId())){
            rz.setNr("修改一条接待信息|"+tJdJdxx.getBt());//操作详情
            rz.setLx_bz(OpTypeEnum.update);//操作类型
            tJdJdxxDao.update(tJdJdxx);
        }else{
            tJdJdxxDao.save(tJdJdxx);
            rz.setNr("创建一条接待信息|"+tJdJdxx.getBt());//操作详情
            rz.setLx_bz(OpTypeEnum.add);//操作类型
        }

        MultipartHttpServletRequest multipartRequest = null;
        try {
            multipartRequest = (MultipartHttpServletRequest) request;
            // 获得文件：
            MultiValueMap<String,MultipartFile > mr = multipartRequest.getMultiFileMap();
            /* 获取附件的路径 */
            AttachConfigEntity attachConfigEntity = attachConfigDao.getByHql("from AttachConfigEntity where 1 = 1");
            String localFilePath = DevContext.ATTACH_FILE;
            if(attachConfigEntity != null){
                localFilePath = attachConfigEntity.getFilePath();
            }
        /* 通过主键获取文件名称。然后删除文件 */
            StringBuffer sb = new StringBuffer();
            sb.append("from TWjWjEntity t where t.logicTablename = :logicTablename and t.relationalValue = :relationalValue");
            Map<String,Object> wjParams = new HashMap<String,Object>();
            wjParams.put("relationalValue",tJdJdxx.getId());
            wjParams.put("logicTablename","T_JD_JDXX");
            List<TWjWjEntity> wjWjEntities = tWjWjDao.find(sb.toString(),wjParams);
        /* 这里需要先删除文件 */
            if(wjWjEntities != null && !wjWjEntities.isEmpty()){
                for(TWjWjEntity wjEntity : wjWjEntities){
                    File file = new File(localFilePath);
                    if(file.exists()){
                        //fileName
                        //创建的文件名称是:文件名称任意
                        String outFilePath = file.getPath()+File.separator+wjEntity.getUuidMc();
                        System.out.println("删除旧文件："+outFilePath);
                        File deleteFile = new File(outFilePath);
                        if(deleteFile.exists()){
                            deleteFile.delete();
                        }
                    }

                }
            }
            for(String fileKey : mr.keySet()){
                MultipartFile file= mr.getFirst(fileKey);
                // 原始文件名
                String originalFileName = file.getOriginalFilename();
                if(originalFileName != null && !"".equals(originalFileName)){
                    //文件的二进制
                    byte[] fileBytes = file.getBytes();
                    /* 上传附件的路径 */
                    /**
                     *1：随机文件名称:年月日小时分毫秒
                     *2：
                     */
                    Long size = file.getSize();//文件大小
                    String extendName = originalFileName.substring(originalFileName.lastIndexOf(".")+1);//文件后缀名称
                    String md5 = BasicEncodeUtils.getMD5(fileBytes);/* MD5值 */
                    String SHA1 = BasicEncodeUtils.getSHA1(md5);//SHA1
                    /*********      文件     *************/
                    TWjWjEntity wjEntity = new TWjWjEntity();
                    wjEntity.setUuidMc(DateHelper.getNowPlusTimeMill()+"."+extendName);
                    wjEntity.setDx(size);
                    wjEntity.setMd5(md5);
                    wjEntity.setSha1(SHA1);
                    wjEntity.setCjSj(new Date());
                    wjEntity.setLogicTablename("T_JD_JDXX");//LOGIC_TABLENAME
                    wjEntity.setOgicColumn(fileKey);//逻辑列名称
                    wjEntity.setRelationalValue(tJdJdxx.getId());//RELATIONAL_VALUE
                    tWjWjDao.saveOrUpdate(wjEntity);
                    /*  先保存附件。 */
                    TWjFjEntity wjFjEntity = new TWjFjEntity();
                    wjFjEntity.setMc(originalFileName);
                    wjFjEntity.setMkBz(ModuleEnum.xzjdModule);
                    wjFjEntity.setMj(1);
                    String bz = "建议方案附件";
                    if("fgldqpj".equalsIgnoreCase(fileKey)){
                        bz = "分管领导签批件";
                    }
                    wjFjEntity.setBz(bz);
                    wjFjEntity.setCjSj(new Date());
                    wjFjEntity.setCjrId(tJdJdxx.getRyEntity().getId());
                    wjFjEntity.setWjWjEntity(wjEntity);
                    tWjFjDao.saveOrUpdate(wjFjEntity);
                    /*创建相应的文件到指定的目录*/
                    //直接保存到本机服务器
                    String outFilePath = fileService.pushSystemUploadFile(file.getInputStream(), wjEntity.getUuidMc(),localFilePath);
                    if(outFilePath != null){
                        System.out.println("保存成功:!!!!!!!!");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {

            /** 日志记录信息* */
            /********** 根据业务不同设置相应的参数值 ***********/

            rz.setMk_bz(ModuleEnum.xzjdModule);//模块[需要手动修改]
            rz.setSj_id(String.valueOf(ModuleEnum.xzjdModule.getVal()));//模块ID[需要手动修改]

            rz.setCj_sj(new Date());//创建时间
            /*********** 需要从前端传递start ************/
            rz.setCjr_fid("创建人ID");//创建人单位ID
            rz.setCjr_id("创建人ID");//创建人ID
            /*********** 需要从前端传递 end ************/
            responseJSON.setT_xt_rz(rz);
            responseJSON.setMsg("保存成功!");
        } catch (Exception e) {
            log.debug("日志报错...............:" + e.getMessage());
        }
        Map<String,Object> resMap =new HashMap<String,Object>();
        resMap.put("tJdJdxx",tJdJdxx);
        responseJSON.setResult(resMap);
        return responseJSON;
    }

    /**
     * 修改
     *
     * @param tJdJdxx
     * @return
     * @throws Exception
     */
    @Override
    public ResponseJSON updateTJdJdxx(TJdJdxxEntity tJdJdxx) throws Exception {
        ResponseJSON responseJSON = new ResponseJSON();
        /*主要获取相应的分配时间和分配人员*/
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("id",tJdJdxx.getId());
        params.put("fpcbrSj",tJdJdxx.getFpcbrSj());
        params.put("cbrId",tJdJdxx.getCbrId());
        params.put("cbrName",tJdJdxx.getCbrName());
        params.put("cbdwId",tJdJdxx.getCbdwId());
        params.put("jdxxBz",tJdJdxx.getJdxxBz());

        tJdJdxxDao.executeHql("update TJdJdxxEntity t set t.fpcbrSj = :fpcbrSj , t.cbrId = :cbrId , t.cbrName = :cbrName , t.cbdwId = :cbdwId,t.jdxxBz = :jdxxBz where t.id = :id",params);

        try {
            T_xt_rz rz = new T_xt_rz();
            /** 日志记录信息* */
            /********** 根据业务不同设置相应的参数值 ***********/
            rz.setNr("增加分配人员");//操作详情
            rz.setMk_bz(ModuleEnum.dfpModule);//模块[需要手动修改]
            rz.setSj_id(String.valueOf(ModuleEnum.dfpModule.getVal()));//模块ID[需要手动修改]
            rz.setLx_bz(OpTypeEnum.update);//操作类型
            rz.setBz("修改操作");//日志备注
            rz.setCj_sj(new Date());//创建时间
            /*********** 需要从前端传递start ************/
            rz.setCjr_fid("创建人单位ID");//创建人单位ID
            rz.setCjr_id("创建人ID");//创建人ID
            /*********** 需要从前端传递 end ************/
            responseJSON.setMsg("修改成功");
            responseJSON.setT_xt_rz(rz);
        } catch (Exception e) {
            log.debug("日志报错...............:" + e.getMessage());
        }
        return responseJSON;
    }

    /**
     * 删除
     *
     * @param tJdJdxx
     * @return
     * @throws Exception
     */
    @Override
    public ResponseJSON delTJdJdxx(TJdJdxxEntity tJdJdxx) throws Exception {
        ResponseJSON responseJSON = new ResponseJSON();
         Map<String,Object> params = new HashMap<String,Object>();
         params.put("id",tJdJdxx.getId());
        tJdJdxxDao.executeHql("delete from TJdJdxxEntity t where t.id = :id",params);
        /**
         * 删除文件
         */
        /* 获取附件的路径 */
        AttachConfigEntity attachConfigEntity = attachConfigDao.getByHql("from AttachConfigEntity where 1 = 1");
        String localFilePath = DevContext.ATTACH_FILE;
        if(attachConfigEntity != null){
            localFilePath = attachConfigEntity.getFilePath();
        }
        /* 通过主键获取文件名称。然后删除文件 */
        StringBuffer sb = new StringBuffer();
        sb.append("from TWjWjEntity t where t.logicTablename = :logicTablename and t.relationalValue = :relationalValue and (t.ogicColumn = 'fgldqpj' or t.ogicColumn = 'jyfafj') ");
        Map<String,Object> wjParams = new HashMap<String,Object>();
        wjParams.put("relationalValue",tJdJdxx.getId());
        wjParams.put("logicTablename","T_JD_JDXX");
        List<TWjWjEntity> wjWjEntities = tWjWjDao.find(sb.toString(),wjParams);
        /* 这里需要先删除文件 */
        if(wjWjEntities != null && !wjWjEntities.isEmpty()){
            for(TWjWjEntity wjEntity : wjWjEntities){
                File file = new File(localFilePath);
                if(file.exists()){
                    //fileName
                    //创建的文件名称是:文件名称任意
                    String outFilePath = file.getPath()+File.separator+wjEntity.getUuidMc();
                    System.out.println("删除旧文件："+outFilePath);
                    File deleteFile = new File(outFilePath);
                    if(deleteFile.exists()){
                        deleteFile.delete();
                    }
                }

            }
        }
        try {
            T_xt_rz rz = new T_xt_rz();
            /** 日志记录信息* */
            /********** 根据业务不同设置相应的参数值 ***********/
            rz.setNr("删除待分配记录");//操作详情
            rz.setMk_bz(ModuleEnum.dfpmkModule);//模块[需要手动修改]
            rz.setSj_id(String.valueOf(ModuleEnum.dfpmkModule.getVal()));//模块ID[需要手动修改]
            rz.setLx_bz(OpTypeEnum.delete);//操作类型
            rz.setBz("删除操作");//日志备注
            rz.setCj_sj(new Date());//创建时间
            /*********** 需要从前端传递start ************/
            rz.setCjr_fid("创建人单位ID");//创建人单位ID
            rz.setCjr_id("创建人ID");//创建人ID
            /*********** 需要从前端传递 end ************/
            responseJSON.setMsg("删除成功");
            responseJSON.setT_xt_rz(rz);
        } catch (Exception e) {
            log.debug("日志报错...............:" + e.getMessage());
        }
        return responseJSON;
    }

    /**
     * 分页查询
     *
     * @param paramMap 传递的参数
     * @param page     页号
     * @param rows     条数
     * @return
     */
    @Override
    public ResponseJSON queryPageList(Map<String, Object> paramMap, int page, int rows) {
        ResponseJSON responseJSON = new ResponseJSON();
        Map result = new HashMap();
        StringBuffer countHql = new StringBuffer();/*手动填写总数:jdxxBz*/
        countHql.append("select count(*) from TJdJdxxEntity where jdxxBz = :jdxxBz");
        StringBuffer rowsHql = new StringBuffer();/*手动填写分页记录*/
        result.put("total", tJdJdxxDao.count(countHql.toString(), paramMap));
        Map<String,Object> param = new HashMap<String,Object>();
        rowsHql.append("from TJdJdxxEntity where jdxxBz = :jdxxBz");
        result.put("rows", tJdJdxxDao.find(rowsHql.toString(), paramMap, page, rows));
        responseJSON.setResult(result);
        responseJSON.setMsg("查询成功");
        /*try {
            log.debug("日志记录...............");
            T_xt_rz rz = new T_xt_rz();
            *//** 日志记录信息* *//*
            *//********** 根据业务不同设置相应的参数值 ***********//*
            rz.setNr("模块[xxxx],查询所有的数据,查询条件:" + ((paramMap == null || paramMap.isEmpty()) ? "无" : GsonUtil.object2Json(paramMap)));//操作详情
            rz.setMk_bz(ModuleEnum.orgModule);//模块[需要手动修改]
            rz.setSj_id(String.valueOf(ModuleEnum.orgModule.getVal()));//模块ID[需要手动修改]
            rz.setLx_bz(OpTypeEnum.query);//操作类型
            rz.setBz("分页查询,当前的页数和条数分别是:[" + page + "," + rows + "]");//日志备注
            rz.setCj_sj(new Date());//创建时间
            *//*********** 需要从前端传递start ************//*
            rz.setCjr_fid("创建人单位ID");//创建人单位ID
            rz.setCjr_id("创建人ID");//创建人ID
            *//*********** 需要从前端传递 end ************//*
            responseJSON.setT_xt_rz(rz);
        } catch (Exception e) {
            log.debug("日志报错...............:" + e.getMessage());
        }*/

        return responseJSON;
    }

    /**
     * 查询所有的数据
     *
     * @param paramMap 传递的参数
     * @return
     */
    @Override
    public ResponseJSON queryList(Map<String, Object> paramMap) {
        ResponseJSON responseJSON = new ResponseJSON();
        StringBuffer hql = new StringBuffer();
        hql.append("from TJdJdxx t1");
        List<TJdJdxxEntity> list = tJdJdxxDao.find(hql.toString(), paramMap);

        Map<String,Object> resMap = new HashMap<String,Object>();
        resMap.put("rows",list);
        responseJSON.setResult(resMap);
        responseJSON.setMsg("查询成功");
        try {
            log.debug("日志记录...............");
            T_xt_rz rz = new T_xt_rz();
/** 日志记录信息* */
/********** 根据业务不同设置相应的参数值 ***********/
            rz.setNr("模块[xxxx],查询所有的数据,查询条件:" + ((paramMap == null || paramMap.isEmpty()) ? "无" : GsonUtil.object2Json(paramMap)));//操作详情
            rz.setMk_bz(ModuleEnum.orgModule);//模块[需要手动修改]
            rz.setSj_id(String.valueOf(ModuleEnum.orgModule.getVal()));//模块ID[需要手动修改]
            rz.setLx_bz(OpTypeEnum.query);//操作类型
            rz.setBz("查询所有的数据");
            rz.setCj_sj(new Date());//创建时间
/*********** 需要从前端传递start ************/
            rz.setCjr_fid("创建人单位ID");//创建人单位ID
            rz.setCjr_id("创建人ID");//创建人ID
/*********** 需要从前端传递 end ************/
            responseJSON.setT_xt_rz(rz);
        } catch (Exception e) {
            log.debug("日志报错...............:" + e.getMessage());
        }
        return responseJSON;
    }

    @Override
    public Boolean isExistsByBt(TJdJdxxEntity jdJdxxEntity) {
        String id = jdJdxxEntity.getId();
        String bt = jdJdxxEntity.getBt();
        StringBuffer hql = new StringBuffer();
        Map<String,Object> param = new HashMap<String,Object>();

        hql.append("from TJdJdxxEntity t where 1=1 ");
        if( id != null && !"".equals(id) ){
            hql.append("and t.id <> :id ");
            param.put("id", id);
        }
        if(bt != null && !"".equals(bt)){
            hql.append("and t.bt = :bt ");
            param.put("bt", bt);
            List<TJdJdxxEntity> list = tJdJdxxDao.find(hql.toString(),param);
            if(list != null && !list.isEmpty()){
                return true;
            }
        }
        return false;

    }

    @Override
    public TJdJdxxEntity findById(String id) {
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("id",id);
        return tJdJdxxDao.getByHql("from TJdJdxxEntity t where t.id = :id",params);
    }

    @Override
    public ResponseJSON updateTJdJdxxPtld(TJdJdxxEntity tJdJdxx) throws Exception {
        ResponseJSON responseJSON = new ResponseJSON();
        /*主要获取相应的分配时间和分配人员*/
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("id",tJdJdxx.getId());
        params.put("ptldId",tJdJdxx.getPtldId());
        params.put("ptldMc",tJdJdxx.getPtldMc());
        tJdJdxxDao.executeHql("update TJdJdxxEntity t set t.ptldId = :ptldId , t.ptldMc = :ptldMc where t.id = :id",params);
        try {
            T_xt_rz rz = new T_xt_rz();
            /** 日志记录信息* */
            /********** 根据业务不同设置相应的参数值 ***********/
            rz.setNr("增加陪同领导");//操作详情
            rz.setMk_bz(ModuleEnum.ptldModule);//模块[需要手动修改]
            rz.setSj_id(String.valueOf(ModuleEnum.ptldModule.getVal()));//模块ID[需要手动修改]
            rz.setLx_bz(OpTypeEnum.update);//操作类型
            rz.setBz("增加陪同领导");//日志备注
            rz.setCj_sj(new Date());//创建时间
            /*********** 需要从前端传递start ************/
            rz.setCjr_fid("创建人单位ID");//创建人单位ID
            rz.setCjr_id("创建人ID");//创建人ID
            /*********** 需要从前端传递 end ************/
            responseJSON.setMsg("修改成功");
            responseJSON.setT_xt_rz(rz);
        } catch (Exception e) {
            log.debug("日志报错...............:" + e.getMessage());
        }
        return responseJSON;
    }

    @Override
    public ResponseJSON updateTJdJdxxZdfn(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception{
        ResponseJSON responseJSON = new ResponseJSON();
        tJdJdxx.setFqSj(new Date());/*发起时间*/
        tJdJdxx.setJdxxBz(JdxxBzEnum.DCS);
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("zdfaSj",tJdJdxx.getZdfaSj());
        params.put("jdxxBz",tJdJdxx.getJdxxBz());
        params.put("id",tJdJdxx.getId());
        tJdJdxxDao.executeHql("update TJdJdxxEntity t set t.zdfaSj=:zdfaSj,t.jdxxBz=:jdxxBz where id = :id",params);

        MultipartHttpServletRequest multipartRequest = null;
        try {
            multipartRequest = (MultipartHttpServletRequest) request;
            // 获得文件：
            MultiValueMap<String,MultipartFile > mr = multipartRequest.getMultiFileMap();
            /* 获取附件的路径 */
            AttachConfigEntity attachConfigEntity = attachConfigDao.getByHql("from AttachConfigEntity where 1 = 1");
            String localFilePath = DevContext.ATTACH_FILE;
            if(attachConfigEntity != null){
                localFilePath = attachConfigEntity.getFilePath();
            }
            /* 通过主键获取文件名称。然后删除文件 */
            StringBuffer sb = new StringBuffer();
            sb.append("from TWjWjEntity t where t.logicTablename = :logicTablename and t.relationalValue = :relationalValue and t.ogicColumn= :ogicColumn");
            Map<String,Object> wjParams = new HashMap<String,Object>();
            wjParams.put("relationalValue",tJdJdxx.getId());
            wjParams.put("logicTablename","T_JD_JDXX");
            wjParams.put("ogicColumn","zdfafj");
            List<TWjWjEntity> wjWjEntities = tWjWjDao.find(sb.toString(),wjParams);
            /* 这里需要先删除文件 */
            if(wjWjEntities != null && !wjWjEntities.isEmpty()){
                for(TWjWjEntity wjEntity : wjWjEntities){
                    File file = new File(localFilePath);
                    if(file.exists()){
                        //fileName
                        //创建的文件名称是:文件名称任意
                        String outFilePath = file.getPath()+File.separator+wjEntity.getUuidMc();
                        System.out.println("删除旧文件："+outFilePath);
                        File deleteFile = new File(outFilePath);
                        if(deleteFile.exists()){
                            deleteFile.delete();
                        }
                    }

                }
            }
            //删除接待信息的制定方案
            Map<String,Object> deleteWjParams = new HashMap<String,Object>();
            deleteWjParams.put("relationalValue",tJdJdxx.getId());
            //获取所有的数据然后先删除字表信息
            List<TWjWjEntity> wjEntities = tWjWjDao.find("from TWjWjEntity t where t.logicTablename='T_JD_JDXX' and t.relationalValue=:relationalValue and t.ogicColumn='zdfafj'",deleteWjParams);
            if(wjEntities != null && !wjEntities.isEmpty()){
                for(int i = 0 ;i < wjEntities.size(); i++){
                    TWjWjEntity wjWjEntity = wjEntities.get(i);
                    //先删除字表
                    Map<String,Object> fjParams = new HashMap<String,Object>();
                    fjParams.put("wjId",wjWjEntity.getId());
                    tWjFjDao.executeSql("delete from T_WJ_FJ t where t.wj_id=:wjId",fjParams);
                    tWjWjDao.executeSql("delete from T_WJ_WJ t where t.id=:wjId",fjParams);
                }
            }


           // tWjWjDao.executeHql("delete from TWjWjEntity t where t.logicTablename='T_JD_JDXX' and t.relationalValue=:relationalValue and t.ogicColumn='zdfafj'",deleteWjParams);

            for(String fileKey : mr.keySet()){
                MultipartFile file= mr.getFirst(fileKey);
                // 原始文件名
                String originalFileName = file.getOriginalFilename();
                if(originalFileName != null && !"".equals(originalFileName)){
                    //文件的二进制
                    byte[] fileBytes = file.getBytes();
                    /* 上传附件的路径 */
                    /**
                     *1：随机文件名称:年月日小时分毫秒
                     *2：
                     */
                    Long size = file.getSize();//文件大小
                    String extendName = originalFileName.substring(originalFileName.lastIndexOf(".")+1);//文件后缀名称
                    String md5 = BasicEncodeUtils.getMD5(fileBytes);/* MD5值 */
                    String SHA1 = BasicEncodeUtils.getSHA1(md5);//SHA1
                    /*********      文件     *************/
                    TWjWjEntity wjEntity = new TWjWjEntity();
                    wjEntity.setUuidMc(DateHelper.getNowPlusTimeMill()+"."+extendName);
                    wjEntity.setDx(size);
                    wjEntity.setMd5(md5);
                    wjEntity.setSha1(SHA1);
                    wjEntity.setCjSj(new Date());
                    wjEntity.setLogicTablename("T_JD_JDXX");//LOGIC_TABLENAME
                    wjEntity.setOgicColumn(fileKey);//逻辑列名称
                    wjEntity.setRelationalValue(tJdJdxx.getId());//RELATIONAL_VALUE
                    tWjWjDao.saveOrUpdate(wjEntity);
                    /*  先保存附件。 */
                    TWjFjEntity wjFjEntity = new TWjFjEntity();
                    wjFjEntity.setMc(originalFileName);
                    wjFjEntity.setMkBz(ModuleEnum.dzdfnModule);
                    wjFjEntity.setMj(1);
                    String bz = "接待方案";
                    wjFjEntity.setBz(bz);
                    wjFjEntity.setCjSj(new Date());
                    //wjFjEntity.setCjrId(tJdJdxx.getRyEntity().getId());
                    wjFjEntity.setCjrId("创建人ID");
                    wjFjEntity.setWjWjEntity(wjEntity);
                    tWjFjDao.saveOrUpdate(wjFjEntity);
                    /*创建相应的文件到指定的目录*/
                    //直接保存到本机服务器
                    String outFilePath = fileService.pushSystemUploadFile(file.getInputStream(), wjEntity.getUuidMc(),localFilePath);
                    if(outFilePath != null){
                        System.out.println("保存成功:!!!!!!!!");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            T_xt_rz rz = new T_xt_rz();
            /** 日志记录信息* */
            /********** 根据业务不同设置相应的参数值 ***********/
            rz.setNr("制定方案!");//操作详情
            rz.setMk_bz(ModuleEnum.dcsModule);//模块[需要手动修改]
            rz.setSj_id(String.valueOf(ModuleEnum.dcsModule.getVal()));//模块ID[需要手动修改]
            rz.setLx_bz(OpTypeEnum.update);//操作类型
            rz.setBz("制定方案!");//日志备注
            rz.setCj_sj(new Date());//创建时间
            /*********** 需要从前端传递start ************/
            rz.setCjr_fid(tJdJdxx.getLrdwEntity().getId());//创建人单位ID
            rz.setCjr_id(tJdJdxx.getRyEntity().getId());//创建人ID
            /*********** 需要从前端传递 end ************/
            responseJSON.setT_xt_rz(rz);
            responseJSON.setMsg("保存成功!");
        } catch (Exception e) {
            log.debug("日志报错...............:" + e.getMessage());
        }
        Map<String,Object> resMap =new HashMap<String,Object>();
        resMap.put("tJdJdxx",tJdJdxx);
        responseJSON.setResult(resMap);
        return responseJSON;
    }

    @Override
    public ResponseJSON csUpdate(TJdJdxxEntity tJdJdxx) throws Exception{
        ResponseJSON responseJSON = new ResponseJSON();
        tJdJdxx.setFqSj(new Date());/*发起时间*/
        tJdJdxx.setJdxxBz(JdxxBzEnum.DFS);
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("id",tJdJdxx.getId());
        params.put("jdxxBz",tJdJdxx.getJdxxBz());
        tJdJdxxDao.executeHql("update TJdJdxxEntity t set t.jdxxBz=:jdxxBz where id = :id",params);
        try {
            T_xt_rz rz = new T_xt_rz();
            /** 日志记录信息* */
            /********** 根据业务不同设置相应的参数值 ***********/
            rz.setNr("初审成功待复审");//操作详情
            rz.setMk_bz(ModuleEnum.dfsModule);//模块[需要手动修改]
            rz.setSj_id(String.valueOf(ModuleEnum.dfsModule.getVal()));//模块ID[需要手动修改]
            rz.setLx_bz(OpTypeEnum.update);//操作类型
            rz.setBz("初审成功待复审");//日志备注
            rz.setCj_sj(new Date());//创建时间
            /*********** 需要从前端传递start ************/
            rz.setCjr_fid(tJdJdxx.getLrdwEntity().getId());//创建人单位ID
            rz.setCjr_id(tJdJdxx.getRyEntity().getId());//创建人ID
            /*********** 需要从前端传递 end ************/
            responseJSON.setT_xt_rz(rz);
            responseJSON.setMsg("保存成功!");
        } catch (Exception e) {
            log.debug("日志报错...............:" + e.getMessage());
        }
        Map<String,Object> resMap =new HashMap<String,Object>();
        resMap.put("tJdJdxx",tJdJdxx);
        responseJSON.setResult(resMap);
        return responseJSON;
    }

    @Override
    public ResponseJSON fsUpdate(TJdJdxxEntity tJdJdxx) throws Exception{
        ResponseJSON responseJSON = new ResponseJSON();
        tJdJdxx.setFqSj(new Date());/*发起时间*/
        tJdJdxx.setJdxxBz(JdxxBzEnum.FSWC);
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("id",tJdJdxx.getId());
        params.put("jdxxBz",tJdJdxx.getJdxxBz());
        tJdJdxxDao.executeHql("update TJdJdxxEntity t set t.jdxxBz=:jdxxBz where id = :id",params);
        try {
            T_xt_rz rz = new T_xt_rz();
            /** 日志记录信息* */
            /********** 根据业务不同设置相应的参数值 ***********/
            rz.setNr("复审完成!");//操作详情
            rz.setMk_bz(ModuleEnum.ywcModule);//模块[需要手动修改]
            rz.setSj_id(String.valueOf(ModuleEnum.ywcModule.getVal()));//模块ID[需要手动修改]
            rz.setLx_bz(OpTypeEnum.add);//操作类型
            rz.setBz("复审完成!");//日志备注
            rz.setCj_sj(new Date());//创建时间
            /*********** 需要从前端传递start ************/
            rz.setCjr_fid(tJdJdxx.getLrdwEntity().getId());//创建人单位ID
            rz.setCjr_id(tJdJdxx.getRyEntity().getId());//创建人ID
            /*********** 需要从前端传递 end ************/
            responseJSON.setT_xt_rz(rz);
            responseJSON.setMsg("保存成功!");
        } catch (Exception e) {
            log.debug("日志报错...............:" + e.getMessage());
        }
        Map<String,Object> resMap =new HashMap<String,Object>();
        resMap.put("tJdJdxx",tJdJdxx);
        responseJSON.setResult(resMap);
        return responseJSON;
    }

    @Override
    public ResponseJSON wcUpdate(TJdJdxxEntity tJdJdxx) throws Exception {
        ResponseJSON responseJSON = new ResponseJSON();
        tJdJdxx.setFqSj(new Date());/*发起时间*/
        tJdJdxx.setJdxxBz(JdxxBzEnum.FSWC);
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("id",tJdJdxx.getId());
        params.put("jdxxBz",tJdJdxx.getJdxxBz());
        tJdJdxxDao.executeHql("update TJdJdxxEntity t set t.jdxxBz=:jdxxBz where id = :id",params);
        try {
            T_xt_rz rz = new T_xt_rz();
            /** 日志记录信息* */
            /********** 根据业务不同设置相应的参数值 ***********/
            rz.setNr("复审完成");//操作详情
            rz.setMk_bz(ModuleEnum.ywcModule);//模块[需要手动修改]
            rz.setSj_id(String.valueOf(ModuleEnum.ywcModule.getVal()));//模块ID[需要手动修改]
            rz.setLx_bz(OpTypeEnum.update);//操作类型
            rz.setBz("复审完成");//日志备注
            rz.setCj_sj(new Date());//创建时间
            /*********** 需要从前端传递start ************/
            rz.setCjr_fid(tJdJdxx.getLrdwEntity().getId());//创建人单位ID
            rz.setCjr_id(tJdJdxx.getRyEntity().getId());//创建人ID
            /*********** 需要从前端传递 end ************/
            responseJSON.setT_xt_rz(rz);
            responseJSON.setMsg("保存成功!");
        } catch (Exception e) {
            log.debug("日志报错...............:" + e.getMessage());
        }
        Map<String,Object> resMap =new HashMap<String,Object>();
        resMap.put("tJdJdxx",tJdJdxx);
        responseJSON.setResult(resMap);
        return responseJSON;
    }

    @Override
    public ResponseJSON updateForJdxxBz(TJdJdxxEntity tJdJdxx) throws Exception {
        ResponseJSON responseJSON = new ResponseJSON();
        Map<String,Object> params = new HashMap<String,Object>();
        params.put("id",tJdJdxx.getId());
        params.put("jdxxBz",tJdJdxx.getJdxxBz());
        /* 返回上一步的时候需要清除上一步的相关数据 */
        StringBuffer sbtmp = new StringBuffer("update TJdJdxxEntity t set t.jdxxBz=:jdxxBz");
        if(tJdJdxx.getJdxxBz().getVal() == 1){
        	/* 返回制定方案，则需要清除制定方案相关数据   zdfaSj  和 删除 附件信息 */
        	sbtmp.append("	,ZDFA_SJ = null");
        	sbtmp.append(" where t.id = :id");
        	/* 同时需要删除附件信息 */
        	//还是需要删除旧的附件信息  ---  还需要删除文件
        	/* 获取附件的路径 */
            AttachConfigEntity attachConfigEntity = attachConfigDao.getByHql("from AttachConfigEntity where 1 = 1");
            String localFilePath = DevContext.ATTACH_FILE;
            if(attachConfigEntity != null){
                localFilePath = attachConfigEntity.getFilePath();
            }
            
            /* 通过主键获取文件名称。然后删除文件 */
            StringBuffer sb = new StringBuffer();
            sb.append("from TWjWjEntity t where t.logicTablename = :logicTablename and t.relationalValue = :relationalValue");
            Map<String,Object> wjParams = new HashMap<String,Object>();
            wjParams.put("relationalValue",tJdJdxx.getId());
            wjParams.put("logicTablename","T_JD_JDXX");
            List<TWjWjEntity> wjWjEntities = tWjWjDao.find(sb.toString(),wjParams);
            /* 这里需要先删除文件 */
            if(wjWjEntities != null && !wjWjEntities.isEmpty()){
                for(TWjWjEntity wjEntity : wjWjEntities){
                    File file = new File(localFilePath);
                    if(file.exists()){
                        //fileName
                        //创建的文件名称是:文件名称任意
                        String outFilePath = file.getPath()+File.separator+wjEntity.getUuidMc();
                        System.out.println("删除旧文件："+outFilePath);
                        File deleteFile = new File(outFilePath);
                        if(deleteFile.exists()){
                            deleteFile.delete();
                        }
                    }

                }
            }
            
            Map<String,Object> deleteWjParams = new HashMap<String,Object>();
            deleteWjParams.put("relationalValue",tJdJdxx.getId());
            //获取所有的数据然后先删除字表信息
            List<TWjWjEntity> wjEntities = tWjWjDao.find("from TWjWjEntity t where t.logicTablename='T_JD_JDXX' and t.relationalValue=:relationalValue and (t.ogicColumn='zdfafj')",deleteWjParams);
            if(wjEntities != null && !wjEntities.isEmpty()){
                for(int i = 0 ;i < wjEntities.size(); i++){
                    TWjWjEntity wjWjEntity = wjEntities.get(i);
                    //先删除字表
                    Map<String,Object> fjParams = new HashMap<String,Object>();
                    fjParams.put("wjId",wjWjEntity.getId());
                    tWjFjDao.executeSql("delete from T_WJ_FJ t where t.wj_id=:wjId",fjParams);
                    tWjWjDao.executeSql("delete from T_WJ_WJ t where t.id=:wjId",fjParams);
                }
            }
        }else if(tJdJdxx.getJdxxBz().getVal() == 0){
        	/** 返回分配人员信息 **/
        	sbtmp.append("	,FPCBR_SJ = null,CBR_ID=null,CBR_NAME=null ");
        	sbtmp.append(" where t.id = :id");
        }else if(tJdJdxx.getJdxxBz().getVal() == 2){
        	/** 返回待初审 清空陪同人员 **/
        	sbtmp.append("	,PTLD_MC = null,PTLD_ID=null ");
        	sbtmp.append(" where t.id = :id");
        	
        }else {
        	sbtmp.append(" where t.id = :id");
        }
        
       // tJdJdxxDao.executeHql("update TJdJdxxEntity t set t.jdxxBz=:jdxxBz where t.id = :id",params);
        tJdJdxxDao.executeHql(sbtmp.toString(),params);
        try {
            T_xt_rz rz = new T_xt_rz();
            /** 日志记录信息* */
            /********** 根据业务不同设置相应的参数值 ***********/
            rz.setNr("返回成功!");//操作详情
            rz.setMk_bz(ModuleEnum.rwfhModule);//模块[需要手动修改]
            rz.setSj_id(String.valueOf(ModuleEnum.rwfhModule.getVal()));//模块ID[需要手动修改]
            rz.setLx_bz(OpTypeEnum.update);//操作类型
            rz.setBz("返回成功!");//日志备注
            rz.setCj_sj(new Date());//创建时间
            /*********** 需要从前端传递start ************/
            rz.setCjr_fid(tJdJdxx.getLrdwEntity().getId());//创建人单位ID
            rz.setCjr_id(tJdJdxx.getRyEntity().getId());//创建人ID
            /*********** 需要从前端传递 end ************/
            responseJSON.setT_xt_rz(rz);
            responseJSON.setMsg("返回成功!");
        } catch (Exception e) {
            log.debug("日志报错...............:" + e.getMessage());
        }
        Map<String,Object> resMap =new HashMap<String,Object>();
        resMap.put("tJdJdxx",tJdJdxx);
        responseJSON.setResult(resMap);
        return responseJSON;
    }


}