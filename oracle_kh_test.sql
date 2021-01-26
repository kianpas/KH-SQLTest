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

