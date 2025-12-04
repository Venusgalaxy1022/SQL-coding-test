-- 7월 아이스크림 총 주문량과 상반기의 아이스크림 총 주문량을 더한 값
-- 이 큰 순서대로 상위 3개의 맛을 조회하는 SQL 문을 작성

WITH FH AS
(
SELECT FLAVOR,
       SUM(TOTAL_ORDER) AS total
  FROM FIRST_HALF
 GROUP BY FLAVOR
)
, B AS 
(
SELECT FLAVOR, 
       SUM(TOTAL_ORDER) AS total
  FROM JULY
 GROUP BY FLAVOR
)
, C AS
(
SELECT FH.FLAVOR, 
       FH.total + B.total AS TOTAL_ORDER
  FROM FH
 INNER JOIN B
    ON FH.FLAVOR = B.FLAVOR
 ORDER BY TOTAL_ORDER DESC
)
SELECT C.FLAVOR
  FROM C
 LIMIT 3; 
