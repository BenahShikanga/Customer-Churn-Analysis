# Data model

A star schema: one fact table (transactions) surrounded by dimension tables (descriptive attributes). This is the
standard, Power-BI-recommended shape — it keeps every measure a simple aggregation over `FactSales` while letting
you slice by any dimension without duplicating data.

```
                    DimDate
                (Date, Year, Quarter,
                 MonthName, YearMonth, ...)
                        │
                        │ Date ── InvoiceDate
                        │
DimCustomer ──CustomerId──► FactSales ◄──ProductId── DimProduct
(CustomerName,              (SalesId, InvoiceId,      (TrackName, AlbumTitle,
 Country, City,              InvoiceDate,               ArtistName, Genre,
 EmployeeId)                 CustomerId, ProductId,      MediaType, ListPrice)
     │                       UnitPrice, Quantity,
     │ EmployeeId            LineTotal)
     ▼
DimEmployee
(EmployeeName, Title,
 City, Country, HireDate)
```

## Tables

| Table | Grain | Row count |
|---|---|---|
| `FactSales` | one row per invoice line item | 2,240 |
| `DimCustomer` | one row per customer | 59 |
| `DimEmployee` | one row per sales rep | 8 |
| `DimProduct` | one row per track (with album/artist/genre attached) | 3,503 |
| `DimDate` | one row per calendar day, spanning the full invoice date range | 1,817 |

## Why line-item grain (not invoice-level)?

`FactSales` is built from `InvoiceLine`, not `Invoice`, so that revenue can be sliced by product/genre/artist —
that detail doesn't exist at the invoice level. Order-level metrics (`Total Orders`, `Average Order Value`) still
work correctly because the DAX measures use `DISTINCTCOUNT(FactSales[InvoiceId])` rather than counting rows.
