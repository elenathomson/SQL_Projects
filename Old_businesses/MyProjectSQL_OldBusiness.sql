--1. The oldest business in the world

"The entrance to St. Peter Stiftskeller, a restaurant in Saltzburg, Austria. The sign over the entrance shows "803" - the year the business opened.

Image: St. Peter Stiftskeller, founded 803. Credit: Pakeha.

An important part of business is planning for the future and ensuring that the company survives changing market conditions. Some businesses do this really well and last for hundreds of years.

BusinessFinancing.co.uk researched the oldest company that is still in business in (almost) every country and compiled the results into a dataset. In this project, you'll explore that dataset to see what they found.

The database contains three tables.
categories
column 	type 	meaning
category_code 	varchar 	Code for the category of the business.
category 	varchar 	Description of the business category.
countries
column 	type 	meaning
country_code 	varchar 	ISO 3166-1 3-letter country code.
country 	varchar 	Name of the country.
continent 	varchar 	Name of the continent that the country exists in.
businesses
column 	type 	meaning
business 	varchar 	Name of the business.
year_founded 	int 	Year the business was founded.
category_code 	varchar 	Code for the category of the business.
country_code 	char 	ISO 3166-1 3-letter country code."

"Let's begin by looking at the range of the founding years throughout the world."

%%sql 

postgresql:///oldestbusinesses

 

-- Select the oldest and newest founding years from the businesses table

SELECT min(year_founded), max(year_founded)
FROM businesses;

--2. How many businesses were founded before 1000?

"Wow! That's a lot of variation between countries. In one country, the oldest business was only founded in 1999. By contrast, the oldest business in the world was founded back in 578. That's pretty incredible that a business has survived for more than a millennium.

I wonder how many other businesses there are like that."

%%sql

​

-- Get the count of rows in businesses where the founding year was before 1000

SELECT COUNT (*)
FROM businesses
WHERE year_founded < 1000;

--3. Which businesses were founded before 1000?

"Having a count is all very well, but I'd like more detail. Which businesses have been around for more than a millennium?"

%%sql

​

-- Select all columns from businesses where the founding year was before 1000

-- Arrange the results from oldest to newest
SELECT *
FROM businesses
WHERE year_founded < 1000
ORDER BY year_founded;


--4. Exploring the categories

"Now we know that the oldest, continuously operating company in the world is called Kongō Gumi. But was does that company do? The category codes in the businesses table aren't very helpful: the descriptions of the categories are stored in the categories table.

This is a common problem: for data storage, it's better to keep different types of data in different tables, but for analysis, you want all the data in one place. To solve this, you'll have to join the two tables together."

%%sql

​

-- Select business name, founding year, and country code from businesses; and category from categories

-- where the founding year was before 1000, arranged from oldest to newest

SELECT business, year_founded, country_code, category
  FROM businesses
   INNER JOIN categories
   USING (category_code)
   WHERE year_founded < 1000
   ORDER BY year_founded;

--5. Counting the categories

"With that extra detail about the oldest businesses, we can see that Kongō Gumi is a construction company. In that list of six businesses, we also see a café, a winery, and a bar. The two companies recorded as "Manufacturing and Production" are both mints. That is, they produce currency.

I'm curious as to what other industries constitute the oldest companies around the world, and which industries are most common."

%%sql

​

-- Select the category and count of category (as "n")

-- arranged by descending count, limited to 10 most common categories

SELECT category, 
COUNT(category) AS n
FROM categories
INNER JOIN businesses
USING (category_code)
Group BY (category)
ORDER BY n DESC
LIMIT 10;


--6. Oldest business by continent

"It looks like "Banking & Finance" is the most popular category. Maybe that's where you should aim if you want to start a thousand-year business.

One thing we haven't looked at yet is where in the world these really old businesses are. To answer these questions, we'll need to join the businesses table to the countries table. Let's start by asking how old the oldest business is on each continent."

%%sql

​

-- Select the oldest founding year (as "oldest") from businesses, 

-- and continent from countries

-- for each continent, ordered from oldest to newest 


SELECT min(year_founded) AS "oldest", continent
FROM businesses
INNER JOIN countries
USING (country_code)
GROUP BY (continent)
ORDER BY oldest;

--7. Joining everything for further analysis

"Interesting. There's a jump in time from the older businesses in Asia and Europe to the 16th Century oldest businesses in North and South America, then to the 18th and 19th Century oldest businesses in Africa and Oceania.

As mentioned earlier, when analyzing data it's often really helpful to have all the tables you want access to joined together into a single set of results that can be analyzed further. Here, that means we need to join all three tables."

%%sql

​

-- Select the business, founding year, category, country, and continent
-- Join businesses to categories then to countries.

SELECT business, year_founded, category, country, continent
FROM businesses
INNER JOIN categories
USING (category_code)
INNER JOIN countries
USING (country_code);

--8. Counting categories by continent

"Having businesses joined to categories and countries together means we can ask questions about both these things together. For example, which are the most common categories for the oldest businesses on each continent?"

%%sql

​

-- Count the number of businesses in each continent and category

SELECT continent, category, 
COUNT (business) AS n
FROM businesses
INNER JOIN categories
USING (category_code)
INNER JOIN countries
USING (country_code)
GROUP BY continent, category;

--9. Filtering counts by continent and category

"Combining continent and business category led to a lot of results. It's difficult to see what is important. To trim this down to a manageable size, let's restrict the results to only continent/category pairs with a high count."

%%sql

​

-- Repeat that previous query, filtering for results having a count greater than 5
"
    Repeat and extend the previous query, filtering for results having a count greater than 5.
    Order the results by descending count.
"
SELECT continent, category, 
COUNT (business) AS n
FROM businesses
INNER JOIN categories
USING (category_code)
INNER JOIN countries
USING (country_code)
GROUP BY continent, category
HAVING COUNT (businesses) > 5
ORDER BY n DESC;

