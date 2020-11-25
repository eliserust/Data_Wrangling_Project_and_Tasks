-- Elise Rust
-- QBS 181 Midterm
-- November 2020

-- SQL was used much more minimally in this assignment because the automatic formatting of the .xpt file was better in R
-- Below, I used SQL to add/drop columns from tables, changed datatypes, adn re-named columns

-- import dataset into SQL
SELECT * FROM erust.diabetes

-- identify data-related issues (rename columns, change datatypes)
SELECT * FROM erust.diabetes
WHERE ["DID040"] is NULL

-- drop columns
ALTER TABLE erust.diabetes
DROP COLUMN [""]

-- change datatypes of columns
-- permanently change datatypes via creation of new column
ALTER TABLE erust.diabetes
ADD DID040 int
UPDATE erust.diabetes
SET DID040 = try_convert(int, ["DID040"])

ALTER TABLE erust.diabetes
ADD DIQ010 int
UPDATE erust.diabetes
SET DIQ010 = try_convert(int, ["DIQ010"])

ALTER TABLE erust.diabetes
DROP COLUMN ["DIQ010"]

ALTER TABLE erust.diabetes
DROP COLUMN ["DID040"]

-- temporarily change datatype via SELECT function
SELECT try_convert(int, ["DIQ010"]) FROM erust.diabetes

-- add new columns
ALTER TABLE erust.diabetes
ADD DIQ159 varchar(50)

UPDATE erust.diabetes
SET DIQ159 = 'Go to DIQ.050'
WHERE ["DID040"] < 12 AND ["DIQ010"] = 1

UPDATE erust.diabetes
SET DIQ159 = 'Go to DIQ.070'
WHERE ["DID040"] >= 12 AND ["DIQ010"] = 3
 
-- rename columns
EXEC sp_RENAME 'erust.diabetes.["SEQN"]' , 'ResponderNumber', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ160"]' , 'DIQ160', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ170"]' , 'DIQ170', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ172"]' , 'DIQ172', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175A"]' , 'DIQ175A', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175B"]' , 'DIQ175B', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175C"]' , 'DIQ175C', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175D"]' , 'DIQ175D', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175E"]' , 'DIQ175E', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175F"]' , 'DIQ175F', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175G"]' , 'DIQ175G', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175H"]' , 'DIQ175H', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175I"]' , 'DIQ175I', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175J"]' , 'DIQ175J', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175K"]' , 'DIQ175K', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175L"]' , 'DIQ175L', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175M"]' , 'DIQ175M', 'COLUMN'
EXEC sp_RENAME 'erust.diabetes.["DIQ175N"]' , 'DIQ175N', 'COLUMN'
etc.

-- print random rows
SELECT top 10 * FROM erust.diabetes
ORDER BY NEWID()
