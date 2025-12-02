/* 문제:
- 진료예약번호, 환자이름, 환자번호, 진료과코드, 의사이름, 진료예약일시 항목이 출력
- 진료예약일시를 기준으로 오름차순 정렬
- 2022년 4월 13일 취소되지 않은 흉부외과(CS) 진료 예약 내역
*/
WITH A AS
(
    SELECT APNT_NO, -- 진료예약번호
           MCDP_CD, -- 진료과코드
           MDDR_ID, -- 의사ID
           PT_NO,   -- 환자번호
           APNT_YMD -- 진료예약일시 
      FROM APPOINTMENT
     WHERE 1=1 
           AND DATE(APNT_YMD) = '2022-04-13'
           AND APNT_CNCL_YN = 'N'
           AND MCDP_CD = 'CS'
)
SELECT A.APNT_NO, 
       PATIENT.PT_NAME, 
       A.PT_NO, 
       A.MCDP_CD, 
       DOCTOR.DR_NAME,
       A.APNT_YMD
  FROM A
  LEFT JOIN PATIENT
    ON A.PT_NO = PATIENT.PT_NO
  LEFT JOIN DOCTOR
    ON A.MDDR_ID = DOCTOR.DR_ID
 ORDER BY APNT_YMD ASC; 