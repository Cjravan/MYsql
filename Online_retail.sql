use cc;
select * from online_retail;

describe online_retail;

# **What are the total sales revenue generated from the dataset?
select sum(quantity * unitprice) as total_sales_revenue from online_retail;
# **How many unique products are listed in the dataset?
select distinct(description) as unique_products from online_retail;
# **What are the top 5 best-selling products by quantity?
select  distinct(description) as dd, sum(quantity) as sq from online_retail group by dd
order by sq desc limit 5;
# **Which customer has made the highest number of purchases?
select customerid, count(distinct invoiceno) as num_purchase from online_retail 
group by customerid order by num_purchase desc limit 1 ;
# **What is the average quantity of products purchased per transaction?
select avg(quantity) as avg_quantity, STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i') = STR_TO_DATE('12/1/2010 8:26', '%m/%d/%Y %H:%i')
as per_transaction, invoicedate from online_retail group by invoiceno; 
# **Which country has the highest total sales revenue?
select sum(quantity * unitprice) as total_sales_revenue, country from online_retail group by country 
order by total_sales_revenue desc limit 1;
# **How many transactions were made on each day?
select str_to_date(invoicedate, '%m/%d/%Y') as transaction_per_day, count(distinct invoiceno) from online_retail group by 
transaction_per_day;
# **What is the average unit price of products?
select description, avg(unitprice) as avg_price from online_retail group by description;
select avg(unitprice) as avg_price from online_retail;
# **Which products have the highest and lowest unit prices?
select description, max(unitprice) as max_price, min(unitprice) as min_price from online_retail ;
-- SELECT description, unitprice
-- FROM online_retail
-- WHERE unitprice IN (
--     SELECT MAX(unitprice) AS max_price FROM online_retail
--     UNION ALL
--     SELECT MIN(unitprice) AS min_price FROM online_retail
-- );
-- select description, min(unitprice) from online_retail order by description asc;
-- select description, unitprice from online_retail where unitprice =0.1;
# **What is the distribution of quantities purchased per product?
select description, sum(quantity) as per_order_count, customerid from online_retail group by description;
# **Which day of the week has the highest sales revenue?
select dayname(str_to_date(invoicedate, '%m/%d/%y %h:%i')) as day_of_week, sum(quantity * unitprice) as total_sales_revenue
from online_retail group by dayofweek(str_to_date(invoicedate, '%m/%d/%y %h:%i'))
order by total_sales_revenue desc limit 1;
# **What is the average transaction value per customer?
select customerid, avg(quantity * unitprice) as avg_transaction from online_retail group by customerid;
# **Which customers have made purchases on multiple days?
select customerid, count(distinct date(invoicedate)) as days from online_retail group by customerid
having count(distinct date(invoicedate))>1;
# **What is the distribution of invoice quantities?
select quantity, count(*) as frequency from online_retail group by quantity order by quantity;
# **How many transactions were made by each customer?
select customerid, count(*) as transactions from online_retail group by customerid order by transactions desc;
# **Which country has the highest average transaction value?
select country,  avg(quantity * unitprice) as avg_transaction_value from online_retail group by country
order by avg_transaction_value desc limit 1;
# **What is the total sales revenue per product category?
select stockcode, description, sum(quantity * unitprice) as total_sales_revenue
from online_retail group by stockcode;
# **Which products have the highest and lowest total sales revenue?
(select description, sum(quantity * unitprice) as sales from online_retail 
group by description order by sales desc limit 1) 
union all
(select description, sum(quantity * unitprice) as sales from online_retail 
group by description order by sales asc limit 1);
# **How many unique customers are there in each country?
select distinct(count(customerID))as unique_count, country from online_retail group by country;
# **What is the average unit price per product category?
select distinct(description), avg(unitprice) as avg_unit_price from online_retail group by description;
# **How does the sales revenue vary by month?
select sum(quantity * unitprice) as sales_revenue, str_to_date(invoicedate, '%m/%y') as monthly from online_retail
group by monthly;
# **Which customers have the highest and lowest average transaction values?
(select customerid, avg(quantity * unitprice) as avg_tv from online_retail
group by customerid order by avg_tv desc limit 1)
union all
(select customerid, avg(quantity * unitprice) as avg_tv from online_retail
group by customerid order by avg_tv asc limit 1);
# **What is the distribution of transaction quantities per customer?
select customerid, sum(quantity) as distribution_t_q from online_retail
group by customerid order by distribution_t_q;
# **Which products are frequently purchased together?
select group_concat(description order by description asc) as product_combination,
count(*) as frequency from online_retail group by invoiceno 
having count(*) > 1 order by frequency desc;
# **What is the average number of transactions per day?
select avg(quantity * unitprice) as avg_tv, str_to_date(invoicedate, '%m/%d/%y') as per_day
from online_retail group by per_day;
SELECT DATE_FORMAT(STR_TO_DATE(invoicedate, '%m/%d/%y'), '%Y-%m-%d') AS transaction_date,
       COUNT(*) AS total_transactions,
       AVG(quantity * unitprice) AS average_transaction_value
FROM online_retail
GROUP BY transaction_date;
# **Which customers have the highest and lowest total sales revenue?
(select sum(quantity * unitprice) as total_sales_revenue, customerid from online_retail
group by customerid order by total_sales_revenue desc limit 1)
union all
(select sum(quantity * unitprice) as total_sales_revenue, customerid from online_retail
group by customerid order by total_sales_revenue asc limit 1);
# **How does the distribution of transaction quantities vary by country?
select sum(quantity * unitprice) as count_transaction, country from online_retail
group by country order by count_transaction;
# **What is the total sales revenue per month?
select sum(quantity * unitprice) as total_sales_revenue, date_format(str_to_date(invoicedate, '%m/%d/%y'), '%m/%d/%y') as 
per_month from online_retail group by per_month;
# **Which products have experienced the highest and lowest price fluctuations?
(select description, max(unitprice) - min(unitprice) as price_fluctuation from online_retail 
group by description order by price_fluctuation desc limit 1)
union all
(select description, max(unitprice) - min(unitprice) as price_fluctuation from online_retail 
group by description order by price_fluctuation asc limit 1);
# **What is the average time between consecutive transactions for each customer?
SELECT CustomerID,
       AVG(TIMESTAMPDIFF(SECOND, prev_transaction_date, invoicedate)) AS avg_time_between_transactions
FROM (
    SELECT CustomerID,
           invoicedate,
           LAG(invoicedate) OVER (PARTITION BY CustomerID ORDER BY invoicedate) AS prev_transaction_date
    FROM online_retail
) AS t
GROUP BY CustomerID;


select * from online_retail;

/*



*/