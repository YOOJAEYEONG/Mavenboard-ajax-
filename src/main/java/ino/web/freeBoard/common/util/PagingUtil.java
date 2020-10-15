package ino.web.freeBoard.common.util;

public class PagingUtil {

	public static final int pageSize = 5;		//한 페이지당 게시글 수
	public static final int rangeSize = 5;	//한 블럭당 페이지 수

   
    /** 현재 페이지 **/
    private int curPage = 1;
    
    /** 현재 블럭(range) **/
    private int curRange = 1;
    
    /** 총 게시글 수 **/
    private int totCnt;
    
    /** 총 페이지 수 **/
    private int pageCnt;
    
    /** 총 블럭(range) 수 **/
    private int rangeCnt;
    
    /** 시작 페이지 **/
    private int startPage = 1;
    
    /** 끝 페이지 **/
    private int endPage = 1;
    
    /** 시작,끝 index **/
    private int startIndex = 0;
    private int endIndex = 0;
    /** 이전 페이지 **/
    private int prevPage;
    
    /** 다음 페이지 **/
    private int nextPage;
    
    public PagingUtil(int curPage, int totCnt) {
    	 /**
         * 페이징 처리 순서
         * 1. 총 페이지수
         * 2. 총 블럭(range)수
         * 3. range setting
         */
        
        // 총 게시물 수와 현재 페이지를 Controller로 부터 받아온다.
        /** 현재페이지 **/
        setCurPage(curPage);
        /** 총 게시물 수 **/
        setTotCnt(totCnt);
        
        /** 1. 총 페이지 수 **/
        setPageCnt(totCnt);
        /** 2. 총 블럭(range)수 **/
        setRangeCnt(pageCnt);
        /** 3. 블럭(range) setting **/
        rangeSetting(curPage);
        
        /** DB 질의를 위한 Index 설정 **/
        setStartIndex(curPage);
        setEndIndex(curPage);
        
        toString();
    }

	public int getCurPage() {
		return curPage;
	}

	public void setCurPage(int curPage) {
		this.curPage = curPage;
	}

	public int getCurRange() {
		return curRange;
	}

	public void setCurRange(int curRange) {
		this.curRange = (int)((curPage-1)/rangeSize) + 1;
	}

	public int gettotCnt() {
		return totCnt;
	}

	public void setTotCnt(int totCnt) {
		this.totCnt = totCnt;
	}

	public int getPageCnt() {
		return pageCnt;
	}

	/** 1. 총 페이지 수 **/
	public void setPageCnt(int totCnt) {
		this.pageCnt = (int) Math.ceil((double)totCnt*1.0/pageSize);
	}

	public int getRangeCnt() {
		return rangeCnt;
	}

	 /** 2. 총 블럭(range)수 **/
	public void setRangeCnt(int pageCnt) {
		this.rangeCnt = (int) Math.ceil(pageCnt*1.0/rangeSize);
	}

	/** 3. 블럭(range) setting **/
	public void rangeSetting(int curPage){
        
        setCurRange(curPage);        
        this.startPage = (curRange - 1) * rangeSize + 1;
        this.endPage = startPage + rangeSize - 1;
        System.out.println("startPage:"+startPage);
        System.out.println("endPage1:"+endPage);
        System.out.println("pageCnt:"+pageCnt);
        if(endPage > pageCnt){
            this.endPage = pageCnt;
            System.out.println("endPage2:"+endPage);
        }
        this.prevPage = curPage - 1;
        this.nextPage = curPage + 1;
    }

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public int getStartIndex() {
		return startIndex;
	}

	public int getPageSize() {
		return pageSize;
	}
	
	public void setStartIndex(int curPage) {
		this.startIndex = (curPage-1) * pageSize + 1;
	}

	public int getPrevPage() {
		return prevPage;
	}

	public void setPrevPage(int prevPage) {
		this.prevPage = prevPage;
	}

	public int getNextPage() {
		return nextPage;
	}

	public void setNextPage(int nextPage) {
		this.nextPage = nextPage;
	}

	

	@Override
	public String toString() {
		return "PagingUtil [curPage=" + curPage + ", curRange=" + curRange + ", totCnt=" + totCnt + ", pageCnt="
				+ pageCnt + ", rangeCnt=" + rangeCnt + ", startPage=" + startPage + ", endPage=" + endPage
				+ ",\n startIndex=" + startIndex + ", endIndex=" + endIndex + ", prevPage=" + prevPage + ", nextPage="
				+ nextPage + "]";
	}

	public int getEndIndex() {
		return endIndex;
	}

	public void setEndIndex(int curPage) {
		this.endIndex = curPage * pageSize;
	}
    
    
    
}
