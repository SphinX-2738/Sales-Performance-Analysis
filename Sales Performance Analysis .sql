-- ============================================
-- Sales Performance Analysis — SQL Queries
-- Author: Ankur Sharma
-- Dataset: FY2024-FY2025 Tech Accessories Sales
-- Tool: MySQL Workbench
-- ============================================

-- ─────────────────────────────────────────────
-- BEGINNER QUERIES
-- ─────────────────────────────────────────────

-- Query 1: Total revenue by region
SELECT 
    Region,
    SUM(Revenue) AS Total_Revenue,
    COUNT(Order_ID) AS Total_Orders,
    ROUND(SUM(Revenue) / COUNT(Order_ID), 2) AS Avg_Order_Value
FROM sales
GROUP BY Region
ORDER BY Total_Revenue DESC;

-- Query 2: Orders and revenue by fiscal year
SELECT 
    Fiscal_Year,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue,
    ROUND(SUM(Revenue) / COUNT(Order_ID), 2) AS Avg_Order_Value
FROM sales
GROUP BY Fiscal_Year
ORDER BY Fiscal_Year;

-- Query 3: Top 5 products by revenue
SELECT 
    Product,
    Category,
    SUM(Revenue) AS Total_Revenue,
    SUM(Quantity) AS Total_Units_Sold,
    ROUND(SUM(Gross_Profit) / SUM(Revenue) * 100, 2) AS GP_Margin_Pct
FROM sales
GROUP BY Product, Category
ORDER BY Total_Revenue DESC
LIMIT 5;

-- Query 4: Average discount by sales channel
SELECT 
    `Channel`,
    ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Pct,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue
FROM sales
GROUP BY `Channel`
ORDER BY Avg_Discount_Pct DESC;

-- ─────────────────────────────────────────────
-- INTERMEDIATE QUERIES
-- ─────────────────────────────────────────────

-- Query 5: Monthly revenue trend for FY2025
SELECT 
    `Year_Month`,
    Month_Num,
    SUM(Revenue) AS Total_Revenue,
    SUM(Quantity) AS Total_Units_Sold,
    ROUND(SUM(Gross_Profit) / SUM(Revenue) * 100, 2) AS GP_Margin_Pct
FROM sales
WHERE Fiscal_Year = 'FY2025'
GROUP BY `Year_Month`, Month_Num
ORDER BY Month_Num, `Year_Month`;

-- Query 6: Top sales rep per region (window function)
SELECT 
    Region,
    Sales_Rep,
    Total_Revenue
FROM (
    SELECT 
        Region,
        Sales_Rep,
        SUM(Revenue) AS Total_Revenue,
        RANK() OVER (PARTITION BY Region ORDER BY SUM(Revenue) DESC) AS rnk
    FROM sales
    GROUP BY Region, Sales_Rep
) ranked
WHERE rnk = 1
ORDER BY Total_Revenue DESC;

-- Query 7: Gross profit margin by product category
SELECT 
    Category,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue,
    SUM(COGS) AS Total_COGS,
    SUM(Gross_Profit) AS Total_Gross_Profit,
    ROUND(SUM(Gross_Profit) / SUM(Revenue) * 100, 2) AS GP_Margin_Pct
FROM sales
GROUP BY Category
ORDER BY GP_Margin_Pct DESC;

-- Query 8: Revenue by customer segment across fiscal years
SELECT 
    Customer_Segment,
    SUM(CASE WHEN Fiscal_Year = 'FY2024' THEN Revenue ELSE 0 END) AS FY2024_Revenue,
    SUM(CASE WHEN Fiscal_Year = 'FY2025' THEN Revenue ELSE 0 END) AS FY2025_Revenue,
    ROUND(
        (SUM(CASE WHEN Fiscal_Year = 'FY2025' THEN Revenue ELSE 0 END) -
         SUM(CASE WHEN Fiscal_Year = 'FY2024' THEN Revenue ELSE 0 END)) /
         SUM(CASE WHEN Fiscal_Year = 'FY2024' THEN Revenue ELSE 0 END) * 100
    , 2) AS YoY_Growth_Pct
FROM sales
GROUP BY Customer_Segment
ORDER BY FY2025_Revenue DESC;

-- ─────────────────────────────────────────────
-- ADVANCED QUERIES
-- ─────────────────────────────────────────────

-- Query 9: Month-over-month revenue growth for FY2025
WITH monthly_revenue AS (
    SELECT 
        `Year_Month`,
        Month_Num,
        `Year`,
        SUM(Revenue) AS Total_Revenue
    FROM sales
    WHERE Fiscal_Year = 'FY2025'
    GROUP BY `Year_Month`, Month_Num, `Year`
),
with_lag AS (
    SELECT 
        `Year_Month`,
        Month_Num,
        `Year`,
        Total_Revenue,
        LAG(Total_Revenue) OVER (ORDER BY `Year`, Month_Num) AS Prev_Month_Revenue
    FROM monthly_revenue
)
SELECT 
    `Year_Month`,
    Total_Revenue,
    Prev_Month_Revenue,
    ROUND(Total_Revenue - Prev_Month_Revenue, 2) AS MoM_Change,
    ROUND((Total_Revenue - Prev_Month_Revenue) / Prev_Month_Revenue * 100, 2) AS MoM_Growth_Pct
FROM with_lag
ORDER BY `Year`, Month_Num;

-- Query 10: Top 3 products by revenue in each region
WITH product_region AS (
    SELECT 
        Region,
        Product,
        Category,
        SUM(Revenue) AS Total_Revenue,
        SUM(Quantity) AS Total_Units,
        ROUND(SUM(Gross_Profit) / SUM(Revenue) * 100, 2) AS GP_Margin_Pct
    FROM sales
    GROUP BY Region, Product, Category
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY Region ORDER BY Total_Revenue DESC) AS rnk
    FROM product_region
)
SELECT 
    Region,
    rnk AS Rank_In_Region,
    Product,
    Category,
    Total_Revenue,
    Total_Units,
    GP_Margin_Pct
FROM ranked
WHERE rnk <= 3
ORDER BY Region, rnk;

-- Query 11: Channel revenue share per fiscal year
WITH channel_revenue AS (
    SELECT 
        Fiscal_Year,
        `Channel`,
        SUM(Revenue) AS Channel_Revenue
    FROM sales
    GROUP BY Fiscal_Year, `Channel`
),
fy_totals AS (
    SELECT 
        Fiscal_Year,
        SUM(Revenue) AS FY_Total_Revenue
    FROM sales
    GROUP BY Fiscal_Year
)
SELECT 
    cr.Fiscal_Year,
    cr.`Channel`,
    cr.Channel_Revenue,
    ft.FY_Total_Revenue,
    ROUND(cr.Channel_Revenue / ft.FY_Total_Revenue * 100, 2) AS Revenue_Share_Pct
FROM channel_revenue cr
JOIN fy_totals ft ON cr.Fiscal_Year = ft.Fiscal_Year
ORDER BY cr.Fiscal_Year, Revenue_Share_Pct DESC;

-- Query 12: Sales reps with revenue decline FY2024 to FY2025
WITH rep_fy AS (
    SELECT 
        Sales_Rep,
        Region,
        Fiscal_Year,
        SUM(Revenue) AS Total_Revenue,
        COUNT(Order_ID) AS Total_Orders
    FROM sales
    GROUP BY Sales_Rep, Region, Fiscal_Year
),
rep_comparison AS (
    SELECT 
        Sales_Rep,
        Region,
        SUM(CASE WHEN Fiscal_Year = 'FY2024' THEN Total_Revenue ELSE 0 END) AS FY2024_Revenue,
        SUM(CASE WHEN Fiscal_Year = 'FY2025' THEN Total_Revenue ELSE 0 END) AS FY2025_Revenue,
        SUM(CASE WHEN Fiscal_Year = 'FY2024' THEN Total_Orders ELSE 0 END) AS FY2024_Orders,
        SUM(CASE WHEN Fiscal_Year = 'FY2025' THEN Total_Orders ELSE 0 END) AS FY2025_Orders
    FROM rep_fy
    GROUP BY Sales_Rep, Region
)
SELECT 
    Sales_Rep,
    Region,
    ROUND(FY2024_Revenue, 2) AS FY2024_Revenue,
    ROUND(FY2025_Revenue, 2) AS FY2025_Revenue,
    ROUND(FY2025_Revenue - FY2024_Revenue, 2) AS Revenue_Change,
    ROUND((FY2025_Revenue - FY2024_Revenue) / FY2024_Revenue * 100, 2) AS Growth_Pct,
    FY2024_Orders,
    FY2025_Orders
FROM rep_comparison
WHERE FY2025_Revenue < FY2024_Revenue
ORDER BY Revenue_Change ASC;