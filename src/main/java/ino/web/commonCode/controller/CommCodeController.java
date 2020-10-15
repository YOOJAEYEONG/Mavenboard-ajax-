package ino.web.commonCode.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.transaction.support.TransactionCallbackWithoutResult;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import ino.web.commonCode.service.CommCodeService;

@Controller
public class CommCodeController {
	
	@Autowired 
	private CommCodeService commCodeService;
	@Autowired
	PlatformTransactionManager transactionManager;
	/*
	@Autowired
	public TransactionTemplate transactionTemplate;
	
	
	PlatformTransactionManager transactionManager;
	*/
	
	@RequestMapping("/commonCode.ino")
	public ModelAndView commonCode(HttpServletRequest req){
		
		ModelAndView mav = new ModelAndView();
		
		List<HashMap<String,Object>> list = commCodeService.selectCommonCodeList();
		
		mav.addObject("list" , list);
		mav.setViewName("commonCodeMain");
		
		return mav;
	}
	
	@RequestMapping("/commonCodeInsert.ino")
	public ModelAndView commonCodeInsert(ModelAndView mav,
			@RequestParam Map<String, Object> map) {
		
		System.out.println("code>>"+map.get("code"));
		List<HashMap<String,Object>> list = commCodeService.getDTable(map);
		
		mav.addObject("list" , list);
		mav.setViewName("commonCodeInsert");
		return mav;
	}

	@ResponseBody
	@RequestMapping(value="/commonCodeInsertPro", method=RequestMethod.POST)
	public List<HashMap<String,Object>> commonCodeInsertPro (
			@RequestBody final List<HashMap<String,Object>> serializeData){
		
		List<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
		HashMap<String,Object> map = new HashMap<String,Object>() ;
		System.out.println("serializeData:"+serializeData.toString());
	
		
		
		TransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
	
		boolean insert = false;
		boolean update = false;
		boolean delete = false;
		
		for(int i=0;i<serializeData.size();i++) {
			if(serializeData.get(i).get("dataFlag").equals("insert") )
				insert = true;
			if(serializeData.get(i).get("dataFlag").equals("update") )
				update = true;
			if(serializeData.get(i).get("dataFlag").equals("delete") )
				delete = true;
		}
		try {
			if(insert)	commCodeService.insertCommonCode(serializeData);
			if(update)	commCodeService.updateCommonCode(serializeData);
			if(delete)	commCodeService.deleteCommonCode(serializeData);
			transactionManager.commit(status);
		} catch (Exception e) {
			transactionManager.rollback(status);
			e.printStackTrace();
			map.clear();
			list.clear();
			if(e.getMessage().contains("ORA-00001: unique constraint")) {
				map.put("errorMsg", "이미 존재하는 코드");
				list.add(map);
				return list;
			}else {
				map.put("errorMsg", "예외발생:\n"+e.getCause()+" 을 원인으로 저장 실패함");
				list.add(map);
				return list;
			}
		}
			
		map.put("code", serializeData.get(0).get("CODE"));
		return commCodeService.getDTable(map);			
		
	}
	
	
}
