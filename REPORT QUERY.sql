SELECT COUNT(R_REELID) FROM TBL_REELS WHERE  R_ROLLID='1148836' GROUP BY R_SIZE 
SELECT PO_QUALITY,PO_COLOURGRAIN,PO_GSM FROM TBL_PRODUCTIONORDER WHERE PO_ROLLID='1148836'


SELECT DISTINCT R_SIZE FROM TBL_REELS WHERE  R_ROLLID='1148836'

SELECT COUNT(R_REELID) FROM TBL_REELS WHERE  R_ROLLID='1148836' AND R_SIZE=' 69' GROUP BY CONVERT(date, R_DATETIME) 


SELECT PO_ORDEREDQTY FROM TBL_PRODUCTIONORDER WHERE  PO_ROLLID='1148836' AND PO_SIZE='69'
