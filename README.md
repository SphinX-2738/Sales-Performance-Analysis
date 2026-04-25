# Sales Performance Analysis
### Tools: Excel | MySQL | Power BI
### Dataset: 3,320 rows | FY2024–FY2025 | 5 Regions | 20 Products

---

## Project Overview
End-to-end sales analysis project for a tech accessories company covering two 
fiscal years (April 2024 – March 2026). The project covers the full analyst 
workflow from raw data cleaning to executive dashboard delivery.

---

## Dashboard Preview
![Sales Dashboard](Sales_Performance_Analysis.png)

---

## Dataset
- 3,320 transactions across FY2024 and FY2025
- 5 regions: North, South, East, West, Central
- 20 products across 7 categories
- 4 sales channels: Online, In-Store, Partner, Direct Sales
- 5 customer segments: Enterprise, SMB, Government, Education, Consumer
- 18 columns including Revenue, COGS, Gross Profit, Discount

---

## What I Built

### 1. Data Cleaning (Excel)
- Identified and resolved 15 data quality issues
- Issues included: negative quantities, duplicate order IDs, invalid regions,
  revenue mismatches, out-of-scope dates, wrong fiscal year labels
- Built a Data Dictionary documenting all 18 columns

### 2. Analysis (Excel)
- 5 analytical tables using SUMIF, COUNTIF, AVERAGEIF, SUMPRODUCT, INDEX MATCH
- Revenue by Region, Fiscal Quarter YoY, Channel Mix, Top Products, Sales Rep Performance

### 3. SQL Queries (MySQL)
- 12 queries from beginner to advanced
- Concepts: GROUP BY, WHERE, HAVING, CASE WHEN, Subqueries
- Advanced: RANK(), DENSE_RANK(), LAG(), CTEs, JOINs, PARTITION BY

### 4. Power BI Dashboard
- 5 KPI cards: $10.25M Revenue, $4.62M Gross Profit, 3,320 Orders
- Clustered bar chart: FY2024 vs FY2025 quarterly comparison
- Donut chart: Revenue by sales channel
- Line chart: Monthly revenue trend FY2025
- Bar chart: Top 10 sales reps leaderboard
- Segment chart: Revenue by customer segment
- Custom fiscal Date Table with DAX measures

---

## Key Findings
- FY2025 total revenue declined vs FY2024 across all reps and 3 of 4 quarters
- Q2 FY2025 was the strongest quarter with +34.3% YoY growth
- Q3 FY2025 (Oct–Dec) underperformed despite being peak season — key concern
- Revenue decline was uniform across all reps suggesting a market-level issue
- Partner and Online channels each account for ~26% of total revenue
- Government segment leads by revenue despite fewer orders — highest avg deal size

---

## Files
| File | Description |
|------|-------------|
| `Project1_Sales_FY2024_2025.xlsx` | Full Excel workbook (5 sheets) |
| `Project1_Sales_2024_2025.csv` | Clean dataset for SQL import |
| `sales_queries.sql` | All 12 MySQL queries |
| `Sales_Dashboard_Screenshot.png` | Power BI dashboard screenshot |

---


## Skills Demonstrated
`Excel` `MySQL` `Power BI` `DAX` `Data Cleaning` `Window Functions` 
`CTEs` `YoY Analysis` `Dashboard Design` `Data Storytelling`

---

## Skills Demonstrated
`Excel` `MySQL` `Power BI` `DAX` `Data Cleaning` `Window Functions` 
`CTEs` `YoY Analysis` `Dashboard Design` `Data Storytelling`
