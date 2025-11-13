/* 문제 

보호소에서는 몇 시에 입양이 가장 활발하게 일어나는지 알아보려 합니다. 
0시부터 23시까지, 각 시간대별로 입양이 몇 건이나 발생했는지 조회하는 SQL문을 작성해주세요. 이때 결과는 시간대 순으로 정렬해야 합니다.

*/ 

-- 학습 포인트: WITH RECURSIVE 계층쿼리 사용 (https://horang98.tistory.com/10)
-- missing 포인트: 0 - 23시까지 각 시간의 정보를 나타내야 한다는 것

WITH RECURSIVE HOURS AS -- 재귀쿼리
(
    SELECT 0 AS HOUR 
     UNION ALL -- Recursive 사용 시 필수. 초깃값 다음에 이어붙여야 할 때 사용
    SELECT HOUR+1 FROM HOURS 
     WHERE HOUR < 23 -- 정지 조건 전까지 반복
)
SELECT H.HOUR, 
       COUNT(O.ANIMAL_ID) AS COUNT
  FROM HOURS AS H 
  LEFT JOIN ANIMAL_OUTS AS O
    ON H.HOUR = HOUR(O.DATETIME)
GROUP BY H.HOUR
ORDER BY H.HOUR; 




