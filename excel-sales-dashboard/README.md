# Sales Performance Dashboard (Excel)

An interactive Excel dashboard analyzing sales performance — revenue trends, top customers, product/genre
performance, and sales-rep performance — built entirely with formulas (no manual/hardcoded results) and native
Excel charts, plus a year filter driven by a dropdown.

Same underlying dataset as [`../sql-sales-analysis`](../sql-sales-analysis/) (the Chinook digital media store),
now presented as a self-contained, formula-driven Excel workbook — the same business questions answered a second
way across this portfolio: SQL queries, a Python/Pandas notebook, and this spreadsheet.

## File

[`Sales_Dashboard.xlsx`](Sales_Dashboard.xlsx) — open directly in Excel, Google Sheets, or Apple Numbers.

## Structure

- **`Data` sheet** — 2,240 rows, one per invoice line (customer, country, sales rep, genre, artist, track, price,
  quantity, line total), formatted as an Excel Table (`SalesData`) with two helper columns (`IsFirstInvoiceLine`,
  `IsFirstCustomerLine`) used to compute distinct counts efficiently — see [Distinct counts](#distinct-counts) below.
- **`Dashboard` sheet** — KPI cards, a year filter, a Top 10 Customers table, four charts, and the formula-driven
  tables that feed those charts.

## Dashboard features

- **KPI cards**: Total Revenue, Total Orders, Total Customers, Average Order Value (all-time).
- **Year filter** (dropdown, data validation): drives two additional KPIs — Revenue and Orders for the selected
  year (or "All").
- **Top 10 Customers** table: name, lifetime revenue, order count — every value a formula.
- **Charts**: Monthly Revenue Trend (line), Revenue by Country (bar, top 10), Revenue by Genre (bar, top 10),
  Revenue by Sales Rep (bar).

Every number on the dashboard is a live formula (`SUM`, `SUMIFS`, `SUMPRODUCT`) referencing the `Data` sheet —
nothing is a pasted/hardcoded result, so the whole dashboard recalculates if the underlying data changes.

## Distinct counts

Counting distinct customers/orders in Excel isn't a single built-in function pre-365 (`COUNTIF`/`SUMIFS` count
rows, not unique values). Rather than a `SUMPRODUCT(1/COUNTIF(range,range))` whole-range array formula — which is
mathematically correct but scales as O(n²) and gets very slow past a couple thousand rows — this workbook uses the
standard **O(n) "first occurrence" flag column** technique:

```
IsFirstInvoiceLine  =IF(COUNTIF($O$2:O2,O2)=1,1,0)   ' 1 the first time this InvoiceId appears, else 0
```

Distinct order count is then just `=SUM(IsFirstInvoiceLine)` (or `SUMIFS(...)` filtered by customer/year) — same
result, dramatically cheaper to compute, and a technique worth knowing for any large real-world workbook.

## Key insights

- **412 orders from 59 customers generated $2,328.60** in total revenue — average order value **$5.65**.
- **The USA is the largest single market** (~22% of revenue), with Canada, France, Brazil, and Germany rounding
  out the next tier.
- **Rock is the dominant genre**, generating more than double the revenue of the next genre (Latin).
- **Revenue is spread evenly across the 3 active sales reps** — no single rep is an outlier.

(Matches the findings in [`../sql-sales-analysis`](../sql-sales-analysis/), computed here via spreadsheet formulas
instead of SQL.)

## Tools

Excel (formulas: `SUM`, `SUMIFS`, `SUMPRODUCT`, `COUNTIF`) · Data Validation · native Excel charts · (data
prepared with Python/Pandas/SQLite)
