use logistics;
drop table zomato_dataset;

select * from zomato;

describe zomato;

# 1- ROLLING/MOVING COUNT OF RESTAURANTS IN INDIAN CITIES.
select city, restaurantname from zomato where countrycode = 1;
select restaurantid, restaurantname,city, count(*) over ( partition by city 
order by restaurantid rows between 10 preceding and current row)
as rolling_count from zomato where countrycode = 1;
select restaurantname, locality, address, rating from zomato where city = "Lucknow";
# 2- SEARCHING FOR PERCENTAGE OF RESTAURANTS IN ALL THE COUNTRIES.
select count(*),count(restaurantname) / countrycode * 100.0 as percentage from zomato;
select countrycode, count(*) as total_count, count(*) * 100.0 / sum(count(*)) 
over () as percentage from zomato group by countrycode;
# 3- WHICH COUNTRIES AND HOW MANY RESTAURANTS WITH PERCENTAGE PROVIDES ONLINE DELIVERY OPTION
select city, countrycode, count(*) as restaurent_count, count(*) * 100.0 / sum(count(*))
over() as percentage from zomato where has_online_delivery = 'Yes' group by city, countrycode;
# 4- HOW MANY RESTAURANTS OFFER TABLE BOOKING OPTION IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
select restaurantname ,locality, city, count(*) as counts from zomato where countrycode = '1' and has_Table_booking = "Yes" 
group by restaurantname order by counts desc limit 10;
# 5- HOW RATING AFFECTS IN MAX LISTED RESTAURANTS WITH AND WITHOUT TABLE BOOKING OPTION (Connaught Place)
select restaurantname, count(*) as restaurant_count, avg(rating) as avg_rating
from zomato where address like ("%connaught place%") group by has_table_booking
order by restaurant_count desc, avg_rating desc limit 5;
# 6- AVG RATING OF RESTS LOCATION WISE
select locality, avg(rating) as avg_rating from zomato where address not like "%connaught place%" group by locality;
# 7- FINDING THE BEST RESTAURANTS WITH MODRATE COST FOR TWO IN INDIA HAVING INDIAN CUISINES
select restaurantname from zomato where cuisines like "%Indian%" 
and countrycode = 1 and average_cost_for_two order by rating desc;

select * from zomato;

/*
From here we use swiggy dataset
*/

select * from swiggy;
describe swiggy;
ALTER TABLE swiggy
CHANGE COLUMN `avg ratings` avg_ratings INT,
CHANGE COLUMN `Total ratings` total_ratings INT,
CHANGE COLUMN `Delivery time` delivery_time INT;

alter table swiggy
change column `food type` food_type text;

# 1- Can you identify the top 5 restaurants with the highest average ratings?
select restaurant, city, avg(avg_ratings) as avg_ratngs from swiggy group by 
restaurant order by avg_ratngs desc limit 5;
# 2- Which city has the highest average price for food items?
select city, restaurant, avg(price) as avg_price from swiggy group by city
order by avg_price desc limit 1;
# 3- Is there any correlation between the total ratings and average ratings of restaurants?
WITH rating_stats AS (
    SELECT 
        AVG(total_ratings) AS mean_total_ratings,
        AVG(avg_ratings) AS mean_avg_ratings,
        SUM((total_ratings - (SELECT AVG(total_ratings) FROM swiggy)) * (avg_ratings - (SELECT AVG(avg_ratings) FROM swiggy))) AS sum_product,
        SQRT(SUM(POWER(total_ratings - (SELECT AVG(total_ratings) FROM swiggy), 2))) AS stddev_total_ratings,
        SQRT(SUM(POWER(avg_ratings - (SELECT AVG(avg_ratings) FROM swiggy), 2))) AS stddev_avg_ratings
    FROM 
        swiggy
)
SELECT 
    sum_product / (stddev_total_ratings * stddev_avg_ratings) AS correlation_coefficient
FROM 
    rating_stats;
# 4- Can you find the top 10 areas with the highest number of restaurants?
select  area, count(restaurant) as count_rest from swiggy group by area order by count_rest desc limit 10;
# 5- How does the delivery time vary across different food types?
select delivery_time, food_type, avg(delivery_time) as ad from swiggy group by food_type;
# 6- Are there any outliers in the price distribution of restaurants?
WITH quartiles AS (
    SELECT
        price,
        NTILE(4) OVER (ORDER BY price) AS quartile
    FROM
        swiggy
)
SELECT
    *,
    (SELECT price FROM quartiles WHERE quartile = 1) AS Q1,
    (SELECT price FROM quartiles WHERE quartile = 3) AS Q3,
    (SELECT price FROM quartiles WHERE quartile = 3) - (SELECT price FROM quartiles WHERE quartile = 1) AS IQR,
    CASE
        WHEN price < (SELECT price FROM quartiles WHERE quartile = 1) - 1.5 * (SELECT price FROM quartiles WHERE quartile = 3) OR price > (SELECT price FROM quartiles WHERE quartile = 3) + 1.5 * (SELECT price FROM quartiles WHERE quartile = 3) THEN 'Outlier'
        ELSE 'Not Outlier'
    END AS outlier_status
FROM
    swiggy;
# How many records are there in the Swiggy dataset?
select count(*) from swiggy;
# What are the distinct areas covered by Swiggy?
select distinct(area) from swiggy;
# How many unique cities are listed in the Swiggy dataset?
select distinct(city) from swiggy;
# Can you retrieve the names of all restaurants in the dataset?
select restaurant from swiggy;
# What is the average price of food items across all restaurants?
select avg(price) from swiggy;
# How many restaurants have an average rating above 4.5?
select restaurant,city from swiggy where avg_ratings > 4.5;
# Which restaurant has the highest total ratings?
select  restaurant, total_ratings from swiggy order by total_ratings desc limit 1;
# What are the top 5 food types ordered on Swiggy?
select food_type, count(*) as food_type_count from swiggy group by food_type order by food_type_count desc limit 5;
# Can you list the addresses of restaurants in a specific city?
select address, restaurant, city from swiggy where city = "Delhi" group by address;
select distinct(city) from swiggy;
# What is the average delivery time for all restaurants?
select avg(delivery_time) from swiggy;
# How many restaurants offer delivery within 30 minutes?
select count(restaurant) from swiggy where delivery_time <= 30;
# Which area has the highest average price for food items?
select avg(price)as avg_price, area from swiggy group by area order by avg_price desc limit 1;
# Can you identify any outliers in the price distribution of restaurants?

# What is the correlation between the total ratings and average ratings of restaurants?
SELECT 
    SUM((total_ratings - mean_total_ratings) * (avg_ratings - mean_avg_ratings)) / 
    (COUNT(*) * STDDEV_POP(total_ratings) * STDDEV_POP(avg_ratings)) AS correlation_coefficient
FROM 
    swiggy,
    (SELECT AVG(total_ratings) AS mean_total_ratings, AVG(avg_ratings) AS mean_avg_ratings FROM swiggy) AS means;
# How many restaurants have a delivery time greater than 45 minutes?
select count(restaurant) from swiggy where delivery_time >= 45;
# Which food type has the highest average price?
select food_type, avg(price) as ap from swiggy group by food_type order by ap desc limit 1;
# What is the total number of ratings received by all restaurants?
select sum(total_ratings), restaurant from swiggy group by restaurant;
select sum(total_ratings) as tr from swiggy;
# How many restaurants have a delivery time less than the average delivery time?
select count(restaurant)  from swiggy
where delivery_time < (select avg(delivery_time)from swiggy);

SELECT
    s.restaurant,
    s.delivery_time,
    avg_delivery.avg_delivery_time AS avg_delivery_time
FROM
    swiggy AS s
JOIN
    (SELECT AVG(delivery_time) AS avg_delivery_time FROM swiggy) AS avg_delivery
ON
    s.delivery_time < avg_delivery.avg_delivery_time;
# Can you find the restaurant with the highest price in each city?
select restaurant, max(price), city from swiggy group by city; 
# Calculate the percentage of restaurants offering delivery within 30 minutes in each city.
select city, (count( case when delivery_time <= 30 then restaurant end) / count(restaurant)) *100.0 as restaurant_percentage
from swiggy group by city;