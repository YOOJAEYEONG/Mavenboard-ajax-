package ino.web.freeBoard.service;

import ino.web.freeBoard.dto.FreeBoardDto;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FreeBoardService {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<FreeBoardDto> freeBoardList(HashMap<String, Object> map){
		return sqlSessionTemplate.selectList("freeBoardGetList", map);
	}
	
	public List<FreeBoardDto> freeBoardList(){
		return sqlSessionTemplate.selectList("freeBoardGetList");
	}
	
	public int freeBoardInsertPro(FreeBoardDto dto){
		return sqlSessionTemplate.insert("freeBoardInsertPro",dto);
	}
	
	public FreeBoardDto getDetailByNum(int num){
		return sqlSessionTemplate.selectOne("freeBoardDetailByNum", num);
	}
	
	public int getNewNum(){
		return sqlSessionTemplate.selectOne("freeBoardNewNum");
	}
	
	public int freeBoardModify(FreeBoardDto dto){
		return sqlSessionTemplate.update("freeBoardModify", dto);
	}

	public int FreeBoardDelete (int num) {
		return sqlSessionTemplate.delete("freeBoardDelete", num);
		
	}
	
	public int getTotalCount(HashMap<String, Object> map){
		return sqlSessionTemplate.selectOne("freeBoardTotalCount", map);
	}
	
	
	
}
