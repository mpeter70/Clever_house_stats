--Uploades the data into Microsoft SQL Server and proceeded to clean the data.

--Deleted time stamp in Clevers_customers$ TABLE, CreatedOn column, created date_contact
SELECT *,
CONVERT(DATE,CreatedOn) 
FROM clever..Clever_customers$;


--ADD column date_contacted, drop column CreatedOn.

ALTER TABLE clever..Clever_customers$
ADD date_contacted DATE;


UPDATE clever..Clever_customers$
SET
	date_contacted = CONVERT(DATE,CreatedOn);

SELECT *
FROM clever..Clever_customers$;

ALTER TABLE clever..Clever_customers$
DROP COLUMN CreatedOn;

--deleterd time stamp in Cleavers_sales TABLE, addes sales_date Column, DROPED DaleDate COLUMN.

SELECT *,
CONVERT(DATE, SaleDate)
FROM clever..Clever_sales$;

ALTER TABLE Clever..Clever_sales$
ADD sold_date DATE;

UPDATE  Clever..Clever_sales$
SET
	sold_date = CONVERT(DATE, SaleDate);

ALTER TABLE Clever..Clever_sales$
DROP COLUMN SaleDate;

SELECT *

FROM clever..Clever_sales$;

--Will join customers table with the sales table and create buyer_info table.

SELECT c.CustID, c.FirstName, c.LastName, c.Address, c.City, c.County, c.State, c.Zip, c.date_contacted, S.Amount, s.sold_date
INTO clever..buyer_info
FROM clever..Clever_customers$ c
LEFT JOIN Clever_sales$ s ON c.CustID = s.CustID
ORDER BY date_contacted;

--I showed the amount of days it took the properties to sell and created a new table personal_base.

SELECT *,
DATEDIFF(DAY, date_contacted,sold_date) dur_time
INTO clever..personal_base
FROM clever..buyer_info;


--Concat first and last name if needed.

SELECT *,
CONCAT(FirstName, ' ', LastName) full_name
FROM clever..personal_base;




--creates a table with the sold properties.


SELECT *
INTO clever..properties_sold
FROM clever..personal_base
WHERE Amount >1;

--concat the first and last name if needed.

SELECT *,
CONCAT(FirstName, ' ', LastName) full_name
FROM clever..properties_sold;

--created a table with unsold properties.

SELECT *
FROM clever..personal_base
WHERE Amount IS NULL;

--deleted the columns Amount, sold_date, dur_time are not needed.
/* The three big trends I noticed was:
1. October was the second largest in terms of homes sold. That should be further investigated.
2. A little under fifty percent of the calls went to voicemail, it should be investigated if were returned by salespeople.
3. The average price of a home increased during the year; this is unique.

One thing I would recommend is interview the salesperson Carlton and discover how he vastly outperformed the rest of the sales team 
and implement his technique, which would be a overall benefit for the company.
The link for the public Tableau is: https://public.tableau.com/app/profile/mark.peterson5019/viz/MonthlyHomeSales_16474532551200/Dashboard1#3
*/


