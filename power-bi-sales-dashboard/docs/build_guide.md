# Build Guide — Sales Performance Dashboard

Power BI Desktop is Windows-only. Pick the path that matches your machine:

- **Path A — Power BI Service (browser)**: works natively on Mac, free, no install. Use this unless you already
  have Windows available. Menu labels in the web editor shift over time, so this section gives you the workflow
  and points to Microsoft's live docs for exact click-paths — treat those docs as the source of truth if a button
  has moved.
- **Path B — Power BI Desktop (Windows or a Windows VM on Mac)**: the traditional, more precise authoring
  experience. Use this if you set up a Windows VM (Parallels/VMware + a free Windows dev VM) or have access to a
  Windows machine.

Both paths build the same data model, measures, and report — sections 2 onward are shared.

## Path A — Power BI Service (browser, Mac-friendly)

1. **Combine the 5 CSVs into one Excel workbook** — the browser import flow works far more smoothly with one
   `.xlsx` file than five separate CSVs. On a Mac, open Excel (or Numbers/Google Sheets, then export to `.xlsx`)
   and create one workbook with 5 sheets — `FactSales`, `DimCustomer`, `DimEmployee`, `DimProduct`, `DimDate` —
   pasting in each CSV's data, and format each sheet's data as an **Excel Table** (select the data → Insert →
   Table) so Power BI recognizes clean column headers and types.
2. Upload that workbook to **OneDrive**.
3. Sign in at [app.powerbi.com](https://app.powerbi.com) (sign up free if needed — if it insists on a work/school
   email and you only have a personal one, look for the Microsoft Fabric free-trial signup flow, which accepts a
   broader range of accounts).
4. In a workspace, choose **Get data → OneDrive** (or **New → Upload a file**), select the workbook, and import it
   as a dataset/semantic model (not just "view in Excel").
5. Open the resulting **semantic model** in the browser. Use its **Data**/modeling view to build the relationships
   and measures described in sections 2–3 below — the web modeling experience mirrors Desktop's Model view and
   "New measure" flow closely enough that the same steps apply, just inside the browser tab instead of an app
   window.
6. From the semantic model, choose **Create report** to build the pages visually in the browser (section 4).
7. Current, authoritative click-by-click steps: [Microsoft Learn — Create a report in the Power BI service](https://learn.microsoft.com/power-bi/create-reports/service-report-create-new).

## Path B — Power BI Desktop

1. Install Power BI Desktop from the Microsoft Store, or set up a Windows VM first (Parallels Desktop / VMware
   Fusion + a free [Windows 11 dev VM](https://aka.ms/windowsdevvm) from Microsoft), then install it there.
2. Open Power BI Desktop → **Get Data** → **Text/CSV** → import all 5 files from [`../data/`](../data/):
   `fact_sales.csv`, `dim_customer.csv`, `dim_employee.csv`, `dim_product.csv`, `dim_date.csv`.
3. Click **Transform Data** and check each table's column types (Power BI usually infers correctly, but confirm
   `InvoiceDate`/`Date` are typed as **Date**, not text, and IDs are **Whole Number**). Click **Close & Apply**.

## 2. Build the data model (star schema)

Go to the **Model** view (Desktop) or the semantic model's relationship view (Service) and create these
relationships by dragging field-to-field:

| From | To | Cardinality |
|---|---|---|
| `FactSales[CustomerId]` | `DimCustomer[CustomerId]` | Many-to-one |
| `FactSales[ProductId]` | `DimProduct[ProductId]` | Many-to-one |
| `FactSales[InvoiceDate]` | `DimDate[Date]` | Many-to-one |
| `DimCustomer[EmployeeId]` | `DimEmployee[EmployeeId]` | Many-to-one |

This is a standard **star schema**: `FactSales` in the middle, dimension tables around it — the layout Power BI
(and every BI tool) is optimized for. See [`data_model.md`](data_model.md) for the diagram.

**Mark `DimDate` as a date table**: select `DimDate` → **Mark as Date Table** → pick the `Date` column. This is
required for the time-intelligence DAX measures (`SAMEPERIODLASTYEAR`, etc.) to work.

## 3. Load the theme (Desktop; try the same in Service if the option is present)

**View** tab → **Themes** → **Browse for themes** → select [`../theme/portfolio_theme.json`](../theme/portfolio_theme.json).
This applies a consistent, colorblind-checked color palette matching the other projects in this portfolio. If the
web report editor doesn't expose a theme-import option for your account tier, skip this — it's cosmetic only.

## 4. Create the DAX measures

Select the `FactSales` table in the Fields pane → **New Measure**. Paste in each measure from
[`../dax/measures.dax`](../dax/measures.dax) one at a time (only one measure per click of "New Measure", so copy
each block separately). Start with the six **Core KPIs** — the rest can be added as you build the pages that need them.

## 5. Build the report pages

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

## 6. Formatting pass (do this last, on every page)

- Every visual gets a clear, business-readable **title** (not the default field name).
- Add **data labels** on bar/column charts showing the value (Format visual → Data labels → On).
- Keep **legends** only where there are 2+ series; a single-series chart doesn't need one (its title already says
  what it is).
- Use the same **date slicer** placement and size on every page for a consistent feel.
- Add a **text box** header on Page 1 with the dashboard title and your name.

## 7. Publish / export

- **Path A (Service)**: the report already lives in your workspace — just grab its **shareable link**
  (Share button), or use **File → Export to PDF** for a snapshot.
- **Path B (Desktop)**: **File → Export → Export to PDF** for a snapshot; **Publish** to the Power BI Service for
  a shareable link; save the `.pbix` file and commit it to this project folder
  (`power-bi-sales-dashboard/SalesPerformanceDashboard.pbix`).

## 8. Update the README

Once built, take a screenshot of each page and drop them into [`../images/`](../images/), then reference them in
[`../README.md`](../README.md) (placeholders are already there) so the finished dashboard is visible to anyone
browsing the repo without opening Power BI. If you published to the Service, add that shareable link to the
README too.
