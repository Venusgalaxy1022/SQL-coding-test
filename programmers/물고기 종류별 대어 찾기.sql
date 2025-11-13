/* 학습 목표: SUM, MAX, MIN 함수 활용하기 */

/* 문제: 
물고기 종류 별로 가장 큰 물고기의 ID, 물고기 이름, 길이를 출력하는 SQL 문을 작성해주세요.
물고기의 ID 컬럼명은 ID, 이름 컬럼명은 FISH_NAME, 길이 컬럼명은 LENGTH로 해주세요.
결과는 물고기의 ID에 대해 오름차순 정렬해주세요.
단, 물고기 종류별 가장 큰 물고기는 1마리만 있으며 10cm 이하의 물고기가 가장 큰 경우는 없습니다.
*/


-- CTE를 활용한 풀이 1
-- 윈도우 함수 RANK()를 활용해서 풀이 한 것이고, 2개의 CTE를 사용하여 다소 비효율적인 코드라고 느껴짐.  
 WITH A AS
 (
     SELECT *,
            RANK() OVER(PARTITION BY FISH_TYPE ORDER BY LENGTH DESC) AS SR
       FROM FISH_INFO
      WHERE LENGTH IS NOT NULL
 ),
 B AS
 (
     SELECT *
       FROM A
      WHERE SR = 1
 )
 SELECT ID, 
        FISH_NAME,
        LENGTH
   FROM B
   LEFT JOIN FISH_NAME_INFO
     ON B.FISH_TYPE = FISH_NAME_INFO.FISH_TYPE
 ORDER BY ID ASC;


-- CTE를 활용한 풀이 2 
-- 마찬가지로 윈도우 함수를 사용했지만, CTE 1개로 구성된 코드임. 첫번째 코드와 차이점은 MAX() 라는 윈도우 함수를 썼따는 것과 JOIN을 CTE 내에서 사용했다는 것.

WITH TBL AS (
    SELECT
        i.ID, i.FISH_TYPE, i.LENGTH, i.TIME, n.FISH_NAME, 
        MAX(LENGTH) OVER (PARTITION BY FISH_TYPE) AS MAX_LENGTH
    FROM
        FISH_INFO i LEFT JOIN FISH_NAME_INFO n
        ON i.FISH_TYPE = n.FISH_TYPE
    )


SELECT
    ID,
    FISH_NAME,
    LENGTH
FROM
    TBL
WHERE
    LENGTH = MAX_LENGTH
ORDER BY
    ID ASC;


-- 서브쿼리를 활용한 풀이
-- 튜플 비교(tuple comparison) 문법
SELECT
    i.ID,
    n.FISH_NAME,
    i.LENGTH
FROM
    FISH_NAME_INFO n INNER JOIN FISH_INFO i
    ON n.FISH_TYPE = i.FISH_TYPE
WHERE
    (i.FISH_TYPE, i.LENGTH) IN (   -- (A, B) 형태로 두 개 이상의 컬럼을 묶어서 비교하는 방식
        SELECT
            FISH_TYPE,
            MAX(LENGTH) AS LENGTH
        FROM
            FISH_INFO
        GROUP BY
            FISH_TYPE
        )
ORDER BY
    i.ID ASC;
