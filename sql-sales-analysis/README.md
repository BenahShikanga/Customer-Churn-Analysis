# SQL Sales & Business Analytics

Answering common data-analyst business questions — revenue, top customers, product performance, sales-rep
performance, and customer order behavior — using **SQL** (multi-table joins, aggregation, CTEs, and window
functions) against a relational database, with results summarized in Python/Pandas/Matplotlib.

## Dataset

[Chinook](https://github.com/lerocha/chinook-database) — a sample digital media store database with customers,
invoices, tracks, albums, artists, genres, and employees. Provided as SQLite at
[`data/chinook.sqlite`](data/chinook.sqlite). See [`schema.md`](schema.md) for how the tables relate.

## Project structure

```
sql-sales-analysis/
├── data/
│   └── chinook.sqlite                     # sample SQLite database
├── queries/                               # each business question as a standalone .sql file
│   ├── 01_revenue_overview.sql
│   ├── 02_monthly_revenue_trend.sql
│   ├── 03_top_customers.sql
│   ├── 04_revenue_by_country.sql
│   ├── 05_top_genres.sql
│   ├── 06_top_artists_tracks.sql
│   ├── 07_sales_rep_performance.sql
│   ├── 08_repeat_customer_rate.sql
│   ├── 09_running_total_monthly_revenue.sql   # window function: SUM() OVER
│   └── 10_customer_rank_by_country.sql        # window function: RANK() OVER PARTITION BY
├── notebooks/
│   └── sql_sales_analysis.ipynb           # runs every query, with results and charts
├── images/
├── schema.md
└── requirements.txt
```

Every query is a plain, reusable `.sql` file — open and run any of them directly against the database with no
notebook required (`sqlite3 data/chinook.sqlite < queries/03_top_customers.sql`).

## How to run

```bash
cd sql-sales-analysis
pip install -r requirements.txt
jupyter notebook notebooks/sql_sales_analysis.ipynb
```

## Business questions answered

| # | Question | Technique |
|---|----------|-----------|
| 1 | What does the business look like overall (revenue, orders, AOV)? | Aggregation |
| 2 | How has monthly revenue trended? | `GROUP BY` + date functions |
| 3 | Who are the top 10 customers by revenue? | `JOIN` + `GROUP BY` + `ORDER BY` |
| 4 | Which countries generate the most revenue? | `GROUP BY` |
| 5 | Which genres sell best? | 3-table `JOIN` |
| 6 | Which artists and tracks drive the most revenue? | 4-table `JOIN` |
| 7 | How does revenue break down by sales rep? | `JOIN` across Employee → Customer → Invoice |
| 8 | What share of customers are repeat buyers? | `CTE` (`WITH`) |
| 9 | What does cumulative revenue look like month over month? | Window function: `SUM() OVER` |
| 10 | Who's the #1 customer in every country? | Window function: `RANK() OVER (PARTITION BY ...)` |

## Key insights

- **412 orders from 59 customers generated $2,328.60**, an average order value of **$5.65** and **$39.47 average
  revenue per customer**.
- **Revenue is geographically concentrated**: the USA alone generates ~22% of total revenue ($523), with Canada,
  France, Brazil, and Germany making up the next tier — a handful of markets drive most of the business.
- **Rock dominates by genre** (~$827 in revenue — more than double the next genre), so inventory, marketing, and
  recommendations should weight heavily toward Rock while still investing in the next few genres.
- **Sales-rep workload and revenue are evenly distributed** across the three reps — no single rep is an outlier,
  a useful check when auditing for imbalance.
- **Window functions replace what would otherwise be app-side loops**: a running-total query turns monthly figures
  into a cumulative trend in one query, and `RANK() OVER (PARTITION BY country)` finds the top customer in every
  market in a single pass.

Full results, all 10 queries, and charts are in the [notebook](notebooks/sql_sales_analysis.ipynb).

## Tools

SQL (SQLite) · Python · Pandas · Matplotlib · Seaborn · Jupyter
