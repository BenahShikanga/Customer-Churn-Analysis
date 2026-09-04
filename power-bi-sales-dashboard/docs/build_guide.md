# Build Guide — Sales Performance Dashboard

Follow this guide top to bottom in **Power BI Desktop** (free download:
[powerbi.microsoft.com/desktop](https://www.microsoft.com/en-us/power-platform/products/power-bi/desktop), Windows only).
Total time: roughly 45–60 minutes for a first pass.

## 0. Install & open

1. Install Power BI Desktop from the Microsoft Store or the link above.
2. Open Power BI Desktop → **Get Data** → **Text/CSV** → import all 5 files from [`../data/`](../data/):
   `fact_sales.csv`, `dim_customer.csv`, `dim_employee.csv`, `dim_product.csv`, `dim_date.csv`.
3. Click **Transform Data** and check each table's column types (Power BI usually infers correctly, but confirm
   `InvoiceDate`/`Date` are typed as **Date**, not text, and IDs are **Whole Number**). Click **Close & Apply**.

## 1. Build the data model (star schema)

Go to the **Model** view (left sidebar) and create these relationships by dragging field-to-field:

| From | To | Cardinality |
|---|---|---|
| `FactSales[CustomerId]` | `DimCustomer[CustomerId]` | Many-to-one |
| `FactSales[ProductId]` | `DimProduct[ProductId]` | Many-to-one |
| `FactSales[InvoiceDate]` | `DimDate[Date]` | Many-to-one |
| `DimCustomer[EmployeeId]` | `DimEmployee[EmployeeId]` | Many-to-one |

This is a standard **star schema**: `FactSales` in the middle, dimension tables around it — the layout Power BI
(and every BI tool) is optimized for. See [`data_model.md`](data_model.md) for the diagram.

**Mark `DimDate` as a date table**: select `DimDate` → Table tools ribbon → **Mark as Date Table** → pick the
`Date` column. This is required for the time-intelligence DAX measures (`SAMEPERIODLASTYEAR`, etc.) to work.

## 2. Load the theme

**View** tab → **Themes** → **Browse for themes** → select [`../theme/portfolio_theme.json`](../theme/portfolio_theme.json).
This applies a consistent, colorblind-checked color palette matching the other projects in this portfolio.

## 3. Create the DAX measures

Go to **Report** view → select the `FactSales` table in the Fields pane → **Modeling** tab → **New Measure**.
Paste in each measure from [`../dax/measures.dax`](../dax/measures.dax) one at a time (Power BI only lets you
create one measure per click of "New Measure", so copy each block separately). Start with the six **Core KPIs**
— the rest can be added as you build the pages that need them.

## 4. Build the report pages

Create four report pages (right-click the page tab at the bottom → Rename):

### Page 1 — Executive Overview

- **KPI cards** (Card visual) across the top: `Total Revenue`, `Total Orders`, `Average Order Value`, `Total Customers`.
- **Line chart**: X = `DimDate[YearMonth]`, Y = `Total Revenue` → title "Monthly Revenue Trend".
- **Area/line chart**: X = `DimDate[Date]`, Y = `Running Total Revenue` → title "Cumulative Revenue".
- **Bar chart**: X = `Total Revenue`, Y = `DimCustomer[Country]`, sorted descending, top 10 → title "Revenue by Country".
- **Donut chart**: `DimProduct[Genre]` by `Total Revenue`, top 8 → title "Revenue by Genre".
- Add a **slicer** for `DimDate[Year]` at the top of the page, synced to all pages (Format → Edit Interactions /
  Sync Slicers pane).

### Page 2 — Customer Analysis

- **Table**: `DimCustomer[CustomerName]`, `DimCustomer[Country]`, `Total Orders`, `Total Revenue`,
  `Customer Revenue Rank` — sort by revenue descending, this is your "Top Customers" view.
- **Map or filled map**: `DimCustomer[Country]`, size/color = `Total Revenue`.
- **Clustered bar**: `Total Customers` by `DimCustomer[Country]`.
- **Card**: `Average Revenue Per Customer`, `Orders Per Customer`.
- **Slicer**: `DimCustomer[Country]`.

### Page 3 — Product Performance

- **Bar chart**: top 10 `DimProduct[Genre]` by `Total Revenue`.
- **Bar chart**: top 10 `DimProduct[ArtistName]` by `Total Revenue`.
- **Table**: top 10 individual tracks (`DimProduct[TrackName]`, `DimProduct[ArtistName]`, `Total Revenue`,
  `Total Units Sold`), sorted descending.
- **Treemap**: `DimProduct[Genre]` sized by `Total Revenue` — a good visual variety pick for this page.
- **Slicer**: `DimProduct[Genre]`.

### Page 4 — Sales Rep Performance

- **Table**: `DimEmployee[EmployeeName]`, `DimEmployee[Title]`, `Total Customers`, `Total Orders`, `Total Revenue`.
- **Clustered column chart**: `Total Revenue` by `DimEmployee[EmployeeName]`.
- **Card**: highest-performing rep (use a table sorted descending + "Show value as" or a top-N filter).

## 5. Formatting pass (do this last, on every page)

- Every visual gets a clear, business-readable **title** (not the default field name).
- Add **data labels** on bar/column charts showing the value (Format visual → Data labels → On).
- Keep **legends** only where there are 2+ series; a single-series chart doesn't need one (its title already says
  what it is).
- Use the same **date slicer** placement and size on every page for a consistent feel.
- Add a **text box** header on Page 1 with the dashboard title and your name.

## 6. Publish / export

- **File → Export → Export to PDF** for a portable snapshot to include as a screenshot in the README.
- If you have a Power BI Service (Fabric) account, **Publish** the report there and grab a shareable link —
  optional, but a live link is a strong addition to a portfolio.
- Save the `.pbix` file and commit it to this project folder (`power-bi-sales-dashboard/SalesPerformanceDashboard.pbix`).

## 7. Update the README

Once built, take a screenshot of each page and drop them into [`../images/`](../images/), then reference them in
[`../README.md`](../README.md) (placeholders are already there) so the finished dashboard is visible to anyone
browsing the repo without opening Power BI.
