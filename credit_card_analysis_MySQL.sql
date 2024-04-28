create database cc;
use cc;
select * from transactions;
select * from cc_info;
describe cc_info;
describe transactions;
drop table cc_info;

# Update the credit card limit to $7000 for all records in the "cc_info" table.
-- START TRANSACTION;
-- update cc_info set credit_card_limit = '7000';
-- COMMIT;
-- ROLLBACK;
# Delete a specific record from the "transactions" table based on the credit card number.
start transaction;
delete from transactions where credit_card = "1013870087888817";
rollback;
# Select all transactions that occurred on a specific date.
select transaction_dollar_amount, date from transactions where date(date) = '2015-09-11';
# Select the total transaction amount for each credit card.
select distinct(credit_card), sum(transaction_dollar_amount) from transactions group by credit_card;
# Retrieve the city and state of credit card holders with a credit limit greater than $5000.
select state, city from cc_info where credit_card_limit > 5000;
# Calculate the average transaction amount.
select avg(transaction_dollar_amount) as avg_transaction_amt from transactions group by credit_Card;
# Retrieve the latest transaction for each credit card.
select max(date), credit_card, transaction_dollar_amount from transactions group by credit_card
order by transaction_dollar_amount desc;
select max(date),credit_card, transaction_dollar_amount from transactions group by credit_card;
-- SELECT t1.date, t1.credit_card, t1.transaction_dollar_amount
-- FROM transactions t1
-- INNER JOIN (
--     SELECT credit_card, MAX(date) AS max_date
--     FROM transactions
--     GROUP BY credit_card
-- ) t2 ON t1.credit_card = t2.credit_card AND t1.date = t2.max_date;
# Calculate the total number of transactions for each state.
select count(t.transaction_dollar_amount), c.state from transactions as t inner join 
cc_info as c on t.credit_card = c.credit_card group by c.state;
# Join the "cc_info" and "transactions" tables to get the credit card details along with the transaction amount.
select t. credit_card, c.credit_card, t.date, c.city, c.state, c.credit_card_limit, t.transaction_dollar_amount
from transactions as t join cc_info as c on  t.credit_card = c.credit_card;
select distinct(credit_card_limit) from cc_info;
# Find the credit card with the highest transaction amount.
select t.credit_card, max(t.transaction_dollar_amount) as mx, c.credit_card from transactions as t join
cc_info as c on t.credit_card = c.credit_card group by t.credit_card order by mx desc limit 1;
# Retrieve the credit card number and transaction amount for transactions exceeding the credit card limit.
select t.credit_Card, t.credit_card, t.transaction_dollar_amount, c.credit_card_limit from transactions as t
inner join cc_info as c on t.credit_card = c.credit_card where t.transaction_dollar_amount > c.credit_card_limit
group by t.credit_card;
# Calculate the total transaction amount for each city.
select sum(t.transaction_dollar_amount) as total_transaction_amount , c.city from transactions as t join 
cc_info as c on t.credit_card = c.credit_card group by c.city;
# Find the credit card holders who made transactions in both New York and California.
select t.credit_card, c.credit_card, t.transaction_dollar_amount, c.city from transactions as t
join cc_info as c on t.credit_card = c.credit_card where c.city in ("new York", "California") group by t.credit_card having 
count(distinct c.city) = 2;
# Retrieve the credit card numbers and total transaction amounts for the top 10 highest spenders.
select credit_card, sum(transaction_dollar_amount) as tda from transactions group by credit_card 
order by tda desc limit 10;
# Calculate the average transaction amount for each month.
select avg(transaction_dollar_amount) as atd, date_format(date, "%y-%m") as df from transactions group by df order by 
df desc;
# Find the credit card holders with consecutive transactions exceeding $500.
select credit_Card, transaction_dollar_amount from transactions where transaction_dollar_amount >= 500 group by credit_card;
# Identify any duplicate transactions in the "transactions" table.
select credit_Card, transaction_dollar_amount, date from transactions where (credit_Card, transaction_dollar_amount, date) in (select
credit_Card, transaction_dollar_amount, date group by credit_card, transaction_dollar_amount, date having count(*) > 1);
select *, count(*) as duplicate_count from transactions group by credit_card, date, transaction_dollar_amount having count(*) > 1;
# Retrieve the credit card numbers with more than 5 transactions in a day.
select credit_card, date, count(*) as tda, date_format(date, '%m-%d') as dd from transactions group by credit_card, dd having count(*) > 5;
# Calculate the total transaction amount for each zip code.
select c.zipcode, c.city, sum(t.transaction_dollar_amount) as total_amount from transactions as t join 
cc_info as c on t.credit_card = c.credit_card group by c.zipcode, c.city;
# Identify any outliers in the transaction dollar amount using quartiles.
# Find the credit card holders with transactions in a specific longitude and latitude range.
alter table transactions change column `long` Longitude double;
select credit_card, Longitude, lat from transactions where longitude = "-80.1741379707697" and lat = "40.2908953862502";
# Retrieve the credit card numbers with transactions on weekends (Saturday and Sunday).
select distinct(credit_card), transaction_dollar_amount, date_format(date, "%y-%m-%d") from transactions where
dayofweek(date) in (1,7);
# Generate a report showing the trend of transaction amounts over time (monthly or quarterly).
# Month wise
select date_format(date, "%y-%m") as monthly, sum(transaction_dollar_amount) as sums from transactions group by 
date_format(date, "%y-%m") order by date_format(date, "%y-%m");
# Year wise
SELECT CONCAT(YEAR(date), '-', QUARTER(date)) AS quarter,
       SUM(transaction_dollar_amount) AS total_transaction_amount
FROM transactions
GROUP BY YEAR(date), QUARTER(date)
ORDER BY YEAR(date), QUARTER(date);


select * from transactions;
select * from cc_info;

describe transactions;
/*






*/