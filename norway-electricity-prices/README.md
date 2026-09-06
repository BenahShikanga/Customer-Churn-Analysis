# Norwegian Electricity Prices — Regional Divergence, Volatility & Forecasting

Real, dramatic Norwegian data: day-ahead electricity spot prices across Norway's 5 price zones through the
2021–2023 energy crisis, analyzed with correlation analysis, rolling volatility, unsupervised regime detection,
and a genuinely evaluated short-term forecasting model.

## Data source

Daily average day-ahead spot prices (NOK/kWh) for Norway's 5 price zones (NO1–NO5), originally from **Nord
Pool** (the Nordic power exchange), aggregated and maintained by statistician Martin Jullum's open
[`stromstotte`](https://github.com/martinju/stromstotte) project — built to help Norwegians estimate the
government's electricity subsidy ("strømstøtte"). Covers **2021-11-01 to 2024-10-15** (5,400 rows, 1,080 days ×
5 zones, no missing values).

**Price zones:** NO1 (Sørøst-Norge/Oslo) · NO2 (Sørvest-Norge/Kristiansand) · NO3 (Midt-Norge/Trondheim) ·
NO4 (Nord-Norge/Tromsø) · NO5 (Vestlandet/Bergen).

## Notebook

[`notebooks/electricity_price_analysis.ipynb`](notebooks/electricity_price_analysis.ipynb) — fully executed,
covering EDA, the north/south divide, zone correlation, rolling volatility, KMeans regime clustering, and a
forecasting model with an honest baseline comparison.

## Key findings

- **The north/south price divide is large and real**: during the August–September 2022 peak, the single-day gap
  between southern Norway and NO4 (north) reached **7.96 NOK/kWh**; the 2022 average gap was **2.25 NOK/kWh**,
  versus just **0.31 NOK/kWh** by 2024 as prices normalized.
- **NO1, NO2, and NO5 move almost as one market** (correlation ≈ 0.9+); **NO4 is substantially decoupled** —
  confirmed statistically, not just by eye.
- **Volatility spiked alongside price level** during the crisis — the south wasn't just expensive, it was
  unpredictable, a distinct and separately useful signal from the price chart alone.
- **KMeans clustering of daily 5-zone price patterns recovers three market regimes** (calm, intermediate, crisis)
  and pins down exactly when each phase started and ended — without being told the crisis dates in advance.
- **A next-day forecasting model for NO2 beats a "tomorrow = today" naive baseline by only ~5%** — reported as
  the correct, honest result for an auction-priced market that already prices in available public information,
  not as a modeling failure.

## Why this matters (policy angle)

Any national scheme — like the actual `strømstøtte` subsidy this data was originally collected to model — that
uses a single national average price is, by construction, systematically wrong for both the highest-paying south
and the barely-affected north. The regional gap quantified here is a direct, data-driven case for zone-aware
policy design.

## Tools

Python · Pandas · scikit-learn (`LinearRegression`, `KMeans`, `StandardScaler`) · Matplotlib · Seaborn
