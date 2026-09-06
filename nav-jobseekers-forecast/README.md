# NAV Job Seekers by Occupation — Trend Analysis & Forecasting

Real analytical depth, not just EDA: this project cleans, models, forecasts, and clusters real data published by
**NAV** (Arbeids- og velferdsetaten, the Norwegian Labour and Welfare Administration) — going beyond descriptive
statistics into supervised and unsupervised machine learning.

## Data source

NAV publishes open datasets through its data portal ("Datahotellet"), mirrored publicly at
[github.com/datahotellet/dataset-archive](https://github.com/datahotellet/dataset-archive/tree/main/datasets/nav/arbeidssokere-yrke)
(confirmed as NAV's own archive via its `meta.xml`: *"NAV - Arbeids- og velferdforvaltningen"*, nav.no).

The dataset — **`arbeidssokere-yrke`** — is annual counts of registered job seekers ("arbeidssøkere": the sum of
fully unemployed, partially unemployed, people on labour-market measures, and other job seekers), broken down by
occupation, covering **2002–2017** (5,734 rows, 667 individual occupations grouped into 15 broad categories).

**Honest scope note:** this is the historical extract NAV published to the archive — it does not extend past
2017. This project is a methodology showcase (cleaning real government data, modeling, evaluating, clustering);
the same pipeline applies unchanged to a more recent NAV/SSB feed.

## What makes this "real analytical depth"

Unlike a pure exploratory-data-analysis project, this one includes:

- **A genuine data-quality problem, handled honestly**: 5.6% of rows are privacy-suppressed (`*`) by NAV to
  protect individuals in small-count cells — coerced to `NaN` and explicitly excluded from magnitude aggregates,
  not silently treated as zero.
- **Supervised learning with an honest evaluation**: a `LinearRegression` forecast trained on 2002–2013, tested
  against the 2014–2017 years NAV actually observed, scored with MAE/RMSE/MAPE — and the result is reported even
  though the naive linear trend *underpredicts* the real numbers (a finding, not a failure to hide).
- **Unsupervised learning**: `KMeans` clustering of the 15 occupation groups by the *shape* of their normalized
  job-seeker trend (indexed to 2002 = 100), surfacing groups with distinct crisis sensitivity that a simple
  ranking would miss.
- **Trend quantification**: compound annual growth rate (CAGR) per occupation group, not just an eyeballed line
  chart.

## Notebook

[`notebooks/nav_jobseekers_analysis.ipynb`](notebooks/nav_jobseekers_analysis.ipynb) — data cleaning, EDA, CAGR
analysis, forecasting (with train/test evaluation), and KMeans clustering, fully executed with saved outputs.

## Key findings

- **Job-seeker volume closely tracks real macroeconomic shocks** — the 2008–2009 financial crisis produced a
  sharp, visible spike in the aggregate series, a useful sanity check that this administrative data reflects real
  conditions.
- **Ingeniør- og ikt-fag** (engineering/IT) and **Bygg og anlegg** (construction) grew fastest in job-seeker
  volume (+4.0%/+2.7% CAGR); **Undervisning** (teaching) and the residual "no occupation background" group
  declined (-1.6%/-5.5% CAGR).
- **A naive linear forecast underpredicts 2014–2017 actuals** — quantified via MAPE — directly motivating a model
  with a business-cycle or oil-price covariate for a country as exposed to oil-price swings as Norway.
- **Clustering by trend shape** (not just size) separates occupation groups into distinct crisis-sensitivity
  patterns — the kind of grouping that could inform which occupations need retraining support during a downturn
  versus structural, longer-term decline.

## Tools

Python · Pandas · scikit-learn (`LinearRegression`, `KMeans`, `StandardScaler`) · Matplotlib · Seaborn
