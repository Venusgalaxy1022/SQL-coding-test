-- 년, 월, 성별 별로 상품을 구매한 회원수를 집계하는 SQL문을 작성
WITH tb AS
(
    SELECT OS.USER_ID, 
           GENDER, 
           YEAR(SALES_DATE) AS ys,
           MONTH(SALES_DATE) AS ms
      FROM ONLINE_SALE AS OS
      LEFT JOIN USER_INFO AS U
        ON OS.USER_ID = U.USER_ID
)
SELECT ys AS YEAR, 
       ms AS MONTH, 
       GENDER,
       COUNT(DISTINCT USER_ID)
  FROM tb
 WHERE GENDER IS NOT NULL
 GROUP BY ys, ms, GENDER
 ORDER BY ys ASC, ms ASC;