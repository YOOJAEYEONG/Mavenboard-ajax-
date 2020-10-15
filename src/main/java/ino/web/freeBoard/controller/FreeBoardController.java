package ino.web.freeBoard.controller;

import ino.web.commonCode.service.CommCodeService;
import ino.web.freeBoard.common.util.PagingUtil;
import ino.web.freeBoard.dto.FreeBoardDto;
import ino.web.freeBoard.service.FreeBoardService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class FreeBoardController {
	
	@Autowired
	private FreeBoardService freeBoardService;
	@Autowired
	private CommCodeService commCodeService;
	
	@RequestMapping("/main.ino")
	public ModelAndView main(
			HttpServletRequest request, 
			@RequestParam(defaultValue="1") int curPage,
			@RequestParam(defaultValue="") String searchColumn,
			@RequestParam(defaultValue="") String searchWord,
			@RequestParam(defaultValue="") String startDate,
			@RequestParam(defaultValue="") String endDate){
		
		ModelAndView mav = new ModelAndView();
		HashMap<String, Object> map = new HashMap<String,Object>();
		
		map.put("searchColumn", searchColumn);
		map.put("searchWord", searchWord);
		map.put("startDate", startDate.replaceAll(".", ""));
		map.put("endDate", endDate.replaceAll(".", ""));
		System.out.println("날짜:"+startDate+" "+endDate);
		
		int totCnt = freeBoardService.getTotalCount(map);
		PagingUtil pagination = new PagingUtil(curPage, totCnt);
		
		map.put("start",pagination.getStartIndex());
		map.put("end",pagination.getEndIndex());
		List<FreeBoardDto> list = freeBoardService.freeBoardList(map);
		
		
		/* 공통코드:검색조건들을 저장 */
		List<String> callCommonList = new ArrayList<String>();
		callCommonList.add("COM1");
		callCommonList.add("COM2");
		/* 공통코드:각조건사용여부 저장 */
		Map<String,Object> callCommons = new HashMap<String, Object>();
		callCommons.put("masterUseYN", "Y");
		callCommons.put("detailUseYN", "Y");
		callCommons.put("list", callCommonList);
		List<HashMap<String, String>> searchOptions = null;
		
		searchOptions = commCodeService.getCommonCode(callCommons);			
		System.out.println(searchOptions.toString());
		
		mav.addObject("searchOptions", searchOptions);
		mav.addObject("freeBoardList",list);
		mav.addObject("pagination", pagination);
		mav.setViewName("boardMain");
		return mav;
	}
	
	@RequestMapping(value = "/mainSearch.ino", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, Object> mainSearch(
			HttpServletRequest request,
			@RequestParam(defaultValue="1") int curPage,
			@RequestParam(defaultValue="") String searchColumn,
			@RequestParam(defaultValue="") String searchWord,
			@RequestParam(defaultValue="") String startDate,
			@RequestParam(defaultValue="") String endDate
			){
		
		HashMap<String, Object> map = new HashMap<String,Object>();
		map.put("searchColumn", searchColumn);
		map.put("searchWord", searchWord);
		map.put("startDate", startDate.replace(".", ""));
		map.put("endDate", endDate.replace(".", ""));
		
		int totCnt = freeBoardService.getTotalCount(map);
		System.out.println("totCnt"+totCnt);
		PagingUtil pagination = new PagingUtil(curPage, totCnt);
		
		map.put("start",pagination.getStartIndex());
        map.put("end",pagination.getEndIndex());
        
        
		List<FreeBoardDto> list = freeBoardService.freeBoardList(map);
		
		map.put("list", list);
		map.put("pagination", pagination);
		return map;
	}
	
	@RequestMapping("/freeBoardInsert.ino")
	public String freeBoardInsert(){
		return "freeBoardInsert";
	}

	
	@RequestMapping("/freeBoardInsertPro.ino")
	public String freeBoardInsertPro(HttpServletRequest request, FreeBoardDto dto){
		freeBoardService.freeBoardInsertPro(dto);
		//return "redirect:freeBoardDetail.ino?num="+dto.getNum();
		return "redirect:main.ino";
	}
	
	@ResponseBody
	@RequestMapping("/freeBoardInsertProAjax.ino")
	public Map<String, String> freeBoardInsertProAjax(HttpServletRequest request, FreeBoardDto dto){
		
		Map<String, String> map = new HashMap<String, String>();
		int resultOfInsert = 0;
		String msg = "";
		try {
			resultOfInsert = freeBoardService.freeBoardInsertPro(dto);	
		} catch (Exception e) {
			e.printStackTrace();
			msg = e.getMessage();
		}
		System.out.println("resultOfInsert:"+resultOfInsert);
		
		if(resultOfInsert == 0) {
			map.put("msg", "글쓰기 실패");
			if(msg.contains("ORA-12899: value too large for column \"YOO\".\"FREEBOARD\".\"CONTENT\""))
				map.put("msg", "입력가능한 내용 초과");
			if(msg.contains("ORA-12899: value too large for column \"YOO\".\"FREEBOARD\".\"TITLE\""))
				map.put("msg", "입력가능한 제목 초과");
			if(msg.contains("ORA-12899: value too large for column \"YOO\".\"FREEBOARD\".\"NAME\""))
				map.put("msg", "입력가능한 이름 초과");
		}else {
			map.put("msg", "글쓰기 성공");
		}
		return map;
	}
	
	@RequestMapping("/freeBoardDetail.ino")
	public ModelAndView freeBoardDetail(HttpServletRequest request, FreeBoardDto dto){
		int num = Integer.parseInt(request.getParameter("num"));
		dto = freeBoardService.getDetailByNum(num);
		return new ModelAndView("freeBoardDetail", "freeBoardDto", dto);
	}
	
	@RequestMapping("/freeBoardModify.ino")
	public String freeBoardModify(HttpServletRequest request, FreeBoardDto dto){
		freeBoardService.freeBoardModify(dto);
		return "redirect:/main.ino";
	}
	@ResponseBody
	@RequestMapping(value = "/freeBoardModifyAjax.ino", method = RequestMethod.POST)
	public Map<String, String> freeBoardModifyAjax(HttpServletRequest request, FreeBoardDto dto){
		
		Map<String, String> map = new HashMap<String, String>();
		int resultOfInsert = 0;
		String msg = "";
		try {
			resultOfInsert = freeBoardService.freeBoardModify(dto);	
		} catch (Exception e) {
			e.printStackTrace();
			msg = e.getMessage();
		}
		System.out.println("resultOfInsert:"+resultOfInsert);
		if(resultOfInsert == 0) {
			map.put("msg", "글수정 실패");
			if(msg.contains("ORA-12899: value too large for column \"YOO\".\"FREEBOARD\".\"CONTENT\""))
				map.put("msg", "입력가능한 내용 초과");
			if(msg.contains("ORA-12899: value too large for column \"YOO\".\"FREEBOARD\".\"TITLE\""))
				map.put("msg", "입력가능한 제목 초과");
			if(msg.contains("ORA-12899: value too large for column \"YOO\".\"FREEBOARD\".\"NAME\""))
				map.put("msg", "입력가능한 이름 초과");
		}else {
			map.put("msg", "글수정 성공");
		}
		
		return map;
		
	}
	
		
	@RequestMapping("/freeBoardDelete.ino")
	public String FreeBoardDelete(int num){
		freeBoardService.FreeBoardDelete(num);
		return "redirect:/main.ino";
	}
	
	@ResponseBody
	@RequestMapping("/freeBoardDeleteAjax.ino")
	public int FreeBoardDeleteAjax(int num){
		int resultOfDelete = 0;
		resultOfDelete = freeBoardService.FreeBoardDelete(num);
		//return "redirect:/main.ino";
		return resultOfDelete;
	}
	
	
}