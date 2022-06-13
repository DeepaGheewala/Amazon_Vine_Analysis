'Display data from Customer Table'
SELECT *
FROM customers_table;

SELECT *
FROM products_table;

SELECT *
FROM review_id_table;

SELECT *
FROM vine_table;

DROP TABLE IF EXISTS Vine_total_votes_above20;
SELECT * INTO Vine_total_votes_above20
FROM vine_table
WHERE total_votes > 20;

DROP TABLE IF EXISTS Vine_Above50_percent;
SELECT *,
	CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) AS Above50_percent INTO Vine_Above50_percent
FROM Vine_total_votes_above20
WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5;
  
DROP TABLE IF EXISTS Vine_paid_5star;
SELECT
    (SELECT cast(count(*) AS float)
     FROM Vine_Above50_percent
     WHERE vine = 'Y') AS total_Paid,

    (SELECT cast(count(*) AS float)
     FROM Vine_Above50_percent
     WHERE vine = 'Y'
       AND star_rating = 5) AS "5_star_rating",
     
	 NULL AS "5_star_percentage" 
	 INTO Vine_paid_5star;
		 
UPDATE Vine_paid_5star
SET "5_star_percentage" = CONCAT (
								cast(
									round(
										CAST (("5_star_rating"/total_Paid) * 100 AS Numeric(5, 2))
										, 2) 
									AS varchar(10000))
								,'%');

SELECT total_paid as "Total Paid",
       "5_star_rating" as "5* Rating",
	   "5_star_percentage" as "5* Percentage"
FROM Vine_paid_5star;


DROP TABLE IF EXISTS Vine_unpaid_5star;
SELECT
  (SELECT cast(count(*) AS float)
   FROM Vine_Above50_percent
   WHERE vine = 'N') AS total_unPaid,

  (SELECT cast(count(*) AS float)
   FROM Vine_Above50_percent
   WHERE vine = 'N'
     AND star_rating = 5) AS "5_star_rating",
   
   NULL AS "5_star_percentage" INTO Vine_unpaid_5star;
   
UPDATE Vine_unpaid_5star
SET "5_star_percentage" = CONCAT (
								cast(
									round(
										CAST (("5_star_rating"/total_unPaid) * 100 AS Numeric(5, 2))
										, 2) 
									AS varchar(10000))
								,'%');
SELECT total_unpaid as "Total UnPaid",
       "5_star_rating" as "5* Rating",
	   "5_star_percentage" as "5* Percentage"
FROM Vine_unpaid_5star;