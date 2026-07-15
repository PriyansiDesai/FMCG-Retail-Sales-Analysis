# FMCG Sales Analysis — When a Market Insight Was Actually a Format Effect

While analyzing FMCG retail sales data (framed through the lens of a personal & home care CPG business), I found something that initially looked like a straightforward market insight — Tier 3 cities were generating ₹76.4L in revenue (41% of the total), compared to just ₹44.8L from Tier 1 (24%) — despite Tier 1 typically being assumed the stronger market.

The obvious conclusion: Tier 3 is an underrated, higher-value market.

Before writing that down, I checked one more thing — was this really about the *market*, or something else? Breaking outlet performance down by both city tier and store format revealed the real answer: **Supermarket Type3 — the single best-performing store format in the dataset, averaging ~₹3.7K in sales per item vs. ~₹2.3K for the next-best format — only exists in Tier 3.** Tier 1 and Tier 2 never had access to it at all; their outlets were limited to Supermarket Type1 and Grocery Store formats.

So the real finding wasn't "Tier 3 is a stronger market." It was **"Tier 1 and Tier 2 have never actually been tested with the stronger format."** That's a different, more useful conclusion — and a good reminder that a number and an insight aren't the same thing.

---

## What this project is
A full sales analysis pipeline built on a public retail dataset — **8,523 transactions, ₹1.86 Cr in total revenue, across 10 outlets, 1,559 unique products, and 16 categories** — cleaned, queried, analyzed, and visualized.

## Tech Stack
- **Python (Pandas)** — used for data cleaning and the ABC/Pareto revenue-concentration analysis; cumulative % calculations and product-level null imputation are easier to build and debug in pandas than in SQL alone.
- **PostgreSQL** — used to build a relational schema for the cleaned transaction data, simulating a lightweight production data-warehouse setup so the dashboard queries a real database rather than a static file.
- **SQL** — used for business-question-driven aggregation queries (revenue by category, outlet efficiency, city-tier breakdowns), the standard way BI/analytics teams pull and validate numbers before visualization.
- **Power BI** — used for the final dashboard, chosen since it's the BI tool most commonly used in Indian CPG/FMCG analytics teams.
- **Data source:** https://www.kaggle.com/code/ahmedashrafahmed/big-mart-sales-prediction-datasets

## Data Cleaning — key decisions
- **Item_Weight nulls (~17%)** — filled using the average weight of that *specific* product across outlets, not a blanket average across all products.
- **Outlet_Size nulls (~28%)** — filled based on the most common size for that outlet's format (e.g., Grocery Stores are almost always Small).
- **Item_Fat_Content inconsistency** — standardized inconsistent labels (`low fat`, `LF`, `Low Fat` → `Low Fat`; `reg`, `Regular` → `Regular`).
- **Item_Visibility = 0** — physically impossible for a shelved product, treated as hidden missing data and filled using the same product-level averaging as weight.

## Other findings

**Outlet age has no meaningful effect on sales.**
With only 10 outlets total, each has a unique age/format combination, so age can't be statistically separated from store-specific factors. Within Supermarket Type1 alone (6 stores, ages 6–26 years), average sales stayed in a tight, directionless range (₹2,192–₹2,439) — no evidence that store tenure drives performance.

**9 of 16 categories drive 84% of total revenue (ABC analysis).**
A cumulative revenue analysis showed the top 9 categories (Fruits & Vegetables through Meat) account for 84% of all revenue. This directly informs where inventory and shelf-space priority should sit — a small number of categories carry most of the weight.

**"Low Fat" outsells "Regular" everywhere — but isn't priced as a premium.**
Across every city tier, Low Fat products outsell Regular in both total and average revenue (e.g., Tier 3: ₹35.4L vs ₹27.0L total), but the average sale value between the two is nearly identical (Tier 3: ₹2,315 vs ₹2,281 per item — under 1.5% apart). The preference is popularity-driven, not price-driven.

## Strategic Recommendations
- **Pilot Supermarket Type3 in Tier 1.** Before treating Tier 3 as a stronger market, test whether the format's revenue efficiency holds in Tier 1 — or whether it was driven by Tier 3's lower operating costs (rent, staffing) rather than the format itself.
- **Reallocate shelf space toward the top 9 categories.** The bottom 7 categories (Breads through Seafood) contribute only ~16% of revenue combined. Shifting a portion of their shelf space to the top 9 revenue-driving categories could improve overall sales density without adding new SKUs.
- **Don't price "Low Fat" as a premium tier without testing first.** Current data shows no price gap between Low Fat and Regular despite Low Fat's higher demand — any premium pricing move should be piloted and measured, not assumed to work just because the product is popular.

## Dashboard
- **KPI Row:** Total Revenue, Avg Item Price, Total Outlets, Total Transactions
- **Revenue by Product Category** — ranked bar chart
- **Revenue by City Tier** — donut chart
- **Average Sales by Outlet Format** — efficiency comparison, not just volume
- **Outlet Format Distribution by City Tier** — stacked bar proving the Tier 3 confound
- **Revenue Concentration (Pareto Analysis)** — combined bar + cumulative % line

## How to Reproduce
1. Download the dataset from the Kaggle link above and place `train.csv` in the project folder.
2. Run `datacleaning.py` to generate the cleaned dataset.
3. Load the cleaned data into PostgreSQL and run the queries in `fmcgdata_queries.sql`.
4. Run `ABCanalysisforDAX.py` for the revenue concentration (Pareto/ABC) analysis.
5. Open the Power BI file and connect it to your local PostgreSQL database to view the dashboard.

## Limitations
- Dataset is a single snapshot, not a time series — no way to analyze real trends over time.
- Only 10 outlets total limits how confidently outlet-age effects can be separated from other store-specific factors.
- Item_Fat_Content is only meaningful for food categories; excluded Household/Health & Hygiene/Others from that specific analysis.

## Files
- `datacleaning.py` — cleaning pipeline (Python/Pandas)
- `fmcgdata_queries.sql` — business-question-driven SQL analysis
- `ABCanalysisforDAX.py` — Pareto/cumulative % revenue concentration analysis

