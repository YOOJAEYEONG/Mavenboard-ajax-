CREATE TABLE FREEBOARD(

	code_type varchar2(100),
	NUM number PRIMARY KEY,
    NAME VARCHAR(20),
    TITLE VARCHAR(100),
    CONTENT VARCHAR(1000),
    REGDATE date default sysdate
);


create sequence freeboard_seq
    increment by 1
    start with 1
    nomaxvalue
    minvalue 1
    nocycle
    nocache;

INSERT INTO FREEBOARD(
	code_type,
	num,
	NAME,
    TITLE,
    CONTENT,
    REGDATE
)VALUES(
	'01'
	,freeboard_seq.NEXTVAL
	,'유재영1'
	,'제목1'
	,'내용1'
	,SYSDATE
);

-- Alt+X 실행