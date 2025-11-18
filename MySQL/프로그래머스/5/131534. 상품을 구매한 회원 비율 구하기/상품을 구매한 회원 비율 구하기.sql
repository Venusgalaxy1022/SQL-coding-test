-- USER_INFO 테이블과 ONLINE_SALE 테이블에서
-- 2021년에 가입한 전체 회원들 중 
-- 상품을 구매한 회원수와 상품을 구매한 회원의 비율(=2021년에 가입한 회원 중 상품을 구매한 회원수 / 2021년에 가입한 전체 회원 수)
-- 월 별로 출력하는 SQL문
-- 상품을 구매한 회원의 비율은 소수점 두번째자리에서 반올림
-- 전체 결과는 년을 기준으로 오름차순 정렬해주시고 
-- 년이 같다면 월을 기준으로 오름차순 정렬

-- 코드를 입력하세요

/* 시도 1  */
-- YEAR, MONTH가 SALES_DATE인지, JOINED인지 명확하지 않았음. 만약 SALES_DATE였음을 미리 알았다면 다른 방식으로 접근했을 것임.

# WITH A AS 
# (
#     SELECT sale.ONLINE_SALE_ID,
#            inf.JOINED,
#            inf.USER_ID,
#            sale.SALES_DATE
#       FROM USER_INFO AS inf
#       LEFT JOIN ONLINE_SALE AS sale
#         ON inf.USER_ID = sale.USER_ID
#      WHERE YEAR(JOINED) = 2021
# )
# ,B AS
# (
# SELECT YEAR(SALES_DATE) AS yr,
#        MONTH(SALES_DATE) AS mt,
#        COUNT(DISTINCT USER_ID) AS B_USER_CNT
#   FROM A
#  GROUP BY YEAR(SALES_DATE), MONTH(SALES_DATE)
# )
# ,C AS 
# (
# SELECT YEAR(SALES_DATE) AS yr,
#        MONTH(SALES_DATE) AS mt,
#        COUNT(DISTINCT USER_ID) AS C_USER_CNT
#   FROM A
#  WHERE ONLINE_SALE_ID IS NULL
# GROUP BY YEAR(SALES_DATE), MONTH(SALES_DATE)
# )
# SELECT B.yr AS YEAR,
#        B.mt AS MONTH,
#        B_USER_CNT AS PURCHASED_USERS,
#        ROUND(C_USER_CNT / B_USER_CNT,1) AS PURCHASED_RATIO
#   FROM B
#   INNER JOIN C
#      ON B.yr = C.yr AND
#         B.mt = C.mt
# ORDER BY YEAR ASC, MONTH ASC;



/* 시도 2 */ 



WITH BASE AS (
SELECT 
    YEAR(OS.SALES_DATE)    AS YEAR
    , MONTH(OS.SALES_DATE) AS MONTH
    , OS.USER_ID           AS USER_ID
    , OS.SALES_AMOUNT      AS SALES_AMOUNT
    , (SELECT COUNT(DISTINCT USER_ID) 
       FROM USER_INFO
       WHERE JOINED LIKE '2021%') AS USER_TOTAL
FROM
    ONLINE_SALE      AS OS
INNER JOIN USER_INFO AS UI    
    ON OS.USER_ID = UI.USER_ID
WHERE UI.JOINED LIKE '2021%'
)
SELECT 
    YEAR
    , MONTH
    , COUNT(DISTINCT USER_ID)  AS PURCHASED_USERS
    , ROUND(COUNT(DISTINCT USER_ID)/ USER_TOTAL, 1) AS PUCHASED_RATIO
FROM BASE
GROUP BY YEAR, MONTH
ORDER BY YEAR, MONTH












