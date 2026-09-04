# Chinook schema (tables used in this analysis)

The Chinook database models a digital media store. The tables relevant to this analysis and their relationships:

```
Artist (ArtistId, Name)
   │ 1
   │
   │ N
Album (AlbumId, Title, ArtistId)
   │ 1
   │
   │ N
Track (TrackId, Name, AlbumId, GenreId, MediaTypeId, UnitPrice, ...)
   │ 1                         │ N
   │                            │
   │ N                          │ 1
InvoiceLine (InvoiceLineId,     Genre (GenreId, Name)
             InvoiceId, TrackId,
             UnitPrice, Quantity)
   │ N
   │
   │ 1
Invoice (InvoiceId, CustomerId, InvoiceDate, BillingCountry, Total, ...)
   │ N
   │
   │ 1
Customer (CustomerId, FirstName, LastName, Country, SupportRepId, ...)
   │ N
   │
   │ 1
Employee (EmployeeId, FirstName, LastName, Title, ReportsTo, ...)
```

**Key relationships used by the queries in this project:**

- `Invoice.CustomerId → Customer.CustomerId` — which customer placed each order
- `InvoiceLine.InvoiceId → Invoice.InvoiceId` — line items belonging to each order
- `InvoiceLine.TrackId → Track.TrackId` — which track was sold on each line item
- `Track.AlbumId → Album.AlbumId → Artist.ArtistId` — track → album → artist
- `Track.GenreId → Genre.GenreId` — track → genre
- `Customer.SupportRepId → Employee.EmployeeId` — which employee manages each customer

Revenue can be computed two ways that agree with each other: `SUM(Invoice.Total)` (order-level) or
`SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity)` (line-item level) — the latter is required whenever a query
needs to break revenue down by track/genre/artist, since that detail doesn't exist at the `Invoice` level.
