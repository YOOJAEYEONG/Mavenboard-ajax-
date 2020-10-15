package ino.web.commonCode.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CommCodeService {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	
	public List<HashMap<String, Object>> selectCommonCodeList() {
		return sqlSessionTemplate.selectList("selectCommonCodeList");
	}
	public List<HashMap<String, String>> getCommonCode(Map<String, Object> callCommons){
		return sqlSessionTemplate.selectList("searchOptions", callCommons);
	}
	public List<HashMap<String, Object>> getDTable(Map<String, Object> map){
		return sqlSessionTemplate.selectList("getDTable", map);
	}
	
	public void insertCommonCode(List<HashMap<String, Object>> list) {
		sqlSessionTemplate.insert("insertCommonCode", list);
	}
	public void updateCommonCode(List<HashMap<String, Object>> list) {
		sqlSessionTemplate.update("updateCommonCode", list);
	}
	public void deleteCommonCode(List<HashMap<String, Object>> list) {
		sqlSessionTemplate.delete("deleteCommonCode", list);
	}
	
	
	
}
