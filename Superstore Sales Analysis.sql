-- Create Database called sales 
Create Database sales;

-- use database 
use sales;

-- Bulk Insert Data --
select * from sales.sales_data_update;

SELECT count(*) FROM sales.sales_data_update; -- 9033 data

-- CHECK IF ALL THE DATA IS IN THE PROPER FORMAT

select count(*) from sales_data_update
WHERE 
	Row_ID IS NULL OR Row_ID < 0 or Row_ID = ''; -- 0
    select count(*) from sales_data_update
WHERE 
    Order_Priority IS NULL OR Order_Priority < 0 or Order_Priority = ''; -- 0
    select count(*) from sales_data_update
WHERE 
    Discount IS NULL OR Discount < 0 or Discount = ''; -- 803
     select count(*) from sales_data_update
WHERE 
    Unit_Price IS NULL OR Unit_Price < 0  OR  Unit_Price = '' ; -- 0
     select count(*) from sales_data_update
WHERE 
    Shipping_Cost IS NULL OR Shipping_Cost < 0 OR Shipping_Cost = ''; -- 0
     select count(*) from sales_data_update
WHERE 
    Customer_ID IS NULL OR Customer_ID < 0 or Customer_ID = ''; -- 0
     select count(*) from sales_data_update
WHERE 
    Product_Base_Margin IS NULL OR Product_Base_Margin < 0 OR Product_Base_Margin = ''; -- 0
     select count(*) from sales_data_update
WHERE 
    Postal_Code IS NULL OR Postal_Code < 0 OR Postal_Code = ''; -- 0
     select count(*) from sales_data_update
WHERE 
    Quantity_Ordered_new IS NULL OR Quantity_Ordered_new <= 0 OR Quantity_Ordered_new = ''; -- 0
     select count(*) from sales_data_update
WHERE 
    Sales IS NULL OR Sales <= 0 OR Sales = ''; -- 0
     select count(*) from sales_data_update
WHERE 
    Profit IS NULL OR Profit < 0 or Profit = ''; -- 4365
    
    -- find out profit error
    
SELECT Order_ID, Customer_Name, Sales, Profit , Discount
FROM sales_data_update
WHERE Profit < 0 
ORDER BY Profit ASC; 

-- fixing the error of profit 
UPDATE sales_data_update
SET Profit = ABS(Profit) 
WHERE Profit < 0;


-- fixed the error of profit 
select count(*) from sales_data_update
WHERE 
    Profit IS NULL OR Profit < 0 or Profit = ''; -- 0
    
    -- fixing date formate
select Customer_ID, Customer_Name from sales_data_update;
SELECT 
    Customer_ID,
    Customer_Name,
    YEAR(STR_TO_DATE(Order_Date, '%m/%d/%Y')) AS Year,
    MONTHNAME(STR_TO_DATE(Order_Date, '%m/%d/%Y')) AS Month,
     day(STR_TO_DATE(Order_Date, '%m/%d/%Y')) AS day
FROM sales_data_update;

SELECT 
    Ship_Date,
    YEAR(STR_TO_DATE(Ship_Date, '%m/%d/%Y')) AS Year,
    MONTHNAME(STR_TO_DATE(Ship_Date, '%m/%d/%Y')) AS Month,
     day(STR_TO_DATE(Ship_Date, '%m/%d/%Y')) AS day
FROM sales_data_update;

-- fixed date formate

-- FIRST ORDER DATE and LAST ORDER DATE
SELECT 
	MIN(str_to_date(Order_Date, '%m/%d/%Y')) AS FIRST_ORDER_DATE, -- 2010-01-02
    MAX(str_to_date(Order_Date, '%m/%d/%Y')) AS LAST_ORDER_DATE -- 2013-12-31
FROM sales_data_update;

-- customer Recent order and oldest order 
SELECT
	Customer_Name,
	MAX(Order_Date) AS LAST_ORDER_DATE,
    MIN(Order_Date) AS FIRST_ORDER_DATE
FROM sales_data_update
GROUP BY Customer_Name;

-- DATE DIFFERENCE FRIST ORDER TO LAST ORDER
SELECT
    Customer_Name,
    MAX(STR_TO_DATE(Order_Date, '%m/%d/%Y')) AS LAST_ORDER_DATE,
    DATEDIFF(
        (SELECT MAX(STR_TO_DATE(Order_Date, '%m/%d/%Y')) FROM sales_data_update), 
        MIN(STR_TO_DATE(Order_Date, '%m/%d/%Y'))
    ) AS RECENCY
FROM sales_data_update
GROUP BY Customer_Name;

-- unique order
select 
count(
DISTINCT Quantity_ordered_new)
 from sales_data_update
 GROUP BY Quantity_ordered_new
 order by Quantity_ordered_new desc ;
 
 /* RFM Segmentation: 
Segment the Customers based on their Recency (R), Frequency (F) & Monetary (M)
*/

CREATE OR replace VIEW RFM_SCORE AS
WITH CUSTOMER_RFM_calculations AS
( SELECT
    Customer_Name,
    MAX(STR_TO_DATE(Order_Date, '%m/%d/%Y')) AS LAST_ORDER_DATE,
    DATEDIFF(
        (SELECT MAX(STR_TO_DATE(Order_Date, '%m/%d/%Y')) FROM sales_data_update), 
        MIN(STR_TO_DATE(Order_Date, '%m/%d/%Y'))
    ) AS RECENCY_VALUE,
     COUNT(DISTINCT Quantity_ordered_new) AS FREQUENCY_VALUE,
     ROUND(SUM(SALES),0) AS MONETARY_VALUE
FROM sales_data_update
GROUP BY Customer_Name),

RFM_SCORE AS
(SELECT 
	C.*,
    NTILE(4) OVER (ORDER BY RECENCY_VALUE DESC) AS R_SCORE,
    NTILE(4) OVER (ORDER BY FREQUENCY_VALUE ASC) AS F_SCORE,
    NTILE(4) OVER (ORDER BY MONETARY_VALUE ASC) AS M_SCORE
FROM CUSTOMER_RFM_calculations AS C)

SELECT
	R.Customer_Name,
    R.RECENCY_VALUE,
    R_SCORE,
    R.FREQUENCY_VALUE,
    F_SCORE,
    R.MONETARY_VALUE,
    M_SCORE,
    (R_SCORE + F_SCORE + M_SCORE) AS TOTAL_RFM_SCORE,
    CONCAT_WS('', R_SCORE, F_SCORE, M_SCORE) AS RFM_SCORE_COMBINATION
FROM RFM_SCORE AS R;

SELECT * FROM RFM_SCORE WHERE RFM_SCORE_COMBINATION = '111';

SELECT RFM_SCORE_COMBINATION FROM RFM_SCORE;



CREATE OR REPLACE VIEW RFM_ANALYSIS AS
SELECT 
    RFM_SCORE.*,
    CASE
        WHEN RFM_SCORE_COMBINATION IN (111, 112, 121, 132, 211, 211, 212, 114, 141) THEN 'CHURNED CUSTOMER'
        WHEN RFM_SCORE_COMBINATION IN (133, 134, 143, 224, 334, 343, 344, 144) THEN 'SLIPPING AWAY, CANNOT LOSE'
        WHEN RFM_SCORE_COMBINATION IN (311, 411, 331) THEN 'NEW CUSTOMERS'
        WHEN RFM_SCORE_COMBINATION IN (222, 231, 221,  223, 233, 322) THEN 'POTENTIAL CHURNERS'
        WHEN RFM_SCORE_COMBINATION IN (323, 333,321, 341, 422, 332, 432) THEN 'ACTIVE'
        WHEN RFM_SCORE_COMBINATION IN (433, 434, 443, 444) THEN 'LOYAL'
    ELSE 'Other'
    END AS CUSTOMER_SEGMENT
FROM RFM_SCORE;


SELECT
	CUSTOMER_SEGMENT,
    COUNT(*) AS NUMBER_OF_CUSTOMERS,
    ROUND(AVG(MONETARY_VALUE),0) AS AVERAGE_MONETARY_VALUE
FROM RFM_ANALYSIS
GROUP BY CUSTOMER_SEGMENT;