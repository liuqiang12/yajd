package cn.hd.entity;

import cn.hd.common.enumeration.EnumDescriptionUserType;
import cn.hd.common.enumeration.GenderEnum;
import cn.hd.entity.core.BaseModel;
import org.hibernate.annotations.Parameter;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;
import org.hibernate.annotations.TypeDefs;

import javax.persistence.*;
import java.io.Serializable;

/**
 * 人员表实体
 * @author: machao
 * @date  : 2017-11-1 下午04:18:08
 */
@Entity
@Table(name = "Person",schema="YAJD")//数据库表名
//配置枚举属性的映射
@TypeDefs({@TypeDef(name = "myEnum", typeClass = EnumDescriptionUserType.class,
		parameters = {@Parameter(name = "class", value = "cn.hd.common.enumeration.GenderEnum")})})
public class Person extends BaseModel implements Serializable{
	private static final long serialVersionUID = 2180384505384814001L;




	@Column(name = "created")
	private Long created = System.currentTimeMillis();

	@Column(name = "username")
	private String username;
	@Column
	@Type(type = "myEnum")
	private GenderEnum gender;

	public Long getCreated() {
		return created;
	}

	public void setCreated(Long created) {
		this.created = created;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public GenderEnum getGender() {
		return gender;
	}

	public void setGender(GenderEnum gender) {
		this.gender = gender;
	}



}