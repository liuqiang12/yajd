package cn.hd.common.enumeration;


import java.util.ArrayList;
import java.util.List;

/**
 * 人员类别
 接待信息标志；
 0：新建待分配人员；
 1：待制定方案；
 2：待初审；
 3：待复审；
 4：复审完成
 */
public enum JdxxBzEnum implements EnumDescription {
	DFPRY(0,"新建待分配人员"),
	DZDFA(1,"待制定方案"),
	DCS(2,"待初审"),
	DFS(3,"待复审"),
	FSWC(4,"复审完成");

	private final Integer val;   //枚举值
	private final String description;//枚举描述
	private   static  List <JdxxBzEnum>  list;

	static  {
		list = new ArrayList<JdxxBzEnum>(5);
		list.add(DFPRY);
		list.add(DZDFA);
		list.add(DCS);
		list.add(DFS);
		list.add(FSWC);
	}


	private JdxxBzEnum(Integer val, String description) {
		this.val = val;
		this.description = description;
	}
	public String getDescription() {
		return description;
	}
	public Integer getVal() {
		return val;
	}

	public   static List<JdxxBzEnum> getAll() {
		return  list;
	}

	public static  JdxxBzEnum findById(Integer id) {
		for (JdxxBzEnum jdxxBzEnum : getAll()) {
			if (id  ==  jdxxBzEnum.getVal()) {
				return  jdxxBzEnum;
			}
		}
		return   null ;
	}
}
