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




































