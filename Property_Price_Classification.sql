use cc;
select * from orders;
DROP TABLE `table_name(2)`;

select count(*) from orders where city = 'lucknow';
drop table `data (2)`;
select * from property_data;
describe property_data;

# What is the total number of records in the dataset?
select count(*) from property_data;
# What is the average price of properties in the dataset?
select avg(price) as avg_price from property_data;
# What is the maximum and minimum price of properties in the dataset?
(select price, country from property_data order by price desc limit 1 )
union all
(select price, country from property_data order by price asc limit 1 );
# How many bedrooms and bathrooms do properties typically have?
select avg(bedrooms), avg(bathrooms) from property_data 
group by country;
# What is the average square footage of living space for properties?
select avg(sqft_living) as avg_sqr from property_data;
# How many properties have waterfront views?
select * from property_data where view > 0 and waterfront > 0;
# What is the distribution of property conditions in the dataset?
select distinct(`condition`) from property_data;
# How many properties have been renovated, and what is the average year of renovation?
select street, country, yr_renovated from property_data where yr_renovated > 0;
# Which city has the highest average property price?
select avg(price) as avg_price, city from property_data group by city order by avg_price desc limit 1;
# How many properties were sold in each city?
select city, count(*) as property_sold from property_data 
group by city;
# What is the average price per square foot of living space?
select avg(price / sqft_living) as avg_price from property_data;
# How does the average price vary by the number of bedrooms?
select bedrooms, avg(price) as avg_price from property_data 
group by bedrooms order by bedrooms;
# What is the distribution of property prices based on the number of floors?
select floors, count(price) as count_price from property_data group by floors
order by floors;
SELECT floors, COUNT(*) AS number_of_properties, 
       MIN(price) AS min_price, MAX(price) AS max_price, 
       AVG(price) AS avg_price
FROM property_data
GROUP BY floors;
# How does the average price vary by the presence of a waterfront view?
select avg(price) as avg_price, waterfront, view from property_data where waterfront > 0 and view > 0 group by price
order by price;
SELECT waterfront, view, AVG(price) AS avg_price
FROM property_data
WHERE waterfront > 0 AND view > 0
GROUP BY waterfront, view
ORDER BY avg_price;
# How does the average price vary by the condition of the property?
select `condition`, avg(price) from property_data group by `condition` order by `condition`;
# What is the average price of properties built before and after a certain year?
select yr_built, avg(price) as av from property_data where yr_built < 1950 or yr_built > 1950
group by yr_built;
select avg(price) as avg_price,
case
 when yr_built < 1950 then 'Before 1950'
 when yr_built >= 1950 then 'after 1950'
 end as built_year_category from property_Data
 group by built_year_category;
 # How many properties have a basement, and what is the average size of the basement?
 select count(*) as cp, avg(sqft_basement) as avg_bas  from property_data where sqft_basement > 0;
 # How does the average price vary by the size of the basement?
select sqft_basement, avg(price) as avg_price from property_Data group by sqft_basement order by sqft_basement;
# How many properties are located in each state?
select statezip, country, count(statezip) from property_data group by statezip;
# What is the average price of properties in each state?
select statezip, country, avg(price) as avg_price from property_data group by statezip;
# How does the average price vary by the year the property was built?
select yr_built, avg(price) as avg_price from property_data group by yr_built order by yr_built;
# What is the distribution of property prices based on the year of renovation?
select yr_renovated, price from property_data where yr_renovated > 0 group by price order by price desc;
# How does the average price vary by the year of renovation?
select yr_renovated, avg(price) as avg_price from property_data where yr_renovated > 0
group by yr_renovated order by yr_renovated;
# What is the correlation between the price of properties and the number of bedrooms, bathrooms, and square footage of living space?

# How many properties are located on each street?
select street, count(*) as property_count from property_data  group by street;
# Which street has the highest average property price?
select street, avg(price) as avg_price from property_data group by street order by avg_price desc limit 1;
# How does the average price vary by the number of bedrooms and bathrooms?
select bedrooms, bathrooms, avg(price) as avg_price from property_data where bedrooms and bathrooms > 0 group by
bedrooms, bathrooms order by bedrooms, bathrooms;
# How does the average price vary by the size of the lot?
select sqft_lot, avg(price) as avg_price from property_Data group by sqft_lot order by sqft_lot;
# What is the distribution of property prices based on the size of the lot?
select sqft_lot, price from property_Data order by  sqft_lot desc;
# How many properties are located in each country?
select country, count(*) as total_property from property_Data group by country;


