--@실습문제1
 create table tbl_escape_watch(
        watchname   varchar2(40)
        ,description    varchar2(200)
    );
--drop table tbl_escape_watch;
    insert into tbl_escape_watch values('금시계', '순금 99.99% 함유 고급시계');
    insert into tbl_escape_watch values('은시계', '고객 만족도 99.99점를 획득한 고급시계');
    commit;
select * from tbl_escape_watch;

select*
from tbl_escape_watch
where description like '%99.99\%%' escape '\';


--@실습문제2
--파일경로를 제외하고 파일명만 아래와 같이 출력하세요.
create table tbl_files
    (fileno number(3)
    ,filepath varchar2(500)
    );
insert into tbl_files values(1, 'c:\abc\deft\salesinfo.xls');
insert into tbl_files values(2, 'c:\music.mp3');
insert into tbl_files values(3, 'c:\documents\resume.hwp');
commit;
select * 
from tbl_files;

select fileno 파일번호,
substr(filepath, instr(filepath, '\', -1)+1) 파일명 --12, 3, 13
from tbl_files;


--## @함수최종 실습문제
--1. 직원명과 이메일 , 이메일 길이를 출력하시오
--          이름        이메일       이메일길이
--    ex)     홍길동 , hong@kh.or.kr         13
select 
emp_name,
email,
LENGTH(email)
from employee;

--2. 직원의 이름과 이메일 주소중 아이디 부분만 출력하시오
--    ex) 노옹철   no_hc
--    ex) 정중하   jung_jh
select 
emp_name,
substr(email, 1, instr(email,'@')-1)
from employee;

--3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오 
--    그때 보너스 값이 null인 경우에는 0 이라고 출력 되게 만드시오
--        직원명    년생      보너스
--    ex) 선동일   1962    0.3
--    ex) 송은희   1963    0
select
emp_name 직원명,
to_char(to_date(substr(emp_no, 1, 2)+1900, 'yyyy'), 'yyyy') 년생, 
--'19' ||extract (year from to_date(substr(emp_no, 1, 2), 'yyyy')) 년생,
extract(year from to_date(substr(emp_no,1,2),'rr')) as 년생,
nvl(bonus, 0) 보너스
from employee
WHERE substr(emp_no, 1, 2) like '6_';
--where substr(emp_no,1,2) between 60 and 69;


--4. '010' 핸드폰 번호를 쓰지 않는 사람의 수를 출력하시오 (뒤에 단위는 명을 붙이시오)
--       인원
--    ex) 3명
select count(*) ||'명' 인원
from employee
where substr(phone, 1, 3) not in ('010');
--where not phone like '010%';

--5. 직원명과 입사년월을 출력하시오 
--    단, 아래와 같이 출력되도록 만들어 보시오
--        직원명       입사년월
--    ex) 전형돈       2012년12월
--    ex) 전지연       1997년 3월
select
emp_name 직원명,
to_char(hire_date, 'fmyyyy"년" mm"월"') 입사년월
from employee;

--6. 사원테이블에서 다음과 같이 조회하세요.
--[현재나이 = 현재년도 - 태어난년도 +1] 한국식 나이를 적용.
---------------------------------------------------------------------------
--사원번호    사원명       주민번호            성별      현재나이
---------------------------------------------------------------------------
--200        선동일      621235-1*******      남      57
--201        송종기      631156-1*******      남      56
--202        노옹철      861015-1*******      남      33

select
emp_id 사원번호,
emp_name 사원명,
rpad(substr(emp_no, 1, 8), 14, '*') 주민번호,
decode(substr(emp_no, 8, 1), '1' ,'남', '3', '남', '여') 성별,
case
when substr(emp_no, 8, 1) in ('1', '2') then (extract (year from sysdate)) - (substr(emp_no, 1, 2) + 1900) + 1 
else extract (year from sysdate) - (substr(emp_no, 1, 2) + 2000) + 1 
end 현재나이
--extract(year from sysdate) - (substr(emp_no,1,2) + 
--case when substr(emp_no,8,1) in ('1','2') then 1900 else 2000 end)+1 현재나이
from employee;


--7. 직원명, 직급코드, 연봉(원) 조회
--  단, 연봉은 ￦57,000,000 으로 표시되게 함
--     연봉은 보너스포인트가 적용된 1년치 급여임
select
emp_name 직원명,
job_code 직급코드,
to_char((salary + (salary * nvl(bonus, 0)))*12, 'fml999,999,999') 연봉
from employee;

--8. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
--   사번 사원명 부서코드 입사일
select
emp_id 사번,
emp_name 사원명,
dept_code 부서코드,
hire_date 입사일
from employee
where dept_code in ('D5', 'D9') and substr(hire_date, 1, 2) = '04';

--9. 직원명, 입사일, 오늘까지의 근무일수 조회 
--    * 주말도 포함 , 소수점 아래는 버림
--  * 퇴사자는 퇴사일-입사일로 계산
select 
emp_name 직원명,
hire_date 입사일,
extract (day from numtodsinterval(sysdate - hire_date, 'day')) 근무일수,
trunc(nvl(quit_date,sysdate)-hire_date) as 근무일수 --퇴사자포함하여 계산
from employee;


--10. 직원명, 부서코드, 생년월일, 만나이 조회
--   단, 생년월일은 주민번호에서 추출해서, 
--   ㅇㅇㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
--   나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함
select
emp_name 직원명,
dept_code 부서코드,
--to_char(to_date(substr(emp_no, 1, 2)+1900, 'yyyy'), 'yyyy"년"')||
--to_char(to_date(substr(emp_no, 3, 2), 'mm'), 'mm"월"')||
--to_char(to_date(substr(emp_no, 5, 2), 'dd'), 'dd"일"') 생년월일,
case
when substr(emp_no, 8, 1) in ('1', '2') then to_char(to_date(substr(emp_no, 1, 6), 'yymmdd')-(365*100), 'yyyy"년"mm"월"dd"일"')
else to_char(to_date(substr(emp_no, 1, 6), 'yymmdd'), 'yyyy"년"mm"월"dd"일"')
end 생년월일,
case
when substr(emp_no, 8, 1) in ('1', '2') then (extract (year from sysdate)) - (substr(emp_no, 1, 2) + 1900)
else extract (year from sysdate) - (substr(emp_no, 1, 2) + 2000)
end 만나이
from employee;

--11. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
--  아래의 년도에 입사한 인원수를 조회하시오. 마지막으로 전체직원수도 구하시오
--  => decode, sum 사용
--    -------------------------------------------------------------------------
--     1998년   1999년   2000년   2001년   2002년   2003년   2004년  전체직원수
--    -------------------------------------------------------------------------ㄹ
select
sum(decode(substr(hire_date, 1, 2), '98', 1, 0)) "1998년",
--count(decode(extract(year from hire_date),1998,1)) as "1998년"
sum(decode(substr(hire_date, 1, 2), '99', 1, 0)) "1999년",
sum(decode(substr(hire_date, 1, 2), '00', 1, 0)) "2000년",
sum(decode(substr(hire_date, 1, 2), '01', 1, 0)) "2001년",
sum(decode(substr(hire_date, 1, 2), '02', 1, 0)) "2002년",
sum(decode(substr(hire_date, 1, 2), '03', 1, 0)) "2003년",
sum(decode(substr(hire_date, 1, 2), '04', 1, 0)) "2004년",
count(*) 전체직원수
from employee;

--12.  부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.
select
case dept_code 
when 'D5' then '총무부'
when 'D6' then '기획부'
when 'D9' then '영업부'
else null
end 부서
from employee
where dept_code in ('D5', 'D6', 'D9')  -- 많을 경우에만 괄호, 하나만 할 시 없어도 됨
order by dept_code;

--## @함수최종 실습문제
--1. 직원명과 이메일 , 이메일 길이를 출력하시오
--          이름        이메일       이메일길이
--    ex)     홍길동 , hong@kh.or.kr         13
select
emp_name,
email,
length(email)
from employee;

--2. 직원의 이름과 이메일 주소중 아이디 부분만 출력하시오
--    ex) 노옹철   no_hc
--    ex) 정중하   jung_jh
select
emp_name,
substr(email, 1, instr(email, '@')-1)
from employee;

--3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오 
--    그때 보너스 값이 null인 경우에는 0 이라고 출력 되게 만드시오
--        직원명    년생      보너스
--    ex) 선동일   1962    0.3
--    ex) 송은희   1963    0
select
emp_name,
decode(substr(emp_no, 8, 1), '1', substr(emp_no, 1, 2)+1900, '2', substr(emp_no, 1, 2)+1900,
'3', substr(emp_no, 1, 2)+2000,
'4', substr(emp_no, 1, 2)+2000
) 년생,
extract(year from to_date(substr(emp_no,1,2),'rr')) as 년생, --'rr' 처리하면 자동으로 변환
nvl(bonus, 0) 보너스
from employee
where substr(emp_no, 1, 2) like '6_';


--4. '010' 핸드폰 번호를 쓰지 않는 사람의 수를 출력하시오 (뒤에 단위는 명을 붙이시오)
--       인원
--    ex) 3명
select
count(*)||'명'
from employee
where substr(phone, 1, 3) != '010';

--5. 직원명과 입사년월을 출력하시오 
--    단, 아래와 같이 출력되도록 만들어 보시오
--        직원명       입사년월
--    ex) 전형돈       2012년12월
--    ex) 전지연       1997년 3월
select
emp_name,
to_char(hire_date, 'fmyyyy"년" mm"월"') 입사년월
from employee;


--6. 사원테이블에서 다음과 같이 조회하세요.
--[현재나이 = 현재년도 - 태어난년도 +1] 한국식 나이를 적용.
---------------------------------------------------------------------------
--사원번호    사원명       주민번호            성별      현재나이
---------------------------------------------------------------------------
--200        선동일      621235-1*******      남      57
--201        송종기      631156-1*******      남      56
--202        노옹철      861015-1*******      남      33
select
emp_id,
emp_name,
rpad(substr(emp_no, 1, 8), 14, '*'),
decode(substr(emp_no, 8, 1), '1', '남', '3', '남', '여') 성별,
case 
when substr(emp_no, 8, 1) in ('1', '2') then extract (year from sysdate) - (substr(emp_no, 1, 2) + 1900)+1 --숫자형 - 숫자형
else extract (year from sysdate) - (substr(emp_no, 1, 2) + 2000)+1
end 현재나이
from employee;


--7. 직원명, 직급코드, 연봉(원) 조회
--  단, 연봉은 ￦57,000,000 으로 표시되게 함
--     연봉은 보너스포인트가 적용된 1년치 급여임
select
emp_name,
job_code,
to_char((salary + (salary*nvl(bonus,0)))*12, 'fml999,999,999,999') "연봉(원)"
from employee;

--8. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
--   사번 사원명 부서코드 입사일
select 
emp_id,
emp_name,
dept_code,
hire_date
from employee
where substr(hire_date, 1, 2) = '04';

--9. 직원명, 입사일, 오늘까지의 근무일수 조회 
--    * 주말도 포함 , 소수점 아래는 버림
select 
emp_name,
hire_date,
EXTRACT(day from numtodsinterval(sysdate - hire_date, 'day')) 근무일수
from employee;

--10. 직원명, 부서코드, 생년월일, 만나이 조회
--   단, 생년월일은 주민번호에서 추출해서, 
--   ㅇㅇㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
--   나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함
select
emp_name,
dept_code,
case
when substr(emp_no, 8, 1) in ('1','2') then to_char(to_date(substr(emp_no, 1, 6), 'yymmdd')-(365*100), 'yyyy"년"mm"월"dd"일"')
else to_char(to_date(substr(emp_no, 1, 6), 'yymmdd'), 'yyyy"년"mm"월"dd"일"')
end 생년월일
from employee;


--11. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
--  아래의 년도에 입사한 인원수를 조회하시오. 마지막으로 전체직원수도 구하시오
--  => decode, sum 사용
--    -------------------------------------------------------------------------
--     1998년   1999년   2000년   2001년   2002년   2003년   2004년  전체직원수
--    -------------------------------------------------------------------------ㄹ
select
sum (decode(substr(hire_date, 1, 2), '98', 1, 0)) "1998년",
sum (decode(substr(hire_date, 1, 2), '99', 1, 0)) "1999년",
sum (decode(substr(hire_date, 1, 2), '00', 1, 0)) "2000년",
sum (decode(substr(hire_date, 1, 2), '01', 1, 0)) "2001년",
sum (decode(substr(hire_date, 1, 2), '02', 1, 0)) "2002년",
sum (decode(substr(hire_date, 1, 2), '03', 1, 0)) "2003년",
sum (decode(substr(hire_date, 1, 2), '04', 1, 0)) "2004년",
count(*)
from employee;


--12.  부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.
select
emp_name,
case dept_code
when 'D5' then '총무부'
when 'D6' then '기획부'
when 'D9' then '영업부'
else null
end
from employee
where dept_code in ('D5', 'D6', 'D9')
order by dept_code;

--@실습문제

--1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
select
to_char(to_date('2020/12/25', 'yyyy/mm/dd'), 'yyyy/mm/dd (dy)')
from dual;

--2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 
--사원명, 주민번호, 부서명, 직급명을 조회하시오.
SELECT
E.EMP_NAME 사원명,
E.EMP_NO 주민번호,
D.DEPT_TITLE 부서명,
J.JOB_NAME 직급명
FROM EMPLOYEE E 
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
LEFT JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE SUBSTR(EMP_NO, 8, 1) IN (2, 4) AND EMP_NAME LIKE '전%' AND SUBSTR(EMP_NO, 1, 1) = '7';

SELECT
E.EMP_NAME 사원명,
E.EMP_NO 주민번호,
D.DEPT_TITLE 부서명,
J.JOB_NAME 직급명
FROM EMPLOYEE E ,DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID AND E.JOB_CODE = J.JOB_CODE
AND SUBSTR(EMP_NO, 8, 1) IN (2, 4) AND EMP_NAME LIKE '전%' AND SUBSTR(EMP_NO, 1, 1) = '7';


--3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.
--decode방식
SELECT
E.EMP_ID 사번,
E.EMP_NAME 사원명,
EXTRACT(YEAR FROM SYSDATE) 
- DECODE(SUBSTR(EMP_NO, 8, 1), 3, (SUBSTR(EMP_NO, 1, 2)+2000), 4, (SUBSTR(EMP_NO, 1, 2)+2000), (SUBSTR(EMP_NO, 1, 2)+1900)) 나이,
D.DEPT_TITLE 부서명,
J.JOB_NAME 직급명 
FROM EMPLOYEE E LEFT JOIN DEPARTMENT D
ON E.DEPT_CODE = D.DEPT_ID
LEFT JOIN JOB J
ON E.JOB_CODE = J.JOB_CODE
WHERE EXTRACT(YEAR FROM TO_DATE(SUBSTR(E.EMP_NO, 1, 6))) 
= (SELECT MAX(DECODE(SUBSTR(EMP_NO, 8, 1), 3, (SUBSTR(EMP_NO, 1, 2)+2000), 4, (SUBSTR(EMP_NO, 1, 2)+2000), (SUBSTR(EMP_NO, 1, 2)+1900))) FROM EMPLOYEE);

--case방식
select
e.EMP_ID,
e.EMP_NAME,
extract(year from SYSDATE) - 
(case 
when SUBSTR(EMP_NO, 8, 1) in ('3', '4') then SUBSTR(EMP_NO, 1, 2)+2000
else SUBSTR(EMP_NO, 1, 2)+1900
end) 나이,
d.DEPT_TITLE,
J.JOB_NAME
--extract(year from sysdate) - max(decode(substr(emp_no, 8, 1), 3, (substr(emp_no, 1, 2)+2000), 4, (substr(emp_no, 1, 2)+2000), (substr(emp_no, 1, 2)+1900))) 나이
from EMPLOYEE e left join DEPARTMENT d
on e.DEPT_CODE = d.DEPT_ID
left join job J
on e.JOB_CODE = J.JOB_CODE
where extract(year from to_date(SUBSTR(e.EMP_NO, 1, 6))) 
= (select max(case 
when SUBSTR(EMP_NO, 8, 1) in ('3', '4') then SUBSTR(EMP_NO, 1, 2)+2000
else SUBSTR(EMP_NO, 1, 2)+1900
end)
from EMPLOYEE);

--오라클방식
select
e.EMP_ID,
e.EMP_NAME,
extract(year from SYSDATE) - 
(case 
when SUBSTR(EMP_NO, 8, 1) in ('3', '4') then SUBSTR(EMP_NO, 1, 2)+2000
else SUBSTR(EMP_NO, 1, 2)+1900
end) 나이,
d.DEPT_TITLE,
J.JOB_NAME
from EMPLOYEE e, DEPARTMENT d, job J
where e.DEPT_CODE = d.DEPT_ID(+) and e.JOB_CODE = J.JOB_CODE(+)
and extract(year from to_date(SUBSTR(e.EMP_NO, 1, 6))) 
= (select max(case 
when SUBSTR(EMP_NO, 8, 1) in ('3', '4') then SUBSTR(EMP_NO, 1, 2)+2000
else SUBSTR(EMP_NO, 1, 2)+1900
end)
from EMPLOYEE);

--여러 나이 계산방식
select
TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - DECODE(SUBSTR(e.EMP_NO, 8, 1), 1, TO_NUMBER('19' || SUBSTR(e.EMP_NO, 1, 2)), 2, TO_NUMBER('19' || SUBSTR(e.EMP_NO, 1, 2)),
TO_NUMBER('20' || SUBSTR(e.EMP_NO, 1, 2))) 나이,
trunc(MONTHS_BETWEEN(SYSDATE, DECODE(SUBSTR(EMP_NO, 8, 1), 1, to_date(19||SUBSTR(e.EMP_NO, 1, 6), 'yymmdd'), 
2, to_date(19||SUBSTR(e.EMP_NO, 1, 6), 'yymmdd'), 
to_date(20||SUBSTR(e.EMP_NO, 1, 6), 'yymmdd')))/12) 만나이
from EMPLOYEE e, DEPARTMENT d, job J
where e.DEPT_CODE = d.DEPT_ID(+) and e.JOB_CODE = J.JOB_CODE(+);

--4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
select
e.EMP_ID,
e.EMP_NAME,
d.DEPT_TITLE
from EMPLOYEE e left join DEPARTMENT d 
on e.DEPT_CODE = d.DEPT_ID
where EMP_NAME like '%형%';

select 
e.EMP_ID,
e.EMP_NAME,
d.DEPT_TITLE 
from EMPLOYEE e, DEPARTMENT d
where e.DEPT_CODE = d.DEPT_ID(+) and e.EMP_NAME like '%형%';


--5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
select
e.EMP_NAME,
J.JOB_NAME,
e.DEPT_CODE,
d.DEPT_TITLE
from EMPLOYEE e join job J
on e.JOB_CODE = J.JOB_CODE
join  DEPARTMENT d
on e.DEPT_CODE = d.DEPT_ID
where d.DEPT_TITLE like '해외영업%';

select 
e.EMP_NAME,
J.JOB_NAME,
e.DEPT_CODE,
d.DEPT_TITLE
from EMPLOYEE e, job J, DEPARTMENT d
where e.JOB_CODE = J.JOB_CODE and e.DEPT_CODE = d.DEPT_ID
and d.DEPT_TITLE like '해외영업%';


--6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
select
e.EMP_NAME,
e.BONUS,
d.DEPT_TITLE,
l.LOCAL_NAME
from EMPLOYEE e left join job J
on e.JOB_CODE = J.JOB_CODE
left join  DEPARTMENT d
on e.DEPT_CODE = d.DEPT_ID
left join location l
on d.LOCATION_ID = l.LOCAL_CODE
where e.BONUS is not null;

select
e.EMP_NAME,
e.BONUS,
d.DEPT_TITLE,
l.LOCAL_NAME
from EMPLOYEE e, job J, DEPARTMENT d, location l
where e.JOB_CODE = J.JOB_CODE(+) 
and e.DEPT_CODE = d.DEPT_ID(+) 
and d.LOCATION_ID = l.LOCAL_CODE(+) 
and e.BONUS is not null;


--7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
select
e.EMP_NAME,
J.JOB_NAME,
d.DEPT_TITLE,
l.LOCAL_NAME
from EMPLOYEE e left join job J
on e.JOB_CODE = J.JOB_CODE
left join  DEPARTMENT d
on e.DEPT_CODE = d.DEPT_ID
left join location l
on d.LOCATION_ID = l.LOCAL_CODE
where e.DEPT_CODE = 'D2';

select
e.EMP_NAME,
J.JOB_NAME,
d.DEPT_TITLE,
l.LOCAL_NAME
from EMPLOYEE e, job J, DEPARTMENT d, location l
where e.JOB_CODE = J.JOB_CODE(+) 
and e.DEPT_CODE = d.DEPT_ID(+) 
and d.LOCATION_ID = l.LOCAL_CODE(+)
and e.DEPT_CODE = 'D2';

--8. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
--(사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)
select
e.EMP_NAME 사원명,
J.JOB_NAME 직급명,
e.salary 급여,
e.SALARY*12 연봉
from EMPLOYEE e left join job J
on e.JOB_CODE = J.JOB_CODE
left join SAL_GRADE s
on e.SAL_LEVEL = s.SAL_LEVEL
where e.SALARY > s.MAX_SAL;

select
e.EMP_NAME,
J.JOB_NAME,
e.SALARY,
e.SALARY*12
from EMPLOYEE e, job J, SAL_GRADE s
where e.JOB_CODE = J.JOB_CODE(+) and e.SAL_LEVEL = s.SAL_LEVEL and e.SALARY > s.MAX_SAL;


--9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--사원명, 부서명, 지역명, 국가명을 조회하시오.
select
e.EMP_NAME 사원명,
d.DEPT_TITLE 부서명,
l.LOCAL_NAME 지역명,
n.NATIONAL_NAME 국가명
from EMPLOYEE e join DEPARTMENT d
on e.DEPT_CODE = d.DEPT_ID
join location l
on d.LOCATION_ID = l.LOCAL_CODE
join NATION n
on l.NATIONAL_CODE = n.NATIONAL_CODE
where l.NATIONAL_CODE in ('KO', 'JP');

select
e.EMP_NAME 사원명,
d.DEPT_TITLE 부서명,
l.LOCAL_NAME 지역명,
n.NATIONAL_NAME 국가명
from EMPLOYEE e, DEPARTMENT d, location l, NATION n
where e.DEPT_CODE = d.DEPT_ID 
and d.LOCATION_ID = l.LOCAL_CODE 
and l.NATIONAL_CODE = n.NATIONAL_CODE 
and l.NATIONAL_CODE in ('KO', 'JP');

--10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
--self join 사용
select
E1.EMP_NAME 사원명,
d.DEPT_TITLE 부서명,
E2.EMP_NAME 동료사원명
from EMPLOYEE E1 join EMPLOYEE E2
on E1.DEPT_CODE = E2.DEPT_CODE
join DEPARTMENT d 
on E1.DEPT_CODE = d.DEPT_ID
where e1.emp_name != e2.emp_name
order by 1, 3;

select 
E1.EMP_NAME 사원명,
d.DEPT_TITLE 부서명,
E2.EMP_NAME 동료사원명
from EMPLOYEE E1, EMPLOYEE E2, DEPARTMENT d
where E1.DEPT_CODE = E2.DEPT_CODE and E1.DEPT_CODE = d.DEPT_ID
and e1.emp_name != e2.emp_name
order by 1;


--11. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.
select
e.EMP_NAME 사원명,
J.JOB_NAME 직급명,
e.SALARY 급여
from EMPLOYEE e left join job J
on e.JOB_CODE = J.JOB_CODE
where e.BONUS is null and j.job_name in ('차장', '사원');

select
e.EMP_NAME 사원명,
J.JOB_NAME 직급명,
e.SALARY 급여
from EMPLOYEE e, job J
where e.JOB_CODE = J.JOB_CODE(+) and e.BONUS is null
and j.job_name in ('차장', '사원');

--12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
select
QUIT_YN 퇴사여부,
count(*) 인원
from EMPLOYEE
group by QUIT_YN;

create view TESTVIEW 
as 
select
e.EMP_NAME,
J.JOB_NAME,
e.SALARY
from EMPLOYEE e, job J
where e.JOB_CODE = J.JOB_CODE(+) and e.BONUS is null;

select * from TESTVIEW;
