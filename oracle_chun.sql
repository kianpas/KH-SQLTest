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
order by professor_name;

--3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 단 이때 나이가 적은 사람에서 맋은 사람 순서로 화면에 출력되도록 맊드시오.
select
professor_name 교수이름,
EXTRACT(year from sysdate) - (substr(professor_ssn, 1, 2) + 1900) 나이
from tb_professor
where substr(professor_ssn, 8, 1) = 1
order by 2;

--4. 교수들의 이름 중 성을 제외핚 이름맊 출력하는 SQL 문장을 작성하시오. 출력 헤더는 ‚이름‛ 이 찍히도록 핚다. (성이 2자인 경우는 교수는 없다고 가정하시오)
select
substr (professor_name, 2) 이름
from tb_professor;

--5. 춘 기술대학교의 재수생 입학자를 구하려고 핚다. 어떻게 찾아낼 것인가? 이때, 19살에 입학하면 재수를 하지 않은 것으로 갂주핚다.
select
student_no,
student_name
from tb_student
where extract(year from entrance_date) - (substr(student_ssn, 1, 2) + 1900) > 19;

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

--9. 학번이 A517178 인 핚아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 
--단, 이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 핚 자리까지맊 표시핚다.
select
round(avg(point), 1) 평점
from tb_grade
where student_no = 'A517178';

--10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 맊들어 결과값이 출력되도록 하시오.
select
department_no,
count(*)
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
