-- Elise Rust
-- QBS 181-Exercise1
-- 22 September 2020

-- Question 1.	Find the data types for each table Demographics, PhoneCall, Phonecall_Encounters,Conditions
-- a.	Demographics:
--   i.	contactid = nvarchar
--   ii.	gendercode = nvarchar
--   iii.	tri_age = float
--   iv.	parentcustomeridname = nvarchar
--    v.	tri_imaginecareenrollmentstatus = float
--    vi.	address1_stateorprovince = nvarchar
--    vii.	tri_imaginecareenrollmentemailsentdate = nvarchar
---   viii.	tri_enrollmentcompletedate = nvarchar

-- b.	PhoneCall
--  i.	tri_CustomerIDEntityReference = varchar
--  ii.	CallType = varchar
--  iii.	CallDuration = varchar
--  iv.	CallOutcome = varchar
--  v.	CallStartTime = varchar

-- c.	Phonecall_Encounters
--  i.	CustomerID = nvarchar
--  ii.	EncounterCode = float

-- d.	Conditions
--  i.	tri_patientid = nvarchar
--  ii.	tri_name = nvarchar


-- Question 2.	How do we fix this error?
-- Error: Conversion failed when converting the nvarchar value 'NULL' to data type int.

-- There are three ways to convert data types:
-- 1.	cast(expression) RETURNS int
-- 2.	convert(target_type, expression, date_style smallint) RETURNS <data type>
-- 3.	try_convert(target_type, expression, date_style smallint) RETURNS <data type>

--Try all three of these options, this will temporarily update the data type. Option 3 works correctly.

SELECT try_convert(int, gendercode) FROM erust.Demo

-- Question 3.	How do we fix this error permanently?
ALTER TABLE erust.Demo
ADD gendercodeint int

UPDATE erust.Demo
SET gendercodeint = try_convert(int, gendercode)
