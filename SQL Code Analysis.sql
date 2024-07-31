--A) What is the total number of units sold per product SKU?

SELECT productid, SUM (inventoryquantity) AS product_sku
FROM sales
GROUP BY 1
ORDER BY 2 DESC;


--B) Which product category has the highest sales volume last month?

SELECT productcategory, SUM(inventoryquantity) AS sales_volume
FROM sales
JOIN product
ON sales.productid = product.productid
WHERE salesdate >= date_trunc ('MONTH',(SELECT MAX(salesdate) FROM sales)- INTERVAL '1 MONTH')
AND salesdate < date_trunc ('MONTH',(SELECT MAX(salesdate) FROM sales))
GROUP BY 1
ORDER BY 2 DESC;


--C) How does the inflation rate correlate with sales volume for a specific month?
SELECT 
	to_char(sales.salesdate, 'month') Month_Name,
	SUM(inflationrate) AS inflation_rate,
	SUM(inventoryquantity) AS sales_volume
FROM factors
JOIN sales
ON factors.salesdate = sales.salesdate
GROUP BY to_char(sales.salesdate, 'month'),
	     to_char(sales.salesdate, 'MM')
ORDER BY to_char(sales.salesdate, 'MM');

-- D)What is the correlation between the inflation rate and sales quantity for all products combined on a monthly basis over the last year?
SELECT to_char(sales.salesdate, 'month') AS Month,
AVG(factors.inflationrate) AS avg_inflation_rate,
SUM(sales.inventoryquantity) AS total_sales_quantity
FROM sales
JOIN factors
ON sales.salesdate = factors.salesdate 
JOIN product
ON sales.productid = product.productid
WHERE sales.salesdate >= '2023-01-01' AND sales.salesdate <= '2023-12-31'
GROUP BY 1, to_char(sales.salesdate, 'MM')
ORDER BY to_char(sales.salesdate, 'MM');
       
	
--E) Did promotions significantly impact the sales quantity of products?

SELECT product.promotions,
ROUND(AVG(sales.inventoryquantity)) AS avg_sales_quantity
FROM sales
JOIN product 
ON sales.productid = product.productid
GROUP BY product.promotions


--F) What is the average sales quantity per product category?
	
SELECT productcategory,
ROUND(AVG(inventoryquantity)) AS average_sales_quantity
FROM product
JOIN sales
ON product.productid = sales.productid
GROUP BY 1;

--G) How does the GDP affect the total sales volume?

SELECT s.sales_year, SUM(f.GDP),
SUM(s.inventoryquantity) AS sales_volume
FROM factors f
JOIN sales s
ON f.salesdate = s.salesdate
GROUP BY 1
ORDER BY 3 DESC;

--H) What are the top 10 best-selling product SKUs?

SELECT productid, SUM (inventoryquantity) as skus
FROM sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- I) How do seasonal factors influence sales quantities for different product categories?

SELECT
product.productcategory, 
ROUND(AVG (factors.seasonalfactor)) AS avg_seasonal_factor,
SUM(sales.inventoryquantity) AS avg_sales_quantity
FROM sales
JOIN factors
ON sales.salesdate = factors.salesdate
JOIN product 
ON sales.productid = product.productid
GROUP BY 1
ORDER BY 1;

	 	
-- J) What is the average sales quantity per product category, and how many products within
--each category were part of a promotion?

SELECT product.productcategory, ROUND(AVG(sales.inventoryquantity)) AS average_sales_quantity,
COUNT (CASE
	       WHEN product.promotions = 'Yes' THEN 1 ELSE NULL
	   END) AS products_in_promotion
FROM
sales
JOIN
product
ON sales.productid = product.productid
GROUP BY
1
ORDER BY
1;




