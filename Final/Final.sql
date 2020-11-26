-- Elise Rust
-- QBS 181 Final
-- November 25 2020

-- Datasets used are all provided by Professor Yapalparvi

-- Supplement to Question #1:
-- Convert "ObservedTime" column in IC_BP_v2.csv from int type to datetime
SELECT * FROM erust.IC_BP_v2

ALTER TABLE erust.IC_BP_v2
ADD ObservedDate datetime
UPDATE erust.IC_BP_v2
SET ObservedDate = CONVERT(int, cast(ObservedTime as datetime), 120)


-- Question :2 Merge the tables dbo.Demographics, dbo.Conditions, and dbo.TextMessages. Obtain the final dataset such that we have 1 row per ID by choosing the
--            latest date when the text was sent

CREATE TABLE erust.Demo_Cond_Text(
	contactid nvarchar(255),
	gendercode nvarchar(255),
	tri_age float,
	parentcustomeridname nvarchar(255),
	tri_imaginecareenrollmentstatus float,
	address1_stateorprovince nvarchar(255),
	tri_imaginecareenrollmentemailsentdate nvarchar(255),
	tri_enrollmentcompletedate nvarchar (255),
	gender int,
	tri_patientid nvarchar(255),
	tri_name nvarchar(255),
	tri_contactId nvarchar(255),
	SenderName nvarchar(255),
	TextSentDate datetime	
)

INSERT INTO erust.Demo_Cond_Text
   SELECT a.*, b.*, c.* FROM dbo.Demographics a
   INNER JOIN dbo.Conditions b
   ON a.contactid = b.tri_patientid
   INNER JOIN dbo.Text c
   ON a.contactid = c.tri_contactId

SELECT * FROM erust.Demo_Cond_Text
INNER JOIN (
    SELECT contactid, max(TextSentDate) as latest_date
    FROM erust.Demo_Cond_Text
    GROUP BY contactid
) AS child ON (erust.Demo_Cond_Text.contactid = child.contactid) AND (erust.Demo_Cond_Text.TextSentDate = latest_date)
