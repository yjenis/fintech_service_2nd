USE titanic; -- 데이터 베이스 열기[선택]
SHOW tables; -- 테이블 보기
SHOW databases;
# 데이터 조회 명령 select 컬럼명 from 테이블
SELECT * FROM p_info;

# 테이블에서 1개 컬럼만 조회할 때 select 컬럼명1 FROM 테이블 명;
select Name from p_info;
 
#  테이블에서 2개 컬럼만 조회할 때 select 컬럼명1 FROM 테이블 명;
 SELECT Name, Age from p_info;
 # 컬럼 조회
 DESC p_info;
 
 # 테이블에서 데이터를 10개만 조회하고 싶을 때 SELECT * FROM 테이블명 LIMIT 10
 SELECT * FROM p_info LIMIT 10;
 
 # 성별이 남자인 사람만 조회
 SELECT * FROM p_info WHERE Sex='male';
 
 # 나이가 40세 이상인 사람만 조회
 SELECT * FROM p_info WHERE Age>=40;
 
 SELECT * FROM p_info WHERE Age>=20 and Age<50 And Sex='Female';
 SELECT * FROM p_info WHERE SibSp+1 and Parch>=1;
 SELECT * FROM t_info WHERE Pclass=1;
 SELECT * FROM t_info WHERE Pclass=2 or Fare>50;
 SELECT * FROM survived where survived=1;
 
 SELECT * FROM p_info where SibSp;

# IN, LIKE, BETWEEN, IS NULL, IS NOT NULL
 SELECT * FROM p_info WHERE Sibsp in (1,2,3); 
 select * from p_info WHERE Sibsp not in(0,1,2,3);
 
 # LIKE 문자열 안에서 특정 단어를 포함한 행을 찾을 때, % 
 SELECT * FROM p_info WHERE name LIKE '%Rice%';-- 
 SELECT * FROM p_info WHERE name LIKE '%Eric';
 
# Between a and b, a이상 b이하를 찾을 때(이상, 이하만 가능)

SELECT * FROM t_info WHERE Fare between 100 and 1000;
SELECT * FROM t_info WHERE Ticket Like "PC%" and Embarked IN ("C","S");
SELECT * FROM t_info WHERE Pclass IN(1,2);
SELECT * FROM t_info WHERE Cabin LIKE "%59%";
SELECT * FROM p_info WHERE Age IS NOT NULL AND Name LIKE "%James%" And Age>=40;
# 그룹 연산 함수 AVG()  - 평균, MIN()-최솟값, MAX()-최댓값, COUNT()행 개수
SELECT AVG(Age), Sex FROM p_info WHERE Age IS NOT NULL GROUP BY Sex;

SELECT Pclass, AVG(Fare) From t_info GROUP BY Pclass HAVING AVG(Fare)>50;


 # INNER JOIN (교집합) 왼쪽, 오른쪾에 있는 테이블에서 기준 컬럼의 값이 일치하는 것만 합침
 # Passenger 컬럼(왼) ticket(오) Inner 조인
 SELECT * FROM passenger LIMIT 3;
  SELECT * FROM ticket LIMIT 3;
  
select * FROM passenger;
select * FROM ticket;
SELECT * FROM passenger JOIN ticket ON passenger.PassengerId=ticket.PassengerId;
SELECT * FROM passenger LEFT JOIN ticket ON passenger.PassengerId=ticket.PassengerId;
SELECT * FROM passenger RIGHT JOIN ticket ON passenger.PassengerId=ticket.PassengerId;
SELECT * FROM passenger LEFT JOIN ticket ON passenger.PassengerId=ticket.PassengerId UNION ALL
SELECT * FROM passenger RIGHT JOIN ticket ON passenger.PassengerId=ticket.PassengerId;

# 3개의 테이블을 1개로 합치기 (테이블1+테이블2)
SELECT * FROM passenger p 
JOIN ticket t ON p.PassengerId=t.PassengerId 
JOIN survived s ON p.PassengerId=s.PassengerId;

SELECT Name, Sex, Pclass FROM passenger p 
LEFT JOIN ticket t ON p.PassengerId=t.PassengerId 
LEFT JOIN survived s ON p.PassengerId=s.PassengerId
WHERE Sex='female' and Pclass=1 and survived=1;

SELECT * FROM passenger p 
LEFT JOIN ticket t ON p.PassengerId=t.PassengerId 
LEFT JOIN survived s ON p.PassengerId=s.PassengerId
WHERE Age between 10 and 20 and Pclass=2 and survived=1;