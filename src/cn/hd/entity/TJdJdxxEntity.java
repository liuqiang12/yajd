package cn.hd.entity;

import cn.hd.common.enumeration.BanjieEnum;
import cn.hd.common.enumeration.EnumDescriptionUserType;
import cn.hd.common.enumeration.JdxxBzEnum;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.hibernate.annotations.*;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * @ClassName: TJdJdxxEntity
 * @Description: (接待信息表)
 * @author liuqiang
 */
@Entity
@Table(name = "T_JD_JDXX",schema="YAJD")
@TypeDefs({
        @TypeDef(
                name = "jdxxBzEnum", typeClass = EnumDescriptionUserType.class,
                parameters = {@org.hibernate.annotations.Parameter(name = "class", value = "cn.hd.common.enumeration.JdxxBzEnum")}
        ),
        @TypeDef(
                name = "banjieEnum", typeClass = EnumDescriptionUserType.class,
                parameters = {@org.hibernate.annotations.Parameter(name = "class", value = "cn.hd.common.enumeration.BanjieEnum")}
        )
})
@XmlRootElement(name = "TJdJdxxEntity")
@XmlAccessorType(XmlAccessType.FIELD)
@JsonIgnoreProperties(value={"hibernateLazyInitializer","handler","hyddEntities"})
public class TJdJdxxEntity  implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 503827399502348545L;
	private String id;//uuid
    /*private String fid;//发起单位id(未知)*/
    /*private String fqrId;//发起人ID(未知)*/
    private Date ksSj;//开始时间
    private Date jsSj;//结束时间
    private String bt;//标题
    private String ddld;//带队领导
    private String jdlx;//接待类型
    private String dwlxr;//单位联系人
    private String lxsjh;//联系手机号
    private String cgdyd;//参观调研点
    private Integer rs;//人数
    private int mj;//密级
    private String bz;//备注
    private JdxxBzEnum jdxxBz;//接待信息标志；0：新建待分配人员；            1：待制定方案；            2：待初审；            3：待复审；            4：复审完成
    private Integer jdxxBzInt;//参数
    private String jdxxBzText;//参数
    private String cbrId;//分配承办人ID；分配人员时填入,未分配时为空
    private String cbrName;//分配承办人名称(ADD)
    private String cbdwId;//承办单位ID
    private String cbdwName;//承办单位名称
    private Date fpcbrSj;//分配承办人时间

    private String ptldMc;//陪同领导名称(ADD)-冗余
    private String ptldId;//陪同领导ID
    private String mc;//会议名称
    private Date hySj;//会议时间
    private BanjieEnum bjBz;//办结标志0：未办结；1：已办结
    private Date fqSj;//发起时间
    private Date zdfaSj;//制定方案时间
    private Set<TXtHyddEntity> hyddEntities = new HashSet<TXtHyddEntity>();//接待地点 /*多对多关系*/
    private TXtDwEntity lrdwEntity;//录入单位

    /**
     * 发起人信息: 多对一
     */
    private TXtRyEntity ryEntity;//多对一关系


    @Id
    @Column(name="ID",columnDefinition="varchar(32)")
    @GeneratedValue(generator="system-uuid")
    @GenericGenerator(name = "system-uuid", strategy = "uuid")
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    /*@Basic
    @Column(name = "FID",columnDefinition="varchar(32)",nullable = false)
    public String getFid() {
        return fid;
    }

    public void setFid(String fid) {
        this.fid = fid;
    }*/

    /*@Basic
    @Column(name = "FQR_ID",columnDefinition="varchar(32)",nullable = false)
    public String getFqrId() {
        return fqrId;
    }

    public void setFqrId(String fqrId) {
        this.fqrId = fqrId;
    }*/

    @Basic
    @Column(name = "KS_SJ",columnDefinition="datetime",nullable = false)
    @DateTimeFormat(pattern="yyyy-MM-dd")
    public Date getKsSj() {
        return ksSj;
    }

    public void setKsSj(Date ksSj) {
        this.ksSj = ksSj;
    }

    @Basic
    @Column(name = "JS_SJ",columnDefinition="datetime",nullable = false)
    @DateTimeFormat(pattern="yyyy-MM-dd")
    public Date getJsSj() {
        return jsSj;
    }

    public void setJsSj(Date jsSj) {
        this.jsSj = jsSj;
    }

    @Basic
    @Column(name = "BT",columnDefinition="varchar(200)",nullable = false)
    public String getBt() {
        return bt;
    }

    public void setBt(String bt) {
        this.bt = bt;
    }

    @Basic
    @Column(name = "DDLD",columnDefinition="varchar(200)",nullable = false)
    public String getDdld() {
        return ddld;
    }

    public void setDdld(String ddld) {
        this.ddld = ddld;
    }

    @Basic
    @Column(name = "JDLX",columnDefinition="varchar(20)",nullable = false)
    public String getJdlx() {
        return jdlx;
    }

    public void setJdlx(String jdlx) {
        this.jdlx = jdlx;
    }

    @Basic
    @Column(name = "DWLXR",columnDefinition="varchar(200)",nullable = false)
    public String getDwlxr() {
        return dwlxr;
    }

    public void setDwlxr(String dwlxr) {
        this.dwlxr = dwlxr;
    }

    @Basic
    @Column(name = "LXSJH",columnDefinition="varchar(20)",nullable = false)
    public String getLxsjh() {
        return lxsjh;
    }

    public void setLxsjh(String lxsjh) {
        this.lxsjh = lxsjh;
    }

    @Basic
    @Column(name = "CGDYD",columnDefinition="varchar(200)",nullable = false)
    public String getCgdyd() {
        return cgdyd;
    }

    public void setCgdyd(String cgdyd) {
        this.cgdyd = cgdyd;
    }

    @Basic
    @Column(name = "RS",columnDefinition="NUMBER(4)",nullable = false)
    public Integer getRs() {
        return rs;
    }

    public void setRs(Integer rs) {
        this.rs = rs;
    }

    @Basic
    @Column(name = "MJ",columnDefinition="NUMBER(10)",nullable = false)
    public int getMj() {
        return mj;
    }

    public void setMj(int mj) {
        this.mj = mj;
    }

    @Basic
    @Column(name = "BZ",columnDefinition="varchar(2000)",nullable = true)
    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }

    @Basic
    @Column(name = "JDXX_BZ",columnDefinition="NUMBER(10)",nullable = false)
    @Type( type = "jdxxBzEnum")
    public JdxxBzEnum getJdxxBz() {
        return jdxxBz;
    }

    public void setJdxxBz(JdxxBzEnum jdxxBz) {
        this.jdxxBz = jdxxBz;
    }

    @Basic
    @Column(name = "CBR_ID",columnDefinition="varchar(32)")
    public String getCbrId() {
        return cbrId;
    }//分配承办人ID；分配人员时填入,未分配时为空

    public void setCbrId(String cbrId) {
        this.cbrId = cbrId;
    }

    @Basic
    @Column(name = "CBR_NAME",columnDefinition="varchar(50)")
    public String getCbrName() {
        return cbrName;
    }

    public void setCbrName(String cbrName) {
        this.cbrName = cbrName;
    }

    @Basic
    @Column(name = "CBDW_ID",columnDefinition="varchar(32)")
    public String getCbdwId() {
        return cbdwId;
    }

    public void setCbdwId(String cbdwId) {
        this.cbdwId = cbdwId;
    }

    @Basic
    @Column(name = "FPCBR_SJ",columnDefinition="datetime")
    @DateTimeFormat(pattern="yyyy-MM-dd")
    public Date getFpcbrSj() {
        return fpcbrSj;
    }

    public void setFpcbrSj(Date fpcbrSj) {
        this.fpcbrSj = fpcbrSj;
    }

    @Basic
    @Column(name = "PTLD_MC",columnDefinition="varchar(50)")
    public String getPtldMc() {
        return ptldMc;
    }

    public void setPtldMc(String ptldMc) {
        this.ptldMc = ptldMc;
    }

    @Basic
    @Column(name = "PTLD_ID",columnDefinition="varchar(32)")
    public String getPtldId() {
        return ptldId;
    }

    public void setPtldId(String ptldId) {
        this.ptldId = ptldId;
    }

    @Basic
    @Column(name = "MC",columnDefinition="varchar(200)",nullable = true)
    public String getMc() {
        return mc;
    }

    public void setMc(String mc) {
        this.mc = mc;
    }

    @Basic
    @Column(name = "HY_SJ",columnDefinition="datetime",nullable = true)
    @DateTimeFormat(pattern="yyyy-MM-dd")
    public Date getHySj() {
        return hySj;
    }

    public void setHySj(Date hySj) {
        this.hySj = hySj;
    }

    @Basic
    @Column(name = "BJ_BZ",columnDefinition="NUMBER(10)")
    @Type( type = "banjieEnum")
    public BanjieEnum getBjBz() {
        return bjBz;
    }

    public void setBjBz(BanjieEnum bjBz) {
        this.bjBz = bjBz;
    }

    @Basic
    @Column(name = "FQ_SJ",columnDefinition="datetime")
    @DateTimeFormat(pattern="yyyy-MM-dd")
    public Date getFqSj() {
        return fqSj;
    }

    public void setFqSj(Date fqSj) {
        this.fqSj = fqSj;
    }

    /**
     * 制定方案时间
     * @return
     */
    @Basic
    @Column(name = "ZDFA_SJ",columnDefinition="datetime")
    @DateTimeFormat(pattern="yyyy-MM-dd")
    public Date getZdfaSj() {
        return zdfaSj;
    }

    public void setZdfaSj(Date zdfaSj) {
        this.zdfaSj = zdfaSj;
    }





    /*@ManyToOne(fetch = FetchType.LAZY,cascade = {CascadeType.REFRESH},optional = true)
    @JoinColumn(name = "HYDD_ID",referencedColumnName = "ID", nullable = true)
    @Fetch(FetchMode.SELECT)
    @XmlElement(nillable = true)
    @JsonIgnore //过滤字段
    public TXtHyddEntity getHyddEntity() {
        return hyddEntity;
    }

    public void setHyddEntity(TXtHyddEntity hyddEntity) {
        this.hyddEntity = hyddEntity;
    }*/
    @ManyToMany(cascade = CascadeType.PERSIST, fetch = FetchType.LAZY)// PERSIST级联新增（又称级联保存）  CascadeType.REFRESH:级联刷新
    @JoinTable(name = "T_JD_DD_LINK",
            schema = "YAJD",
            joinColumns = {@JoinColumn(name = "JD_ID",referencedColumnName="ID")},
            inverseJoinColumns = {@JoinColumn(name = "DD_ID",referencedColumnName="ID")
            }
    )
    public Set<TXtHyddEntity> getHyddEntities() {
        return hyddEntities;
    }

    public void setHyddEntities(Set<TXtHyddEntity> hyddEntities) {
        this.hyddEntities = hyddEntities;
    }

   /* @ManyToOne(fetch = FetchType.EAGER,cascade = {CascadeType.REFRESH})
    @JoinColumn(name = "LRDW_ID",referencedColumnName = "ID", nullable = true)
    @Fetch(FetchMode.SELECT)
    @XmlElement(nillable = true)
    @JsonIgnore //过滤字段
    public TXtDwEntity getXtDwEntity() {
        return xtDwEntity;
    }

    public void setXtDwEntity(TXtDwEntity xtDwEntity) {
        this.xtDwEntity = xtDwEntity;
    }*/
    @ManyToOne(fetch = FetchType.EAGER,cascade = {CascadeType.REFRESH})
    @JoinColumn(name = "LRDW_ID",referencedColumnName = "ID", nullable = true)
    @Fetch(FetchMode.SELECT)
    @XmlElement(nillable = true)
    //@JsonIgnore //过滤字段
    public TXtDwEntity getLrdwEntity() {
        return lrdwEntity;
    }

    public void setLrdwEntity(TXtDwEntity lrdwEntity) {
        this.lrdwEntity = lrdwEntity;
    }

    @ManyToOne(fetch = FetchType.EAGER,cascade = {CascadeType.REFRESH})
    @JoinColumn(name = "FQR_ID",referencedColumnName = "ID", nullable = true)
    @Fetch(FetchMode.SELECT)
    @XmlElement(nillable = true)
    //@JsonIgnore //过滤字段
    public TXtRyEntity getRyEntity() {
        return ryEntity;
    }

    public void setRyEntity(TXtRyEntity ryEntity) {
        this.ryEntity = ryEntity;
    }
    @Transient
    public Integer getJdxxBzInt() {
        return jdxxBzInt;
    }

    public void setJdxxBzInt(Integer jdxxBzInt) {
        this.jdxxBzInt = jdxxBzInt;
    }
    
    	
    
    @Basic
    @Column(name = "CBDW_NAME",columnDefinition="varchar(200)",nullable = true)
    public String getCbdwName() {
        return cbdwName;
    }

    public void setCbdwName(String cbdwName) {
        this.cbdwName = cbdwName;
    }
    @Transient
	public String getJdxxBzText() {
		return jdxxBzText;
	}

	public void setJdxxBzText(String jdxxBzText) {
		this.jdxxBzText = jdxxBzText;
	}

}
