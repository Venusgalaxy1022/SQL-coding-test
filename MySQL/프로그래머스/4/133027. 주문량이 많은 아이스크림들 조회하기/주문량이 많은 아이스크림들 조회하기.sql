# -- 7월 아이스크림 총 주문량과 상반기의 아이스크림 총 주문량을 더한 값
# -- 이 큰 순서대로 상위 3개의 맛을 조회하는 SQL 문을 작성

# -- 풀이 1: CTE 3개 사용 >> 다소 비효율적 쿼리 같음. 
# WITH FH AS
# (
# SELECT FLAVOR,
#        SUM(TOTAL_ORDER) AS total
#   FROM FIRST_HALF
#  GROUP BY FLAVOR
# )
# , B AS 
# (
# SELECT FLAVOR, 
#        SUM(TOTAL_ORDER) AS total
#   FROM JULY
#  GROUP BY FLAVOR
# )
# , C AS
# (
# SELECT FH.FLAVOR, 
#        FH.total + B.total AS TOTAL_ORDER
#   FROM FH
#  INNER JOIN B
#     ON FH.FLAVOR = B.FLAVOR
#  ORDER BY TOTAL_ORDER DESC
# )
# SELECT C.FLAVOR
#   FROM C
#  LIMIT 3; 


-- 오류 쿼리:
# SELECT FIRST_HALF.FLAVOR,
#        SUM(FLAVOR.TOTAL_ORDER) AS total1
#        total2
#   FROM FIRST_HALF
#  INNER JOIN (SELECT FLAVOR, SUM(TOTAL_ORDER) AS total2 FROM JULY GROUP BY FLAVOR) AS SQ
#     ON FIRST_HALF.FLAVOR = SQ.FLAVOR
#  GROUP BY FIRST_HALF.FLAVOR; -- FIRST_HALF 테이블에서 FLAVOR가 PK이기 때문에 굳이 GROUP BY할 필요없음. 곧 바로 FLAVOR로 조인 가능함. 

SELECT
    T1.FLAVOR -- 최종적으로 맛을 출력
FROM
    FIRST_HALF T1
JOIN (
    -- 7월(JULY) 테이블의 맛별 주문량 합계 (집계)
    SELECT
        FLAVOR,
        SUM(TOTAL_ORDER) AS JULY_ORDER
    FROM
        JULY
    GROUP BY
        FLAVOR
) T2 ON T1.FLAVOR = T2.FLAVOR -- 두 테이블을 FLAVOR로 조인
ORDER BY
    (T1.TOTAL_ORDER + T2.JULY_ORDER) DESC -- 상반기 총 주문량 (T1) + 7월 총 주문량 (T2) 합계 기준 내림차순 정렬
LIMIT 3; -- 상위 3개만 선택




