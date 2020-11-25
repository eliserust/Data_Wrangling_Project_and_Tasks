-- Elise Rust
-- QBS 181-Exercise2
-- 24 September 2020

-- Questions pertain to pre-loaded datasets provided by Professor Yapalparvi regarding medical data of patients in the Upper Valley

-- Question1: How many patients had hypertension and belonged to Dartmouth-Hitchcock?
SELECT distinct *
FROM dbo.Demographics a
INNER JOIN dbo.Conditions b
ON a.contactid=b.tri_patientid
WHERE tri_name = 'Hypertension' AND parentcustomeridname = 'Dartmouth-Hitchcock'

-- Question 2: What is the average age of each patient having Hypertension,COPD, and CHF?
SELECT tri_name, avg(tri_age) as average_age
FROM dbo.Demographics a
INNER JOIN dbo.Conditions b
ON a.contactid=b.tri_patientid
WHERE tri_name = 'Hypertension' OR tri_name = 'COPD' OR tri_name LIKE 'C%'
GROUP BY tri_name

-- Question 3: How many Male and Female patients had Hypertension, COPD, and CHF?

-- male patients
SELECT distinct *
FROM dbo.Demographics a
INNER JOIN dbo.Conditions b
ON a.contactid=b.tri_patientid
WHERE try_convert(int, gendercode) = 1 AND (tri_name = 'Hypertension' OR tri_name = 'COPD' OR tri_name = 'Congestive Heart Failure')

-- female patients
SELECT distinct *
FROM dbo.Demographics a
INNER JOIN dbo.Conditions b
ON a.contactid=b.tri_patientid
WHERE try_convert(int, gendercode) = 2 AND (tri_name = 'Hypertension' OR tri_name = 'COPD' OR tri_name = 'Congestive Heart Failure')
