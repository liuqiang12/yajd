package cn.hd.module.repository.service;

import cn.hd.entity.TJdJdxxEntity;
import cn.hd.utils.ResponseJSON;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 动态生成   接待信息表
 */
public interface TJdJdxxService {
    /********************************[基本的操作方法]   start****************************/
    /**
     * 保存
     *
     * @param tJdJdxx
     * @return
     * @throws Exception
     */
    ResponseJSON saveTJdJdxx(TJdJdxxEntity tJdJdxx, HttpServletRequest request) throws Exception;

    /**
     * 修改
     *
     * @param tJdJdxx
     * @return
     * @throws Exception
     */
    ResponseJSON updateTJdJdxx(TJdJdxxEntity tJdJdxx) throws Exception;


    /**
     * 删除
     *
     * @param tJdJdxx
     * @return
     * @throws Exception
     */
    ResponseJSON delTJdJdxx(TJdJdxxEntity tJdJdxx) throws Exception;

    /**
     * 分页查询
     *
     * @param paramMap 传递的参数
     * @param page     页号
     * @param rows     条数
     * @return
     */
    ResponseJSON queryPageList(Map<String, Object> paramMap, int page, int rows);

    /**
     * 查询所有的数据
     *
     * @param paramMap 传递的参数
     * @return
     */
    ResponseJSON queryList(Map<String, Object> paramMap);
    /********************************[基本的操作方法]   end****************************/
    /**
     * 通过标题判断是否已经存在相应的标题了
     * @param jdJdxxEntity
     * @return
     */
    Boolean isExistsByBt(TJdJdxxEntity jdJdxxEntity);

    /**
     * 找到对应的实体类
     * @param id
     * @return
     */
    TJdJdxxEntity findById(String id);
    /**
     * 修改陪同领导情况
     *
     * @param tJdJdxx
     * @return
     * @throws Exception
     */
    ResponseJSON updateTJdJdxxPtld(TJdJdxxEntity tJdJdxx) throws Exception;

    /**
     * 制定方案
     * @param tJdJdxx
     * @param request
     * @return
     */
    ResponseJSON updateTJdJdxxZdfn(TJdJdxxEntity tJdJdxx,HttpServletRequest request)  throws Exception;

    /**
     * 初审     *
     * @param tJdJdxx
     * @return
     */
    ResponseJSON csUpdate(TJdJdxxEntity tJdJdxx) throws Exception;
    /**
     * 复审     *
     * @param tJdJdxx
     * @return
     */
    ResponseJSON fsUpdate(TJdJdxxEntity tJdJdxx) throws Exception;
    /**
     * 完成     *
     * @param tJdJdxx
     * @return
     */
    ResponseJSON wcUpdate(TJdJdxxEntity tJdJdxx) throws Exception;

    /**
     * 返回上一步
     * @param tJdJdxx
     * @return
     * @throws Exception
     */
    ResponseJSON updateForJdxxBz(TJdJdxxEntity tJdJdxx) throws Exception;
}