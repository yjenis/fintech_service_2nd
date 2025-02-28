MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-----------------------------------------------------
Schema mydb
-----------------------------------------------------

-----------------------------------------------------
Schema mydb
-----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-----------------------------------------------------
Table `mydb`.`department`
-----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`department` (
  `department_id` INT NOT NULL,
  `department_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`department_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-----------------------------------------------------
Table `mydb`.`professor`
-----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`professor` (
  `professor_id` INT NOT NULL AUTO_INCREMENT,
  `professor_name` VARCHAR(45) NOT NULL,
  `department_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`professor_id`),
  INDEX `fk_Professor_Department1_idx` (`department_id` ASC) VISIBLE,
  CONSTRAINT `fk_Professor_Department1`
    FOREIGN KEY (`department_id`)
    REFERENCES `mydb`.`department` (`department_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-----------------------------------------------------
Table `mydb`.`course`
-----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`course` (
  `course_id` INT NOT NULL AUTO_INCREMENT,
  `course_name` VARCHAR(45) NOT NULL,
  `professor_id` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  PRIMARY KEY (`course_id`),
  INDEX `fk_Course_Professor1_idx` (`professor_id` ASC) VISIBLE,
  CONSTRAINT `fk_Course_Professor1`
    FOREIGN KEY (`professor_id`)
    REFERENCES `mydb`.`professor` (`professor_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-----------------------------------------------------
Table `mydb`.`student`
-----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`student` (
  `student_id` INT NOT NULL AUTO_INCREMENT,
  `student_name` VARCHAR(45) NOT NULL,
  `height` INT NOT NULL,
  `department_id` INT NOT NULL,
  PRIMARY KEY (`student_id`),
  INDEX `fk_Student_Department_idx` (`department_id` ASC) VISIBLE,
  CONSTRAINT `fk_Student_Department`
    FOREIGN KEY (`department_id`)
    REFERENCES `mydb`.`department` (`department_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-----------------------------------------------------
Table `mydb`.`Student_Course`
-----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Student_Course` (
  `course_id` INT NOT NULL,
  `student_id` INT NOT NULL,
  INDEX `fk_Student_Course_course1_idx` (`course_id` ASC) VISIBLE,
  CONSTRAINT `fk_Student_Course_course1`
    FOREIGN KEY (`course_id`)
    REFERENCES `mydb`.`course` (`course_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

use mydb;
# 테스트 데이터 생성
-- -- ## 학과
insert into department values(1,'수학');
insert into department values(2,'국문학');
insert into department values(3,'정보통신공학');
insert into department values(4,'모바일공학');

select * FROM department;

-- -- ## 학생
insert into student values(1,'가길동',177,1);
insert into student values(2,'나길동',178,1);
insert into student values(3,'다길동',179,1);
insert into student values(4,'라길동',180,2);
insert into student values(5,'마길동',170,2);
insert into student values(6,'바길동',172,3);
insert into student values(7,'사길동',166,4);
insert into student values(8,'아길동',192,4);

select * FROM student;

DESC student_course;

-- -- ## 교수
insert into professor values(1,'가교수',1);
insert into professor values(2,'나교수',2);
insert into professor values(3,'다교수',3);
insert into professor values(4,'빌게이츠',4);
insert into professor values(5,'스티브잡스',3);
select * FROM professor;

# 개설 과목
insert into course values(1,'교양영어',1,'2016/9/2','2016/11/30');
insert into course values(2,'데이터베이스 입문',3,'2016/8/20','2016/10/30');
insert into course values(3,'회로이론',2,'2016/10/20','2016/12/30');
insert into course values(4,'공업수학',4,'2016/11/2','2017/1/28');
insert into course values(5,'객체지향프로그래밍',3,'2016/11/1','2017/1/30');
select * FROM course;

insert into student_course values(1,1);
insert into student_course values(2,1);
insert into student_course values(3,2);
insert into student_course values(4,3);
insert into student_course values(5,4);
insert into student_course values(6,5);
insert into student_course values(7,5);


# 문제1
select a.*, b.department_name
FROM student a
JOIN department b
ON a.department_id=b.department_id;

# 문제2
select professor_id
FROM professor
WHERE professor_name='가교수';

# 문제3
select b.department_name, count(a.professor_id)
FROM professor a
JOIN department b
ON a.department_id=b.department_id 
GROUP BY a.department_id ;

# 문제 4
select a.*, b.department_name
FROM student a
JOIN department b
ON a.department_id=b.department_id
WHERE b.department_name='정보통신공학';

# 문제 5
select a.*, b.department_name
FROM professor a
JOIN department b
ON a.department_id=b.department_id
WHERE b.department_name='정보통신공학';

# 문제 6
select a.student_name, b.department_name
FROM student a
JOIN department b
ON a.department_id=b.department_id
WHERE a.student_name LIKE '아%';

# 문제 7
select count(*)
FROM student
WHERE height between 180 and 190;

# 문제 8
select department_name, max(a.height), avg(a.height)
FROM student a 
JOIN department b
ON a.department_id=b.department_id
group by b.department_name;

# 문제 9
select student_name
FROM student
WHERE department_id = (select department_id from student where student_name='다길동');

#문제 10
select b.student_name, c.course_name
From professor a
JOIN student b ON b.department_id=a.department_id
JOIN course c ON a.professor_id=c.professor_id
WHERE c.start_date LIKE '2016-11%';

#문제 11
select b.student_name
From professor a
JOIN student b ON b.department_id=a.department_id
JOIN course c ON a.professor_id=c.professor_id
where c.course_name='데이터베이스 입문';

#문제 12 학생, 교수, 과목
select count(b.student_name)
From professor a
JOIN student b ON b.department_id=a.department_id
JOIN course c ON a.professor_id=c.professor_id
where a.professor_name='빌게이츠';