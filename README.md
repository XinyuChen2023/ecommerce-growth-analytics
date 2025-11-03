# E-commerce Growth Analytics

## Project Overview

This project analyzes e-commerce performance data from a Shopify store to identify key growth drivers, conversion bottlenecks, and retention opportunities across the customer lifecycle. The analysis combines data cleaning, SQL analytics, and Tableau visualizations to provide actionable insights for marketing, retention, and revenue optimization.

### Key Questions Addressed

1. **Traffic Acquisition**: Which channels drive the most valuable traffic and conversions?
2. **Conversion Funnel**: Where do users drop off in the purchase journey?
3. **Channel & Device Performance**: How do different traffic sources and devices perform?
4. **Product Contribution**: Which products drive the most revenue and growth?
5. **Customer Retention**: How do customer cohorts behave over time?
6. **Geographic Insights**: Which markets show the strongest performance?

---

## Project Structure

```
Ecommerce_Growth_Analytics/
├── data/
│   ├── raw/                          # Raw data exports from Shopify
│   │   ├── customers_export.csv
│   │   ├── orders_export_1.csv
│   │   ├── sessions_over_time.csv
│   │   └── Total sales by product variant.csv
│   └── clean/                        # Cleaned, analysis-ready data
│       ├── customers_clean.csv
│       ├── customers_clean_bq_schema.json
│       ├── orders_clean.csv
│       ├── orders_clean_bq_schema.json
│       ├── sessions_over_time_clean.csv
│       ├── sessions_over_time_bq_schema.json
│       ├── sales_by_product_clean.csv
│       ├── sales_by_product_schema.json
│       └── funnel_over_time_export.csv
│
├── src/
│   ├── cleaning/                     # Data cleaning notebooks
│   │   ├── shopify_customers.ipynb   # Customer data cleaning & internal employee exclusion
│   │   ├── shopify_orders.ipynb      # Order data cleaning & standardization
│   │   ├── shopify_product_sales.ipynb  # Product sales data cleaning
│   │   └── shopify_sessions.ipynb    # Session/traffic data cleaning
│   │
│   └── sql/                          # BigQuery SQL views and analytics
│       ├── fact_orders_daily.sql     # Daily order aggregations
│       ├── daily_performance.sql     # Daily KPIs with rolling averages
│       ├── v_funnel_over_time.sql    # Conversion funnel analysis
│       ├── v_channel_performance_daily.sql    # Daily channel performance
│       ├── v_channel_performance_weekly.sql   # Weekly channel performance
│       ├── v_channel_performance_monthly.sql  # Monthly channel performance
│       ├── v_device_performance.sql  # Device type performance analysis
│       ├── v_orders_by_traffic_source.sql    # Traffic source attribution
│       ├── v_product_performance.sql         # Product-level sales metrics
│       ├── v_product_trends_daily.sql        # Daily product sales trends
│       ├── v_geo_performance.sql    # Geographic performance analysis
│       └── v_customer_cohort.sql    # Customer cohort retention analysis
│
├── notebook_bigquery_helper.py       # Helper utilities for BigQuery operations
└── README.md                          # This file
```

---

## Data Sources & Cleaning

### Raw Data Sources

1. **Customers Export** (`customers_export.csv`)
   - Customer demographics, contact information, addresses
   - Marketing preferences (email/SMS)
   - Lifetime value metrics (total spent, total orders)
   - Tags and custom fields

2. **Orders Export** (`orders_export_1.csv`)
   - Order details with line items
   - Financial status, fulfillment status
   - Payment methods, shipping/billing addresses
   - Discounts, taxes, totals
   - Transaction timestamps

3. **Sessions Over Time** (`sessions_over_time.csv`)
   - Daily session counts by device type
   - Traffic source/referrer information
   - Geographic data (country-level)
   - Date ranges

4. **Product Sales** (`Total sales by product variant.csv`)
   - Product and variant-level sales
   - Units sold, gross sales, discounts
   - Returns, taxes, net sales

### Data Cleaning Process

All cleaning notebooks follow a consistent pattern:

1. **Column Normalization**: Convert to snake_case for consistency
2. **Type Coercion**: Safely convert dates, numerics, and handle edge cases
3. **Data Quality**: Remove empty rows/columns, handle duplicates
4. **Business Rules**: 
   - **Customer Data**: Exclude internal employees (customers with 'test' in first/last name or @inscoder.com email domain)
   - **Order Data**: Filter for paid, non-cancelled orders
5. **Schema Generation**: Auto-generate BigQuery schema JSON files for easy upload

#### Cleaning Notebooks

- **`shopify_customers.ipynb`**: Cleans customer data, excludes internal employees, generates `customers_clean.csv`
- **`shopify_orders.ipynb`**: Cleans order data with line items, generates `orders_clean.csv`
- **`shopify_product_sales.ipynb`**: Cleans product sales data, generates `sales_by_product_clean.csv`
- **`shopify_sessions.ipynb`**: Cleans session/traffic data, generates `sessions_over_time_clean.csv`

---

## SQL Analytics & Views

The project includes comprehensive SQL views for BigQuery analysis:

### Core Fact Tables

- **`fact_orders_daily`**: Daily aggregated order metrics (orders, revenue, units, AOV)

### Performance Views

- **`v_daily_performance`**: Daily KPIs with 7-day rolling averages and week-over-week comparisons
- **`v_weekday_pattern`**: Weekly seasonality patterns (average revenue/orders by weekday)
- **`v_last_30_kpis`**: Last 30-day summary metrics

### Channel & Traffic Analysis

- **`v_orders_by_traffic_source`**: Traffic source attribution with sessions, orders, revenue
- **`v_channel_performance_daily`**: Daily channel performance metrics
- **`v_channel_performance_weekly`**: Weekly channel aggregations
- **`v_channel_performance_monthly`**: Monthly channel aggregations
- **`v_device_performance`**: Device type performance (desktop, mobile, tablet)

### Conversion & Funnel

- **`v_funnel_over_time`**: Time-series conversion funnel (sessions → orders → revenue)

### Product Analysis

- **`v_product_performance`**: Product-level metrics (units sold, gross/net sales, discounts, returns, AOV)
- **`v_product_trends_daily`**: Daily product sales trends

### Customer Analysis

- **`v_customer_cohort`**: Customer cohort retention analysis by months since first purchase

### Geographic Analysis

- **`v_geo_performance`**: Country-level performance (sessions, orders, revenue, conversion rates)

---

## Tableau Dashboards & Visualizations

**Note**: Data visualization will be done in Tableau. Dashboards and visualizations will be updated to the project repository later.

### 1. Traffic Acquisition Dashboard

**Purpose**: Analyze traffic sources and their contribution to business growth

**Key Metrics**:
- Sessions by traffic source (organic, paid, direct, referral, social, etc.)
- Conversion rate by source
- Revenue per session by source
- Traffic source trends over time
- Channel acquisition cost vs. value

**Visualizations**:
- [Placeholder -- Traffic Acquisition Dashboard Screenshot]

---

### 2. Conversion Funnel Dashboard

**Purpose**: Identify drop-off points in the customer journey

**Key Metrics**:
- Sessions → Orders conversion rate
- Revenue per session
- Funnel conversion rates over time
- Daily/weekly conversion trends
- Funnel performance by channel

**Visualizations**:
- [Placeholder -- Conversion Funnel Dashboard Screenshot]

---

### 3. Channel & Device Performance Dashboard

**Purpose**: Compare performance across marketing channels and device types

**Key Metrics**:
- Performance by channel (daily, weekly, monthly)
- Device type performance (desktop, mobile, tablet)
- Channel vs. device cross-tabulation
- Conversion rates by channel and device
- Revenue attribution by channel

**Visualizations**:
- [Placeholder -- Channel & Device Performance Dashboard Screenshot]

---

### 4. Product Contribution Dashboard

**Purpose**: Understand which products drive revenue and growth

**Key Metrics**:
- Product-level sales (units, revenue, AOV)
- Product performance trends over time
- Discount rates and return rates by product
- Top products by revenue and units sold
- Product contribution to total revenue

**Visualizations**:
- [Placeholder -- Product Contribution Dashboard Screenshot]

---

### 5. Customer Retention & Cohort Behavior Dashboard

**Purpose**: Analyze customer lifetime value and retention patterns

**Key Metrics**:
- Cohort retention rates (by month since first purchase)
- Revenue per cohort over time
- Customer lifetime value distribution
- Repeat purchase rates
- Cohort size and revenue contribution

**Visualizations**:
- [Placeholder -- Customer Retention & Cohort Behavior Dashboard Screenshot]

---

### 6. Geographic Insights Dashboard

**Purpose**: Understand performance across different markets

**Key Metrics**:
- Sessions, orders, and revenue by country
- Conversion rates by geography
- Revenue per session by country
- Market penetration and growth opportunities

**Visualizations**:
- [Placeholder -- Geographic Insights Dashboard Screenshot]

---

## Key Analyses Completed

### 1. Data Cleaning & Preparation
- ✅ Cleaned and standardized all raw data exports
- ✅ Excluded internal employees from customer analysis
- ✅ Generated BigQuery-compatible schemas
- ✅ Prepared analysis-ready datasets

### 2. SQL Analytics Development
- ✅ Created comprehensive set of SQL views for BigQuery
- ✅ Implemented daily/weekly/monthly performance aggregations
- ✅ Built conversion funnel analysis
- ✅ Developed channel and device performance views
- ✅ Created product performance and trend analysis
- ✅ Implemented customer cohort retention analysis
- ✅ Built geographic performance analysis

### 3. Data Quality & Business Rules
- ✅ Filtered internal test accounts and employee data
- ✅ Standardized data types and formats
- ✅ Handled edge cases (nulls, duplicates, invalid values)
- ✅ Ensured data consistency across sources

---

## Next Steps

1. **Tableau Development**: Build dashboards for the six key areas outlined above
2. **Dashboard Updates**: Add screenshots and descriptions of Tableau visualizations
3. **Insights Documentation**: Document key findings and recommendations from the analysis
4. **Automation**: Consider automating data pipeline (cleaning → BigQuery → Tableau refresh)

---

## Technical Stack

- **Data Cleaning**: Python (Pandas), Jupyter Notebooks
- **Data Warehouse**: Google BigQuery
- **SQL**: BigQuery SQL
- **Data Visualization**: Tableau (to be added)
- **Version Control**: Git/GitHub

---

## Data Privacy & Security

- Internal employee data are excluded from all analyses
- Customer data is handled according to privacy best practices
- All sensitive data should be stored securely and not committed to version control

---

## Contributing

This is a private analytics project. For questions or contributions, please contact the project owner.

---

## License

[Add license information if applicable]
