-- Sales Performance Analysis - FMCG Retail Dataset
CREATE TABLE sales (
    Item_Identifier TEXT,
    Item_Weight FLOAT,
    Item_Fat_Content TEXT,
    Item_Visibility FLOAT,
    Item_Type TEXT,
    Item_MRP FLOAT,
    Outlet_Identifier TEXT,
    Outlet_Establishment_Year INT,
    Outlet_Size TEXT,
    Outlet_Location_Type TEXT,
    Outlet_Type TEXT,
    Item_Outlet_Sales FLOAT,
    Outlet_Age INT
);

SELECT * FROM sales LIMIT 5;


-- Which category sells the most overall?
SELECT item_type, SUM(item_outlet_sales) AS total_sales
FROM sales
GROUP BY item_type
ORDER BY total_sales DESC;
-- Fruits & Veg and Snacks lead. Household (closest to Colgate's category) is 3rd.


-- Which outlet type performs best on average, not just in total volume?
SELECT outlet_type, AVG(item_outlet_sales) AS avgsales 
FROM sales 
GROUP BY outlet_type 
ORDER BY avgsales DESC;
-- Supermarket Type3 wins here.


-- Does Supermarket Type3 win because of what it sells, or is it just a stronger format overall?
SELECT outlet_type, item_type, SUM(item_outlet_sales) AS total_sales
FROM sales
GROUP BY outlet_type, item_type
ORDER BY outlet_type, total_sales DESC;
-- Same category ranking as the overall data. So it's not a product-mix advantage,
-- Type3 as a format is just genuinely more efficient.


-- Basic KPIs for the dashboard header
SELECT 
    SUM(item_outlet_sales) AS total_revenue,
    COUNT(*) AS total_transactions,
    ROUND(AVG(item_mrp)::numeric, 2) AS avg_item_price,
    COUNT(DISTINCT outlet_identifier) AS total_outlets,
    COUNT(DISTINCT item_type) AS total_categories
FROM sales;


-- Revenue split by city tier
SELECT outlet_location_type, 
       SUM(item_outlet_sales) AS total_sales,
       ROUND(AVG(item_outlet_sales)::numeric, 2) AS avg_sales
FROM sales
GROUP BY outlet_location_type
ORDER BY total_sales DESC;
-- Tier 3 comes out highest, which is a bit surprising at first glance.


-- Checking if that Tier 3 result is actually about the market, or just about
-- which outlet formats happen to exist there
SELECT outlet_location_type, outlet_type, COUNT(*) AS num_rows, SUM(item_outlet_sales) AS total_sales
FROM sales
GROUP BY outlet_location_type, outlet_type
ORDER BY outlet_location_type, total_sales DESC;
-- Turns out Supermarket Type3 (the best format) only exists in Tier 3 -- Tier 1
-- and Tier 2 don't have it at all. So this isn't really "Tier 3 is a better
-- market," it's "our best format just happens to be there." Would want to
-- test Type3 in Tier 1/2 before assuming Tier 3 itself is stronger.


-- Do older outlets sell more, or does age not really matter?
SELECT outlet_age, outlet_type,
       ROUND(AVG(item_outlet_sales)::numeric, 2) AS avg_sales,
       COUNT(*) AS num_items_sold
FROM sales
GROUP BY outlet_age, outlet_type
ORDER BY outlet_age;
-- Not much of a pattern. Only 10 outlets total, and each one has a unique
-- age/type combo, so age can't really be separated from "which specific store
-- is this." Looking just within Supermarket Type1 (6 stores, ages 6-26 years),
-- sales stay in a tight 2200-2440 range with no real trend by age.


-- Does "Low Fat" sell at a premium, and does that differ by city tier?
-- (filtered out Household/Health & Hygiene/Others since fat content doesn't apply there)
SELECT outlet_location_type, item_fat_content,
       SUM(item_outlet_sales) AS total_sales,
       ROUND(AVG(item_outlet_sales)::numeric, 2) AS avg_sales
FROM sales
WHERE item_type NOT IN ('Household', 'Health and Hygiene', 'Others')
GROUP BY outlet_location_type, item_fat_content
ORDER BY outlet_location_type, total_sales DESC;

-- Low Fat outsells Regular in every tier, but the average sale value is almost
-- the same for both. So it's just more popular, not priced as a premium item --
-- worth knowing if a brand ever considered charging more for a "low fat" label.


