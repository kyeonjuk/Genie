----------------------------------------------------------
----------------------------------------------------------
/*
TeamProject DB Table Version 4.0
일시 : 2024.01.18
내용 : 주문관련 찜목록 테이블(tpslang) 및 포인트로그 테이블(tppointlog)

TeamProject DB Table Version 4.1
일시 : 2024.01.19
내용 : member table 이름 변경(indimember, corpmember)

TeamProject DB Table Version 4.2
일시 : 2024.01.25
내용 : orderlog cashcard(카드번호) number에서 varchar2로 변경
*/
/*
TeamProject DB Table Version 5.0
일시 : 2024.01.29
내용 : orderlog table을 orderlog와 배송지 정보가 담긴 orderinfo 테이블로 2분할
*/
----------------------------------------------------------

----------------------------------------------------------
-- 로그인/회원가입 Table
-- 일반회원
create table indimember( 
  name varchar2(100),     -- 사용자 이름
  userid varchar2(100) primary key,   -- 사용자 아이디
  email varchar2(100),    -- 사용자 이메일
  pass varchar2(100),     -- 사용자 비번
  tel varchar2(100),  -- 사용자 연락처
  addr varchar2(100),     -- 사용자 주소
  birthday date,          -- 사용자 생년월일
  admin varchar2(100),     -- 관리자여부(1:관리자, 0:일반)
  point number(30)        -- 보유 포인트(누적량)
);
--법인/단체회원
create table corpmember( 
  name varchar2(100),     -- 법인/단체명
  userid varchar2(100) primary key,   -- 법인 아이디
  regisnum varchar2(100), -- 사업자등록번호
  pass varchar2(100),     -- 법인 비번
  tel varchar2(100),      -- 법인 연락처
  addr varchar2(100),     -- 법인 주소
  point number(30)        -- 보유 포인트(누적량)
);
----------------------------------------------------------
-- 상품 Table
CREATE TABLE tpbook(
  booknum number(30) primary key,      -- 상품번호
  title varchar2(500),     -- 제목
  inventory number(30),     -- 재고량
  author varchar2(100),    -- 저자
  category varchar2(100),  -- 카테고리
  price number(30),        -- 가격
  pubdate varchar2(1000),  -- 발간일
  bookimg varchar2(1000),  -- 책이미지
  summary varchar2(2000),  -- 줄거리
  publisher varchar2(100), -- 출판사
  userid varchar2(100),    -- 판매자(member table)
  expdate date,            -- 유효기간(판매자가 일반회원일 경우에만 유효) 
  bookstate varchar2(100), -- 책 상태("신상" "중고" "하자") 
  grade number(10),        -- 상품별 접근 가능 연령(ex 17세)
  reviewAvg NUMBER(10,2)   -- 상품 평균 별점
);
-- 리뷰 Table
create table tpreview (
  reviewid number(30) primary key, -- 리뷰 id
  booknum number(30),    -- 상품번호 (book table)
  userid varchar2(100),  -- 유저아이디 (member table)
  point number,          -- 별점
  review varchar2(1000), -- 리뷰입력
  reviewdate date        -- 리뷰작성 일시
);
----------------------------------------------------------
-- 장바구니 Table
create table tpcart (
  cartid number(30) primary key, -- 장바구니 id
  userid varchar2(100),      -- 사용자 id (member table)
  booknum number(30),        -- 상품번호 (book table)
  amount number(30),         -- 구매수량
  ischecked number Default 0 -- 구매체크여부 
);
-- 구매기록 Table
CREATE TABLE TPORDERLOG (
  "ORDERLOGID" NUMBER(30,0) PRIMARY KEY, 
  "ORDERID" VARCHAR2(100 BYTE), 
  "USERID" VARCHAR2(100 BYTE), 
  "BOOKNUM" NUMBER(30,0), 
  "AMOUNT" NUMBER(30,0), 
  "ORDERSTATEDETAIL" VARCHAR2(100 BYTE)
);
-- 배송지정보 Table
CREATE TABLE TPORDERINFO (
  "ORDERID" VARCHAR2(100 BYTE) PRIMARY KEY,
  "ORDERNAME" VARCHAR2(100 BYTE), 
  "ORDERTEL" VARCHAR2(100 BYTE), 
  "ORDEREMAIL" VARCHAR2(100 BYTE), 
  "DISCOUNT" NUMBER(30,0), 
  "CASHCARD" VARCHAR2(30 BYTE), 
  "ORDERADDR" VARCHAR2(100 BYTE),
  "ORDERSTATE" VARCHAR2(100 BYTE),
  "REGDATE" DATE,
  "PAYDATE" DATE
);
-- 찜목록 Table
create table tpslang (
  slangid number(30) primary key, -- 찜목록 id
  userid varchar2(100),      -- 사용자 id (member table)
  booknum number(30),        -- 상품번호 (book table)
  ischecked number Default 0 -- 구매체크 여부
);
-- 포인트 획득로그 테이블
CREATE TABLE "KIC"."TPPOINTLOG" 
   (	"POINTLOGID" NUMBER(30,0),
   	"ORDERID" VARCHAR2(100 BYTE),
	"ORDERLOGID" NUMBER(30,0), 
	"USERID" VARCHAR2(100 BYTE), 
	"CHANGEPOINT" NUMBER(30,0), 
	"REGDATE" DATE
   );
----------------------------------------------------------
-- 게시판 Table
-- 1대1 질문 게시판 테이블
create table tpinquiry (  
  inquiryid number(30) primary key,     -- 문의 id 
  userid varchar2(100),     -- 사용자 id (member table)
  category varchar2(100),   -- 문의 분류 ("book", "order", "member", "delivery", "etc")
  orderid varchar(100),     -- 주문 번호 (orderlog table) 
  title varchar2(100),      -- 문의 제목 
  content varchar2(1000),   -- 문의 내용
  createdate date,          -- 문의 작성 날짜 
  responsestatus number(1)  -- 답변 여부
);
-- 1대1 답변 테이블 
create table tpreply (  
  replyid number(30) primary key,         -- 답변 id 
  inquiryid number(30),       -- 문의 id (문의 테이블 참조) (member table = userid)
  replycontent varchar2(1000),-- 답변 내용
  replycreatedate date        -- 답변 작성 날짜 
);
-- FAQ 게시판 테이블
CREATE TABLE tpfaq(   
  faqid number(30) primary key,        -- FAQ id
  category varchar2(100),  -- FAQ 분류 (order, pay, delivery, returns, etc)
  question varchar2(1000), -- 질문 
  answer varchar2(1000),   -- 답변  
  createdate DATE          -- 마지막 작성 날짜
);
-- 공지사항 게시판 테이블
CREATE TABLE tpnotice (      
  noticeid number(30) primary key,     -- 공지사항 id
  title varchar2(100),     -- 공지사항 제목 
  content varchar2(1000),  -- 공지사항 내용 
  createdate DATE          -- 마지막 작성 날짜
);
-- 이벤트 게시판 테이블
CREATE TABLE tpevent (      
  eventid number(30) primary key,       -- 이벤트 id
  category varchar2(30),    -- 이벤트 카테고리 (new, pay, etc)
  image varchar2(1000),     -- 이벤트 배너 이미지 
  title varchar2(100),      -- 이벤트 제목 
  content varchar2(1000),   -- 이벤트 내용 (이미지 or 문자)
  startdate DATE,           -- 이벤트 시작 날짜 
  enddate DATE              -- 이벤트 종료 날짜 
);

