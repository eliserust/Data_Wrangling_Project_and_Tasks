-- Elise Rust
-- QBS 181-Exercise 3
-- 1 October 2020


-- Question 1.	List the number of patients in each chronic condition. Only include conditions with more than 100 patients. 

SELECT count(tri_patientid), tri_name FROM dbo.Conditions
GROUP BY tri_name
HAVING count(tri_patientid) > 100

-- Question 2.	What is average height of both an inpatient and an outpatient where patient’s age is over 65

-- inpatients over 65
SELECT avg(b.MEAS_VALUE) AS height, a.DOB_CATEGORY FROM dbo.Inpatient a
INNER JOIN dbo.Flowsheets b
ON a.NEW_PAT_ENC_CSN_ID = b.PAT_ENC_CSN_ID
WHERE DISP_NAME LIKE '%height%'
GROUP BY DOB_CATEGORY

-- outpatients over 65
SELECT avg(b.MEAS_VALUE) AS height, a.PATIENT_DOB_CATEGORY FROM     dbo.Outpatient a
INNER JOIN dbo.Flowsheets b
ON a.NEW_PAT_ENC_CSN_ID = b.PAT_ENC_CSN_ID
WHERE DISP_NAME LIKE '%height%'
GROUP BY PATIENT_DOB_CATEGORY

-- Question 3.	What are the average height and weight of a patient suffering with Hypertension? Calculate the BMI and then compare it with actual BMI in the data

-- Calculate the BMI and then compare it with actual BMI in the data
SELECT * FROM dbo.Flowsheets

-- Create new table from dbo.Flowsheets with columns "height", "weight", "BMI"
SELECT PAT_ENC_CSN_ID, MEAS_VALUE, DISP_NAME INTO erust.height_weight FROM dbo.Flowsheets

ALTER TABLE erust.height_weight
ADD height int, weigh int, BMI int

UPDATE erust.height_weight
SET height = MEAS_VALUE WHERE DISP_NAME LIKE '%Height%'

UPDATE erust.height_weight
SET weigh = MEAS_VALUE WHERE DISP_NAME LIKE '%Weight%'

UPDATE erust.height_weight
SET BMI = weigh/height

ALTER TABLE erust.height_weight
DROP COLUMN MEAS_VALUE, DISP_NAME

-- Merge with dbo.Conditions
SELECT cast(tri_patientid as float), tri_name FROM dbo.Conditions a
JOIN erust.height_weight b
ON a.tri_patientid = b.PAT_ENC_CSN_ID

-- Calculate average height, weight, BMI for people with Hypertension
SELECT avg(height) as avg_height, avg(weight) as avg_weight, avg(BMI) as avg_bmi FROM erust.height_weight
GROUP BY tri_name

-- Calculate actual BMI directly from dbo.Flowsheets
SELECT avg(b.MEAS_VALUE) AS avg_bmi, a.tri_name FROM dbo.Conditions a
INNER JOIN dbo.Flowsheets b
ON a.tri_patientid = b.PAT_ENC_CSN_ID
WHERE DISP_NAME LIKE 'BMI%'
GROUP BY tri_name
