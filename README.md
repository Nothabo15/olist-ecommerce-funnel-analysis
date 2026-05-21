<div align="center">

# Olist E-Commerce — Funnel Performance Analysis

### End-to-End Data Analytics Project

**Analyst: Nothabo Michelle Moyo**    
**Tools: SQLite · Tableau Public**    
**Period: October 2016 – August 2018**

[![Tableau](https://img.shields.io/badge/Live%20Dashboard-Tableau%20Public-1F77B4?style=for-the-badge&logo=tableau&logoColor=white)](https://public.tableau.com/authoring/OlistE-CommerceFunnelPerformanceDashboard/Dashboard1#1)
[![SQL](https://img.shields.io/badge/Data%20Cleaning-SQLite-F48024?style=for-the-badge&logo=sqlite&logoColor=white)](sql/olist_final_clean_script.sql)
[![EDA](https://img.shields.io/badge/Analysis-12%20SQL%20Queries-4CAF50?style=for-the-badge&logo=sqlite&logoColor=white)](sql/olist_eda.sql)
[![Dataset](https://img.shields.io/badge/Dataset-104%2C478%20Orders-9C27B0?style=for-the-badge)](data/final_cleaned_dataset.csv)

</div>

---

## Live Dashboard
> **[Click here to explore the interactive dashboard →](https://public.tableau.com/authoring/OlistE-CommerceFunnelPerformanceDashboard/Dashboard1#1)**

![Olist E-Commerce Funnel Performance Dashboard](dashboard/Olist%20Dashboard.png)

*Cross-filtering enabled click any chart element to filter the entire dashboard*

---

## Project Overview

This project delivers a full end-to-end analysis of the **Olist Brazilian e-commerce marketplace**, examining 104,458 orders across two years of platform operations.

The workflow covers every stage of the analytics pipeline:

**Raw Data → SQL Cleaning → Feature Engineering → Exploratory Analysis → Executive Dashboard → Business Recommendations**

The central business question driving this analysis:

> *"Where is the marketplace losing orders, revenue, and customers and what should leadership prioritise to fix it?"*

---

## Executive Summary

| Metric | Value | Signal |   
|---|---|---|   
| Total Orders | 104,458 | Strong platform scale |   
| Total Revenue Analysed | $16,081,420 | High-value marketplace |   
| Delivery Rate | 97.00% | Operationally strong |   
| Avg Review Score | 4.08 / 5 | Positive customer sentiment |    
| Avg Order Value | $153.90 | Healthy basket size |   
| Avg Delivery Time | 12.58 days | Primary improvement opportunity |   
| Orders Exceeding 15 Days | 33.35% | Critical logistics gap |   

### Three findings that define the business priority

**1. Delivery speed is the single largest driver of customer satisfaction.** Customers who receive orders in 0–3 days give an average of 4.48 stars. Customers who wait 15+ days give 3.72 stars. That 0.76-point gap across 33% of all orders represents a material, measurable damage to marketplace reputation.

**2. Late delivery cuts satisfaction scores by 40%.** On-time orders average 4.29 stars. Late orders average 2.56 stars. This is not a marginal difference,it is the difference between a loyal customer and a churned one.

**3. $1,947,012 in revenue is at risk every year.** Orders that are late or undelivered represent 12.1% of total revenue at higher-than-average order values (late: $166.24 avg, undelivered: $186.97 avg). High-value orders are disproportionately exposed to fulfilment failure.

---

## Methodology

### Phase 1 — Data Cleaning & Feature Engineering

*File: `sql/olist_final_clean_script.sql`  13 structured steps*

The raw Olist dataset required significant preparation before it was fit for analysis. The cleaning pipeline was built in SQLite and executed in strict logical sequence:

| Step | Action | Purpose |  
|---|---|---|   
| 1 | Base table creation with `DISTINCT` deduplication | Remove duplicate order records |   
| 2 | Data integrity checks — duplicates and nulls | Understand data completeness before any transformation |   
| 3 | Remove logically invalid records | Delete orders delivered or approved before purchase timestamp |   
| 4 | Standardise order status with `LOWER(TRIM())` | Eliminate case inconsistencies across status values |   
| 5 | Create binary funnel flags (`is_created`, `is_approved`, `is_shipped`, `is_delivered`) | Enable stage-by-stage funnel tracking |  
| 6 | Time-based feature engineering using `julianday()` | Calculate `approval_days`, `shipping_days`, `delivery_days`, `total_fulfillment_days` |   
| 7 | Null out negative durations | Remove physically impossible time calculations |   
| 8 | Delivery performance classification | Classify each order as On Time / Late / Not Delivered vs estimated date |  
| 9 | Join order reviews (`LEFT JOIN`) | Attach customer satisfaction scores to order records |   
| 10 | Clean review scores | Null out scores outside valid 1–5 range |    
| 11 | Join payment data | Attach payment type and value to each order |   
| 12 | Join customer location | Attach state-level geographic data |    
| 13 | Final validation checks | Verify funnel totals, delivery distribution, and null counts |    

**Output:** `final_cleaned_dataset` a single analytical table joining orders, reviews, payments, and customer location, ready for analysis.

---

### Phase 2 — Exploratory Data Analysis

*File: `sql/olist_eda.sql` 12 structured queries*

| Step | Analysis | Business Question Answered |  
|---|---|---|  
| 1 | Executive KPI overview | What is the platform's headline performance? |  
| 2 | Funnel drop-off analysis (CTE) | At which stage are the most orders being lost? |   
| 3 | Monthly cohort performance | How has performance changed as the platform scaled? |   
| 4 | Delivery speed distribution (window functions) | What is the standard customer delivery experience? |   
| 5 | Delivery performance vs satisfaction | Does delivery speed actually drive review scores? |    
| 6 | Payment method performance | Which payment types drive the most revenue and best outcomes? |   
| 7 | Geographic performance analysis | Which states lead and which lag in delivery efficiency? |   
| 8 | Approval delay impact | Does a slow approval process affect downstream fulfilment? |   
| 9 | Review participation funnel | What proportion of delivered orders generate reviews? |   
| 10 | High-risk order identification | Which specific orders represent the greatest operational risk? |   
| 11 | Revenue analysis by funnel completion | How much revenue is exposed to late and failed delivery? |   
| 12 | Delivery time vs review score correlation | Is the relationship between speed and satisfaction linear? |

---

### Phase 3 — Interactive Dashboard

*Platform: Tableau Public 7 charts, cross-filtering enabled*

| Chart | Type | Business Purpose |  
|---|---|---|   
| KPI Summary Bar | Scorecards | Headline metrics at a glance for executive stakeholders |   
| Order Funnel | Horizontal bar | Visual representation of order attrition across all stages |   
| Monthly Order Volume | Line chart | Growth trajectory with Black Friday peak annotated |    
| Order Outcome Distribution | Horizontal bar | On Time vs Late vs Not Delivered at volume |   
| Delivery Speed Distribution | Horizontal bar | Customer experience breakdown by delivery window |   
| Review Score by Delivery Status | Horizontal bar | Direct link between logistics performance and satisfaction |   
| Payment Method Mix | Horizontal bar | Transaction share and revenue by payment type |   
| Geographic Performance | Color-coded table | State-by-state delivery speed, rate, and satisfaction |

---

## Key Findings

### 1. Order Funnel — 96.98% End-to-End Retention

```
Stage               Orders     Drop-off    Drop-off Rate
─────────────────────────────────────────────────────────
Total Created       104,458         —              —
Total Approved      104,301       157           0.15%   ← payment failures
Total Shipped       102,579     1,722           1.65%   ← largest loss point
Total Delivered     101,324     1,255           1.22%   ← logistics failures
```

The platform retains 96.98% of orders through to successful delivery. However, the **approval-to-shipment gap is the single largest point of order loss** 1,722 orders failing to progress from approval to shipment. This points directly to seller-side operational failures: stock unavailability, slow pick-and-pack processes, or warehouse capacity constraints. Payment processing (0.15% loss) is not the problem. Fulfilment execution is.

---

### 2. Monthly Growth — 818% Volume Increase in 12 Months

| Period | Monthly Orders | Context |   
|---|---|---|   
| Sept 2016 | 4 | Platform launch |  
| Jan 2017 | 864 | Early growth phase |   
| Nov 2017 | 7,933 | Black Friday peak |   
| 2018 average | ~7,000 | Sustained post-peak plateau |   

The platform scaled from near-zero to 7,933 orders in a single month within 14 months of launch, an 818% increase. Critically, the 97% delivery rate was maintained throughout this scaling period, indicating that fulfilment infrastructure kept pace with demand growth. The persistent 33% of orders exceeding 15 days suggests, however, that **delivery speed optimisation did not scale at the same rate as order volume.**

---

### 3. Delivery Speed — The Standard Experience Is Not Fast Enough

| Window | Orders | Share | Avg Review Score |   
|---|---|---|---|   
|  0–3 Days | ~4,990 | 4.78% | 4.48  |  
|  4–7 Days | ~22,370 | 21.42% | 4.40 |  
|  8–14 Days | ~42,270 | 40.45% | 4.31|  
| 15+ Days | ~34,848 | 33.35% | 3.72 |  

The typical Olist customer waits 8–14 days for their order. Over a third wait more than 15 days. The relationship between speed and satisfaction is clear and consistent: every delivery window improvement corresponds to a measurable increase in review score. Fast delivery (0–3 days) reaches fewer than 5% of customers despite generating the highest satisfaction at 4.48.

---

### 4. Customer Satisfaction — Delivery Decides the Review

| Delivery Status | Avg Review | Orders | Revenue |  
|---|---|---|---|   
|  On Time | 4.29  | 93,158 | $14,134,408 |  
|  Late | 2.56  | 8,166 | $1,357,315 |  
|  Not Delivered | 1.76  | 3,154 | $589,697 |  

The correlation between delivery and satisfaction is direct and severe. A late delivery reduces the average review score by **40%**. A failed delivery produces reviews **59% lower** than on-time delivery. The review score by delivery days confirms this is a linear relationship:

| Review Score | Avg Delivery Days |  
|---|---|  
| 1  | 21.3 days |
| 2  | 16.7 days |
| 3  | 14.2 days |
| 4 | 12.3 days |
| 5  | 10.7 days |

Every additional day of delivery time moves customers toward lower scores. Every day saved moves them toward five stars.

---

### 5. Geographic Performance — A Two-Speed Marketplace

| State | Orders | Avg Delivery Days | Delivery Rate | Avg Review |  
|---|---|---|---|---|    
|  SP | 41,736 | 9 days | 97.0% | 4.17  |
|  RJ | 12,848 | 15 days | 96.1% | 3.88  |
|  MG | 11,631 | 12 days | 97.6% | 4.14  |
|  RS | 5,466 | 15 days | 97.8% | 4.13  |
|  PR | 5,045 | 12 days | 97.5% | 4.18  |
| SC | 3,636 | 15 days | 97.6% | 4.07  |
|  BA | 3,380 | 19 days | 96.5% | 3.87  |
| DF | 2,140 | 13 days | 97.2% | 4.06  |

São Paulo delivers in 9 days and earns 4.17 stars. Bahia takes 19 days and earns 3.87 stars. This is not a minor regional variation, it is a structurally different customer experience for over 3,000 customers in a single state. Customers in remote northern regions are systematically receiving a slower, lower-satisfaction experience through no fault of their own. Geographic logistics infrastructure is the root cause.

---


































































































































