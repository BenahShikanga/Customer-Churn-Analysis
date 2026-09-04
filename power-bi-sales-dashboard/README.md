# Sales Performance Dashboard (Power BI)

A Power BI dashboard analyzing sales performance — revenue trends, top customers, product/genre performance, and
sales-rep performance — built on a clean star-schema data model with custom DAX measures.

> **Status:** the data, data model, DAX measures, theme, and full build spec are ready. The report itself is built
> by hand by following [`docs/build_guide.md`](docs/build_guide.md), which covers two paths: the free, browser-based
> **Power BI Service** (works on Mac/Windows/Linux, no install) or **Power BI Desktop** (Windows only, e.g. via a
> Windows VM) — once built, drop the `.pbix` (Desktop path) or a shareable link (Service path) in this folder
> alongside screenshots in `images/`.

## Why this dataset

Same underlying data as [`../sql-sales-analysis`](../sql-sales-analysis/) (the Chinook digital media store), now
reshaped into a proper **star schema** and rebuilt as an interactive BI dashboard — showing the same business
questions answered three ways across this portfolio: SQL queries, a Python/Pandas notebook, and a Power BI report.

## Project structure

```
power-bi-sales-dashboard/
├── data/                       # star-schema CSVs, ready to import into Power BI
│   ├── fact_sales.csv          # one row per invoice line (2,240 rows)
│   ├── dim_customer.csv
│   ├── dim_employee.csv
│   ├── dim_product.csv         # track + album + artist + genre
│   └── dim_date.csv            # full calendar table
├── dax/
│   └── measures.dax            # every DAX measure used in the report, with comments
├── theme/
│   └── portfolio_theme.json    # importable Power BI theme (same palette as the other projects)
├── docs/
│   ├── data_model.md           # star-schema diagram & table descriptions
│   └── build_guide.md          # step-by-step: import → model → measures → pages → format
└── images/                     # dashboard screenshots (added after building)
```

## Data model

Star schema: `FactSales` (2,240 line items) at the center, joined to `DimCustomer`, `DimProduct`, `DimDate`, and
`DimEmployee`. Full diagram in [`docs/data_model.md`](docs/data_model.md).

## Dashboard pages

| Page | Content |
|---|---|
| **Executive Overview** | KPI cards (revenue, orders, AOV, customers), monthly revenue trend, cumulative revenue, revenue by country, revenue by genre |
| **Customer Analysis** | Top customers table with rank, revenue-by-country map, customers by country, avg revenue/customer |
| **Product Performance** | Top genres, top artists, top tracks table, genre treemap |
| **Sales Rep Performance** | Revenue and customer count by sales rep |

Every page shares a synced date slicer; full visual-by-visual spec is in [`docs/build_guide.md`](docs/build_guide.md).

## Key DAX measures

- `Total Revenue`, `Total Orders`, `Total Customers`, `Average Order Value`, `Average Revenue Per Customer`
- Time intelligence: `Revenue LY`, `Revenue YoY %`, `Running Total Revenue` (requires `DimDate` marked as a Date Table)
- Ranking: `Customer Revenue Rank`, `Product Revenue Rank` (`RANKX`)
- Segmentation: `Is Repeat Customer`

Full DAX in [`dax/measures.dax`](dax/measures.dax).

## How to build it

See [`docs/build_guide.md`](docs/build_guide.md) for the complete walkthrough, including a **Mac-friendly path**
using the free Power BI Service in your browser (no Windows/install required). Short version:

1. **On a Mac**: combine the 5 CSVs into one Excel workbook, upload to OneDrive, and import it at
   [app.powerbi.com](https://app.powerbi.com). **On Windows** (or a Windows VM): install
   [Power BI Desktop](https://www.microsoft.com/en-us/power-platform/products/power-bi/desktop) (free) and import
   the 5 CSVs from `data/` directly.
2. Build the relationships described in `docs/data_model.md`; mark `DimDate` as a date table.
3. Apply `theme/portfolio_theme.json` (Desktop; try the same in Service if available).
4. Add the measures from `dax/measures.dax`.
5. Build the 4 pages per `docs/build_guide.md`.
6. Drop the `.pbix` (Desktop) or shareable link (Service) here, plus screenshots into `images/`.

## Tools

Power BI (Desktop or Service) · DAX · Power Query · (data prepared with Python/Pandas/SQLite)
