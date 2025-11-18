-- 자동차 종류가 '세단' 또는 'SUV' 인 자동차 중 
-- 2022년 11월 1일부터 2022년 11월 30일까지 대여 가능하고 
-- 30일간의 대여 금액이 50만원 이상 200만원 미만인 자동차
-- 자동차 ID, 자동차 종류, 대여 금액(컬럼명: FEE) 리스트를 출력하는 SQL문
-- 대여 금액을 기준으로 내림차순 정렬; 대여 금액이 같은 경우 자동차 종류를 기준으로 오름차순 정렬; 자동차 ID를 기준으로 내림차순 정렬

 
 
SELECT *
  FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
 WHERE END_DATE BETWEEN '2022-11-01' AND '2022-11-30' AND
       START_DATE BETWEEN '2022-11-01' AND '2022-11-30';
 
WITH 
-- 1. '세단', 'SUV' 중 30일 대여 금액을 미리 계산
CARS_WITH_FEE AS (
    SELECT
        C.CAR_ID,
        C.CAR_TYPE,
        C.DAILY_FEE,
        P.DISCOUNT_RATE,
        -- 30일간의 대여 금액을 계산 (할인율 적용)
        -- 정수 부분만 출력해야 하므로 TRUNCATE 또는 FLOOR 사용
        TRUNCATE(C.DAILY_FEE * (1 - P.DISCOUNT_RATE / 100) * 30, 0) AS FEE
    FROM
        CAR_RENTAL_COMPANY_CAR AS C
    JOIN
        CAR_RENTAL_COMPANY_DISCOUNT_PLAN AS P
        ON C.CAR_TYPE = P.CAR_TYPE
    WHERE
        C.CAR_TYPE IN ('세단', 'SUV')
        AND P.DURATION_TYPE = '30일 이상'
),

-- 2. 11월 1일~30일 사이에 대여 기록이 있어 "대여 불가능한" 차량 ID
UNAVAILABLE_CARS AS (
    SELECT DISTINCT CAR_ID
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    -- 대여 기간이 11월 1일~30일과 하루라도 겹치면 대여 불가
    -- (내 종료일 >= 11/1) AND (내 시작일 <= 11/30)
    WHERE
        END_DATE >= '2022-11-01'
        AND START_DATE <= '2022-11-30'
)

-- 3. 메인 쿼리: 1에서 2를 제외하고, 금액 조건 필터링
SELECT
    F.CAR_ID,
    F.CAR_TYPE,
    F.FEE
FROM
    CARS_WITH_FEE AS F
WHERE
    -- 4. 대여 금액이 50만원 이상 200만원 미만인 경우
    F.FEE >= 500000 AND F.FEE < 2000000
    
    -- 3. "대여 불가능한" 차량 목록에 없어야 함 (즉, 대여 가능해야 함)
    AND F.CAR_ID NOT IN (SELECT CAR_ID FROM UNAVAILABLE_CARS)

-- 5. 정렬 조건
ORDER BY
    FEE DESC,           -- 대여 금액 기준 내림차순
    CAR_TYPE ASC,       -- 자동차 종류 기준 오름차순
    CAR_ID DESC;        -- 자동차 ID 기준 내림차순 
  