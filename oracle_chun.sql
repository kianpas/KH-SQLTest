--=====================================
-- CHUN 계정
--=====================================

--학과 테이블
select*from tb_department;

--학생테이블
select*from tb_student;

--과목테이블
select*from tb_class;

--교수테이블
select*from tb_professor;

--교수과목테이블
select*from tb_class_professor;

--점수등급 테이블
select*from tb_grade;

--1. 춘 기술대학교의 학과 이름과 계열을 표시하시오
select
department_name 학과명,
category 계열
from tb_department;

--2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다
select 
department_name|| '의 정원은 ' || capacity ||'명 입니다' 학과별정원
from tb_department;

--3. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생 학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서
select
student_name
from tb_student
where substr(student_ssn, 8, 1) ='2' and absence_yn = 'Y' and DEPARTMENT_NO = '001';
--AND    STUDENT_SSN  LIKE '______-2%';

select
student_name
from tb_student left outer join tb_department on tb_student.department_no = tb_department.department_no
where substr(student_ssn, 8, 1) ='2' and absence_yn = 'Y' and department_name = '국어국문학과';

select
student_name
from tb_student s left outer join tb_department d on s.department_no = d.department_no
where substr(student_ssn, 8, 1) ='2' and absence_yn = 'Y' and department_name = '국어국문학과';

--4. 도서관에서 대출 도서 장기 연체자를 찾아 이름을 게시. 학번이 다음과 같을 때 대상자들을 찾는 SQL 구문을 작성하시오.
--A513079, A513090, A513091, A513110, A513119
select
student_name
from tb_student
where student_no in ('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
order by student_name DESC;

--5. 입학정원이 20명 이상 30명 이하인 학과들의 학과 이름과 계열을 출력하시오.
select
department_name 학과명,
category 계열
from tb_department
where capacity between 20 and 30;

--6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다.춘 기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.
select
professor_name
from tb_professor
where department_no is null;

--7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다.
select
student_name
from tb_student
where department_no is null;

--8. 수강신청을 하려고 gks다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회해보시오.
select
class_no
from tb_class
where preattending_class_no is not null;

--9. 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오.
select
DISTINCT category
from tb_department
order by category;

--10. 02학번 전주 거주자들의 모임을 만들려고 한다. 휴학한 사람들은 제외핚 재학중인 학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오.
select
student_no,
student_name,
student_ssn
from tb_student
where substr(entrance_date, 1, 2) = '02' and student_address like '%전주%' and absence_yn = 'N';

--1. 학과테이블에서 계열별 정원의 평균을 조회(정원 내림차순 정렬)
select
category,
trunc(avg(capacity))
from tb_department
group by category
order by 2 desc;

--2. 휴학생을 제외하고, 학과별로 학생수를 조회(학과별 인원수 내림차순)
select
department_no,
count(*)
from tb_student
where absence_yn = 'N'
group by department_no
order by 2 desc;

--3. 과목별 지정된 교수가 2명이상이 과목번호와 교수인원수를 조회
select
class_no 과목번호,
count(*) 교수인원수
from tb_class_professor
group by class_no
having count(*) >= 2
order by 2 desc;


--4. 학과별로 과목을 구분했을때, 과목구분이 "전공선택"에 한하여 과목수가 10개 이상인 행의 학과번호, 과목구분(class_type), 과목수를 조회(전공선택만 조회)
select
decode(grouping(department_no), 0, department_no, 1, '합계') 학과번호,
decode(grouping(class_type), 0, class_type, 1, '소계') 과목구분,
count(*) 과목수
from tb_class
-- where class_type = '전공선택'  --그룹핑 이전에 조건
group by department_no, class_type
having count(*) >= 10 and class_type = '전공선택' --그룹핑 이후에 조건
order by 1;

--21.01.27 함수
--1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른 순으로 표시하는 SQL 문장을 작성하시오.
--( 단, 헤더는 "학번", "이름", "입학년도" 가 표시되도록 핚다.)
select
student_no 학번,
student_name 이름,
to_char(to_date(entrance_date, 'rr/mm/dd'), 'rrrr-mm-dd') 입학년도
from tb_student
where department_no = 002
order by entrance_date;

--2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 핚 명 있다고 핚다. 그 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자.
select
professor_name,
professor_ssn
from tb_professor
where length(professor_name) != 3
--WHERE  PROFESSOR_NAME NOT LIKE '___'; --3글자 like로 한 것
order by professor_name;

--3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 단 이때 나이가 적은 사람에서 맋은 사람 순서로 화면에 출력되도록 맊드시오.
select
professor_name 교수이름,
EXTRACT(year from sysdate) - (substr(professor_ssn, 1, 2) + 1900) 나이,
TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE('19' ||SUBSTR(PROFESSOR_SSN, 1, 6),'RRRRMMDD'))/12) 만나이
from tb_professor
where substr(professor_ssn, 8, 1) = 1
order by 2;



--4. 교수들의 이름 중 성을 제외핚 이름맊 출력하는 SQL 문장을 작성하시오. 출력 헤더는 ‚이름‛ 이 찍히도록 핚다. (성이 2자인 경우는 교수는 없다고 가정하시오)
select
substr (professor_name, 2) 이름
from tb_professor;

--5. 춘 기술대학교의 재수생 입학자를 구하려고 핚다. 어떻게 찾아낼 것인가? 이때, 19살에 입학하면 재수를 하지 않은 것으로 갂주핚다.
--출생년도는 rr를 하면 좋은 답은 아니다 오류 가능성 있음
select
student_no,
student_name
from tb_student
where extract(year from entrance_date) - (substr(student_ssn, 1, 2) + 1900) > 19;
--WHERE   TO_NUMBER(TO_CHAR(ENTRANCE_DATE, 'YYYY'))  - TO_NUMBER(TO_CHAR(TO_DATE(SUBSTR(STUDENT_SSN, 1, 2), 'RR'), 'YYYY')) > 19;

--6. 2020년 크리스마스는 무슨 요일인가?
select
to_char(to_date('2020/12/25', 'yyyy/mm/dd'), 'yyyy/mm/dd (dy)')
from dual;

--7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미핛까? 
-- yy형은 현재년도만 사용 (2021이므로 2000~2099)
select
TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD')
from dual;
--또 TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미핛까?
-- rr형은 년도 뒷자리 보고 판단 50 ~ 49 이면 1950 ~ 2049로 판단
select
to_char(TO_DATE('99/10/11','RR/MM/DD'), 'rrrr/mm/dd'), to_char(TO_DATE('49/10/11','RR/MM/DD'), 'rrrr/mm/dd')
from dual;

--8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다. 2000년도 이젂 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.
select
student_no,
student_name
from tb_student
where extract(year from entrance_date) <2000;
--WHERE  SUBSTR(STUDENT_NO, 1, 1) <> 'A' 2000년대 이전에는 A만 받았으므로 이런 조건도 가능

--9. 학번이 A517178 인 핚아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 
--단, 이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 핚 자리까지맊 표시핚다.
select
round(avg(point), 1) 평점
from tb_grade
where student_no = 'A517178';

--10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 맊들어 결과값이 출력되도록 하시오.
select
department_no 학과번호,
count(*) "학생수(명)"
from tb_student
group by department_no
order by department_no; --group by절에 쓴 컬럼이기에 가능

--11. 지도 교수를 배정받지 못핚 학생의 수는 몇 명 정도 되는 알아내는 SQL 문을 작성하시오.
select
count(*)
from tb_student
where coach_professor_no is null;

--12. 학번이 A112113인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오. 
--단, 이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 핚 자리까지맊 표시핚다.
select
substr(term_no, 1, 4) 년도,
round(avg(point), 1) "년도 별 평점"
from tb_grade
where student_no = 'A112113'
group by substr(term_no, 1, 4)
order by 1;

--13. 학과 별 휴학생 수를 파악하고자 핚다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오.
select
department_no,
sum(decode(absence_yn, 'Y', 1, 'N', 0))
--SUM(CASE WHEN ABSENCE_YN ='Y' THEN 1 ELSE 0 END) AS "휴학생 수"
from tb_student
group by department_no
order by department_no;

--14. 춘 대학교에 다니는 동명이인(同名異人) 학생들의 이름을 찾고자 핚다. 어떤 SQL 문장을 사용하면 가능하겠는가?
select
student_name 동일이름,
count(*) "동명인 수"
from tb_student
group by student_name
having count(*)>=2;

--15. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 총 평점을 구하는 SQL 문을 작성하시오. 
--(단, 평점은 소수점 1자리까지맊 반올림하여 표시핚다.)
select
decode(grouping(substr(term_no, 1, 4)), 0, substr(term_no, 1, 4), 1, ' ') 년도,
decode(grouping(substr(term_no, 5, 2)), 0, substr(term_no, 5, 2), 1, ' ') 학기,
round(avg(point), 1) 평점
from tb_grade
where student_no = 'A112113'
group by rollup(substr(term_no, 1, 4), substr(term_no, 5, 2));

--CASE이용
SELECT 
DECODE(GROUPING(SUBSTR(TERM_NO, 1, 4)),0,SUBSTR(TERM_NO, 1, 4),1,'총평점') AS 년도,
CASE WHEN GROUPING(SUBSTR(TERM_NO, 1, 4)) = 1 AND GROUPING(SUBSTR(TERM_NO, 5, 2))=1 THEN ' '
WHEN GROUPING(SUBSTR(TERM_NO, 5, 2)) = 1 THEN '연별누적평점'
ELSE SUBSTR(TERM_NO, 5, 2) END AS 구분,
ROUND(AVG(POINT), 1) AS 평점
FROM   TB_GRADE
WHERE  STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO, 1, 4),SUBSTR(TERM_NO, 5, 2));

--학번/학생명/담당교수명 조회
--1. 두테이블의 기준 컬럼 파악
--2. on 조건절에 해당되지 않는 데이터파악

--담당교수가 배정되지 않은 학생, 담당학생이 없는 교수 제외  579
select count(*)
from tb_student S join tb_professor P 
on S.coach_professor_no = P.professor_no;

--담당교수가 배정되지 않은 학생 포함 left 588 = 579 + 9
select count(*)
from tb_student S left join tb_professor P 
on S.coach_professor_no = P.professor_no;

--담당학생이 없는 교수 포함 right 580 = 579 + 1
select count(*)
from tb_student S right join tb_professor P 
on S.coach_professor_no = P.professor_no;

--1. 교수배정을 받지 않는 학생 조회 --9명
select count(*)
from tb_student
where coach_professor_no is null;

--2. 담당학생이 한명도 없는 교수
--전체 교수 수 --114
select count(*)
from tb_professor;
--중복 없는 담당교수 수 -- 113
select count(distinct coach_professor_no) --distinct 한 것도 count 가능
from tb_student;

--## @실습문제 : join
--@chun계정으로 실행
--1. 학번, 학생명, 학과명 조회
-- 학과 지정이 안된 학생은 존재하지 않는다.
select
s.student_no 학번,
s.student_name 학생명,
d.department_name 학과명
from tb_student S left join tb_department D 
on S.department_no = D.department_no;

select
s.student_no 학번,
s.student_name 학생명,
d.department_name 학과명
from tb_student S, tb_department D
where S.department_no = D.department_no(+);

--2. 수업번호, 수업명, 교수번호, 교수명 조회
select
c.class_no 수업번호,
c.class_name 수업명,
cp.professor_no 교수번호,
p.professor_name 교수명
from tb_class C 
left join tb_class_professor CP
on C.class_no = CP.class_no
left join tb_professor P
on CP.professor_no = P.professor_no;

--강사님
select
c.class_no 수업번호,
c.class_name 수업명,
cp.professor_no 교수번호,
p.professor_name 교수명
from tb_class_professor CP
join tb_class C 
on CP.class_no = C.class_no
join tb_professor P
on P.professor_no = CP.professor_no;


--3. 송박선 학생의 모든 학기 과목별 점수를 조회(학기, 학번, 학생명, 수업명, 점수) --성적 정보 기준으로 해야 
select
g.term_no 학기,
s.student_no 학번,
s.student_name 학생명,
c.class_name 수업명,
g.point 점수
--count(*) --5036
from tb_student S
left join tb_grade G
on  S.student_no = G.student_no
left join tb_class C
on G.class_no = C.class_no
where s.student_name = '송박선'
order by 1;

--강사님
select
g.term_no 학기,
student_no 학번,   --using에 사용한 컬럼은 별칭 사용 불가
student_name 학생명,
c.class_name 수업명,
g.point 점수
from tb_grade G
join tb_student S
using(student_no)
join tb_class C
using(class_no)
where s.student_name = '송박선';


--잘못된 것
select 
--G.term_no 학기,
--          S.student_no 학번,
--          S.student_name 학생명,
--          C.class_name 수업명,
--          G.point 점수
from tb_student S
   join tb_class C
     on S.department_no = C.department_no
   join tb_grade G
     on C.class_no = G.class_no
where S.student_name like '송박선' 
order by G.term_no;



--4. 학생별 전체 평점(소수점이하 첫째자리 버림) 조회 (학번, 학생명, 평점)
--같은 학생이 여러학기에 걸쳐 같은 과목을 이수한 데이터 있으나, 전체 평점으로 계산함.
select
s.student_no 학번,
s.student_name 학생명,
trunc(avg(g.point), 1) 평점
from tb_student S
left join tb_grade G
on  S.student_no = G.student_no
group by s.student_name, s.student_no;

--강사님
select 
student_no,
student_name,
trunc(avg(point),1)
from tb_grade G
join tb_student S
 using(student_no)
group by student_no, student_name;



--5. 교수번호, 교수명, 담당학생명수 조회
-- 단, 5명 이상을 담당하는 교수만 출력
select
p.professor_no 교수번호,
p.professor_name 교수명,
count(*)담당학생명수
from tb_professor P
left join tb_student S
on p.professor_no = s.coach_professor_no
group by p.professor_name, p.professor_no
--having count(p.professor_no) >= 5
having count(*) >=5
order by 1;

--강사님
select 
p.professor_no,
p.professor_name,
count(*) cnt
from tb_student S
 join tb_professor P
  on S.coach_professor_no = P.professor_no
group by p.professor_no, p.professor_name
having count(*)>=5;
order by cnt desc;

--@실습문제 : INNER JOIN & OUTER JOIN
--1. 학번, 학생명, 학과명을 출력
select
s.student_no,
s.student_name,
d.department_name
from tb_student s join tb_department d
on s.department_no = d.department_no;

select
s.student_no,
s.student_name,
d.department_name
from tb_student s, tb_department d
where s.department_no = d.department_no;

--2. 학번, 학생명, 담당교수명을 출력하세요.
--담당교수가 없는 학생은 '없음'으로 표시
select
s.student_no,
s.student_name,
nvl(p.professor_name, '없음')
from tb_student s left join tb_professor p
on s.coach_professor_no = p.professor_no;

select
s.student_no, s.student_name,
nvl(p.professor_name, '없음')
from tb_student s, tb_professor p
where s.coach_professor_no = p.professor_no(+);


--3. 학과별 교수명과 인원수를 모두 표시하세요.
select
d.department_name 학과명,
decode(grouping(p.professor_name), 0, p.professor_name, 1, count(p.professor_name)) 교수명,
d.capacity 인원수
from tb_department d left join tb_professor p
on d.department_no = p.department_no
group by rollup(p.professor_name), d.department_name, d.capacity
order by 1;

select
d.department_name 학과명,
decode(grouping(p.professor_name), 0, p.professor_name, 1, count(p.professor_name)) 교수명,
d.capacity 인원수
from tb_department d, tb_professor p
where d.department_no = p.department_no
group by rollup(p.professor_name), d.department_name, d.capacity
order by 1;

-- 4. 이름이 [~람]인 학생의 평균학점을 구해서 학생명과 평균학점(반올림해서 소수점둘째자리까지)과 같이 출력.
-- (동명이인일 경우에 대비해서 student_name만으로 group by 할 수 없다.)
select 
s.student_name 학생명,
round(avg(g.point), 2) 평균학점,
s.student_no
from tb_student s left join tb_grade g
on s.student_no = g.student_no
where s.student_name like '%람'
group by s.student_no, s.student_name;

select
s.student_name,
round(avg(g.point), 2),
s.student_no
from tb_student s, tb_grade g
where s.student_no = g.student_no and s.student_name like '%람'
group by s.student_name, s.student_no;

--cross join은 전체평균이 나옴
select
s.student_name,
평균,
s.student_no
from tb_student s cross join (select round(avg(point), 2) 평균 from tb_grade) a
where s.student_name like '%람';


--5. 학생별 다음정보를 구하라.
/*
--------------------------------------------
학생명  학기     과목명    학점
--------------------------------------------
감현제	200401	전기생리학 	4.5
            .
            .
--------------------------------------------
*/
select 
s.student_name,
g.term_no,
d.department_name,
g.point
from tb_student s join tb_grade g
on s.student_no = g.student_no
join tb_department d
on s.department_no = d.department_no
order by 1, 2;

select
s.student_name,
g.term_no,
d.department_name,
g.point
from tb_student s, tb_grade g, tb_department d
where s.student_no = g.student_no(+) and s.department_no = d.department_no(+)
order by 1, 2;
