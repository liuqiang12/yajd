package cn.hd.module.repository.dao.impl;


import cn.hd.common.util.BasicImplDao;
import cn.hd.entity.TJdJdxxEntity;
import cn.hd.module.repository.dao.TJdJdxxDao;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

/**
* 动态生成持久层  接待信息表
*/
@Repository
@Qualifier("tJdJdxxDao")
public class TJdJdxxDaoImpl extends BasicImplDao<TJdJdxxEntity> implements TJdJdxxDao {

}