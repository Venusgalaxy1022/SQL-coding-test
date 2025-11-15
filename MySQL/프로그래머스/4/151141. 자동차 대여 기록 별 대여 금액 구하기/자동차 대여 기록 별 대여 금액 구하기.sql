-- 코드를 입력하세요
# WITH A AS
#     (
#     SELECT history_id, 
#            car_id, 
#            DIFF,
#            CASE 
#                WHEN DIFF < 7 THEN '7일 미만' 
#                WHEN DIFF < 30 THEN '7일 이상' -- 상위 조건 이후로 조건이 걸리는 구나
#                WHEN DIFF < 90 THEN '30일 이상'
#                ELSE '90일 이상'
#            END AS DURATION_TYPE
#     FROM (
#         SELECT *, DATEDIFF(END_DATE, START_DATE) AS DIFF
#         FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
#     ) t
# ),
# B AS
# (
#     SELECT history_id, 
#            C.CAR_ID,
#            DIFF, 
#            DURATION_TYPE, 
#            CAR_TYPE, 
#            daily_fee
#       FROM A
#       LEFT JOIN CAR_RENTAL_COMPANY_CAR AS C
#         ON A.CAR_ID = C.CAR_ID
# ), 
# tb AS 
# (
#     SELECT history_id, 
#            car_id, 
#            diff, 
#            B.duration_type, 
#            B.car_type, 
#            daily_fee, 
#            IFNULL(discount_rate,0) AS discount_rate
#       FROM B 
#       LEFT JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN AS P
#         ON B.CAR_TYPE = P.CAR_TYPE AND
#            B.DURATION_TYPE = P.DURATION_TYPE
#       WHERE B.car_type ='트럭'
# )
# SELECT HISTORY_ID,
#        ROUND(daily_fee * (1 - discount_rate/100) * DIFF,0) AS FEE
#   FROM tb
#  ORDER BY FEE DESC, HISTORY_ID DESC; -- order by 기준 comma로 묶기
       




SELECT H.HISTORY_ID, ROUND((DAILY_FEE * RENT_DAY) - (DAILY_FEE * RENT_DAY * 0.01 * IFNULL(MAX(DISCOUNT_RATE), 0))) AS FEE FROM CAR_RENTAL_COMPANY_CAR AS R
JOIN (
    SELECT HISTORY_ID, CAR_ID, DATEDIFF(END_DATE, START_DATE) + 1 AS RENT_DAY FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
)  AS H ON R.CAR_ID = H.CAR_ID
LEFT JOIN (
    SELECT 
        CAR_TYPE
        , SUBSTRING_INDEX(DURATION_TYPE, '일', 1) AS DURATION_DATE
        , CAST(SUBSTRING_INDEX(DISCOUNT_RATE, '%', 1) AS SIGNED) AS DISCOUNT_RATE
    FROM  CAR_RENTAL_COMPANY_DISCOUNT_PLAN
) AS D ON H.RENT_DAY > D.DURATION_DATE
WHERE R.CAR_TYPE = '트럭' AND (D.CAR_TYPE = '트럭' OR D.CAR_TYPE IS NULL)
GROUP BY HISTORY_ID
ORDER BY FEE DESC, HISTORY_ID DESC