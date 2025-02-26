# 데이터베이스, 테이블 만들기
create database sampleDB; #만들기는 create
DROP database sampleDB; #삭제는 drop

# 데이터베이스 조회하기
SHOW databases;

# 테이블 만들기
USE sampledb;
CREATE table 테이블명 (컬럼명1 데이터타입, 컬럼명2 데이터타입...);
CREATE table customers (id INT,
name varchar(100),
sex varchar(20),
phone varchar(20),
address varchar(255));

# 테이블 삭제하기
DROP table customers;

# market_db 만들기
Create database market_db;
USE market_db;
# hongong1 테이블 만들기 toy_id,
CREATE table hongong1 (toy_id int, 
toy_name char(4), age int);
SHOW tables;
DESC hongong1;
SHOW hongong1;

#생성한 테이블에 데이터 입력하기 INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬럼명3) VALUES(1,'우디',25);
INSERT INTO hongong1(toy_id, toy_name, age) VALUES (1,'우디',25);
SELECT * FROM hongong1;
INSERT INTO hongong1(toy_id,toy_name) VALUES(2,'버즈');
# 테이블의 컬럼 순서와 반드시 동일하지 않아도 됨 테이블()순서랑 values()순서만 같으면 됨
INSERT INTO hongong1(toy_name, age, toy_id) VALUES('제시',20,3);
INSERT INTO hongong1 VALUES(4,'포테이토',40);

# primary key와 auto increment

CREATE TABLE hongong2 (
	toy_id int AUTO_INCREMENT PRIMARY KEY,
    toy_name char(4),
    age int);
    
DESC hongong2;
# AUTO_INCREMENT가 지정된 테이블에 데이터 넣기
INSERT INTO hongong2 VALUES(NULL,'보핍',25);
SELECT * FROM hongong2;
INSERT INTO hongong2 VALUES(NULL,'슬링키',22);
INSERT INTO hongong2 VALUES(NULL,'렉스',21);

# 테이블 구조 수정하기 alter
# 컬럼 추가 ALTER TABLE 테이블명 ADD COLUMN 컬럼명, 자료형, 송성(NOT NULL, UNIQUE)
# hongong2 테이블에 country 컬럼 추가하기
ALTER TABLE hongong2 ADD COLUMN country varchar(100);

# 기존 테이블에 있는 자료 UPDATE 하기 where와 함께 씀!!(안그러면 싹 업데이트 됨)
# UPDATE 테이블명 SET 컬럼명 = 업데이트할 값 WHERE toy_id=1;
SELECT * FROM hongong2;
UPDATE hongong2 SET country = '미국' WHERE toy_id=1;

# truncate: 내용은 모두 지우고 테이블의 구조는 남기고 싶을 때
TRUNCATE table hongong2;

# 테이블의 데이터 삭제 delete from 테이블명 where 조건
DELETE FROM hongong1 WHERE idx=2;

SELECT * FROM hongong1;

# idx 컬럼추가 primary key로 지정 auto_increment
ALTER TABLE hongong1 ADD COLUMN idx int AUTO_INCREMENT  PRIMARY KEY;

# CREATE, INSERT, UPDATE, DELETE (CRUD)

# 실습
CREATE TABLE members( 
id INT AUTO_INCREMENT PRIMARY KEY,
member_id varchar(20),
name varchar(20),
address varchar(100));

ALTER TABLE members MODIFY COLUMN member_id VARCHAR(20);
SELECT * FROM members;
INSERT INTO members VALUES(1,'tess','나훈아','경기 부천시 중동');
INSERT INTO members(member_id, name, address) VALUES
('hero','임영웅','서울시 은평구 중산동'),
('iyou','아이유','인천 남구 주안동'),
('jyp','박진영','경기 고양시 장항동');

# 제품테이블 product
CREATE TABLE product (
`제품이름` varchar(100),
`가격` int,
`제조일자` varchar(50),
`제조회사` varchar(100),
`남은 수량` int);

SELECT * FROM product;

INSERT INTO product(`제품이름`,`가격`,`제조일자`,`제조회사`,`남은 수량`) VALUES
('바나나',1500,'2024-07-01','델몬트',17),
('카스',2400,'2023-12-12','OB',3),
('삼각김밥',1000,'2025-02-26','CJ',22);

# product 테이블에 prod_id 컬럼을 추가하고 AUTO_INCREMENT, Primary key추가
ALTER table product ADD COLUMN prod_id int auto_increment primary key;
DESC product;

# Rllback 연습
CREATE database mywork;
USE mywork;
CREATE table emp_test
(emp_no int not null,
emp_name varchar(30) not null,
hire_date date null,
salary int null,
primary key(emp_no));
DESC emp_test;

INSERT INTO emp_test
(emp_no, emp_name,hire_date, salary) 
values
(1005, '쿼리', '2021-03-01',4000),
(1006, '호킹', '2021-03-05',5000),
(1007, '페러데이', '2021-04-01', 2200),
(1008, '맥스웰','2021-04-04',3300);

INSERT INTO emp_test
(emp_no, emp_name,hire_date, salary) 
values
(1009, '플랑크', '2021-04-05',4400);

SELECT * FROM emp_test;

# update 연습 : update [table명] set [무엇을] where [어디를]
# 호킹의 salary를 1000으로 변경
UPDATE emp_test SET salary=1000 WHERE emp_no=1006;
# 패러데이의 hire_date를 2023-07-11로 변경
UPDATE emp_test SET hire_date='2023-07-11' WHERE emp_no=1007;
# 플랑크가 있는 데이터를 삭제
DELETE FROM emp_test WHERE emp_no='1009'; 

# 오토커밋 옵션 활성화 확인
SELECT @@autocommit; # 결과가 1이면 오토커밋 활성화 0이면 비활성화
SET autocommit = 0; # 오토커밋 비활성화
