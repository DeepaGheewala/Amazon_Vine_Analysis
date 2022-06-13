--Display data from Customer Table'
SELECT *
FROM customers_table;

--Display data from Product Table'
SELECT *
FROM products_table;

--Display data from Review_ID Table'
SELECT *
FROM review_id_table;

--Display data from Vine Table'
SELECT *
FROM vine_table;



--Create a table to store Vine total votes above 20 votes
DROP TABLE IF EXISTS Vine_total_votes_above20;
SELECT * INTO Vine_total_votes_above20
FROM vine_table
WHERE total_votes > 20;
--select * from Vine_total_votes_above20 [To check votes above 20]

--Create a table to store Vine above 50 Percent votes
-- helpful_Votes/ Total_votes
DROP TABLE IF EXISTS Vine_Above50_percent;
SELECT *,
	CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) AS Above50_percent INTO Vine_Above50_percent
FROM Vine_total_votes_above20
WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5;
--Select * from Vine_Above50_percent [ to check the Vine data for 50 percent and above votes]  
  
--Calculation for Paid Votes  
--Vine Paid votes with 5 star ratings
DROP TABLE IF EXISTS Vine_paid_5star;
SELECT
    (SELECT cast(count(*) AS float)
     FROM Vine_Above50_percent
     WHERE vine = 'Y') AS total_Paid,

    (SELECT cast(count(*) AS float)
     FROM Vine_Above50_percent
     WHERE vine = 'Y'
       AND star_rating = 5) AS "5_star_rating",
     
	 (SELECT cast(count(*) AS float)
     FROM Vine_Above50_percent
     WHERE vine = 'Y'
       AND star_rating <> 5) AS "Non_5_star_rating",
	   
	 NULL AS "5_star_percentage" 
	 INTO Vine_paid_5star;
--Select * from Vine_paid_5star	[Calculate for the Paid 5 star vote data]	
		
--Updating percentage column in the Vine_Paid_5Star .
UPDATE Vine_paid_5star
SET "5_star_percentage" = CONCAT (
								cast(
									round(
										CAST (("5_star_rating"/total_Paid) * 100 AS Numeric(5, 2))
										, 2) 
									AS varchar(10000))
								,'%');

--Select all values for Paid votes
SELECT total_paid as "Total Paid",
       "5_star_rating" as "5* Rating",
	   "Non_5_star_rating" as "Other than 5* Rating",
	   "5_star_percentage" as "5* Percentage"
FROM Vine_paid_5star;




--Calculation for UnPaid Votes  
--Vine UnPaid votes with 5 star ratings
DROP TABLE IF EXISTS Vine_unpaid_5star;
SELECT
  (SELECT cast(count(*) AS float)
   FROM Vine_Above50_percent
   WHERE vine = 'N') AS total_unPaid,

  (SELECT cast(count(*) AS float)
   FROM Vine_Above50_percent
   WHERE vine = 'N'
     AND star_rating = 5) AS "5_star_rating",
   
   (SELECT cast(count(*) AS float)
     FROM Vine_Above50_percent
     WHERE vine = 'N'
       AND star_rating <> 5) AS "Non_5_star_rating",
	   
   NULL AS "5_star_percentage" INTO Vine_unpaid_5star;
   
--Updating percentage column in the Vine_UnPaid_5Star .   
UPDATE Vine_unpaid_5star
SET "5_star_percentage" = CONCAT (
								cast(
									round(
										CAST (("5_star_rating"/total_unPaid) * 100 AS Numeric(5, 2))
										, 2) 
									AS varchar(10000))
								,'%');
								
--Select all values for UnPaid votes							
SELECT total_unpaid as "Total UnPaid",
       "5_star_rating" as "5* Rating",
	   "Non_5_star_rating" as "Other than 5* Rating",
	   "5_star_percentage" as "5* Percentage"
FROM Vine_unpaid_5star;