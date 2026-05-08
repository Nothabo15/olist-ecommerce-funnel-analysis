--- ==========================================================================
--- OLIST E-COMMERCE FUNNEL ANALYSIS: EXPLORATORY DATA ANALYSIS
--- DATA ANALYST: NOTHABO MICHELLE MOYO
--- DATE: 1/05/2026
--- DATA SOURCE: final_cleaned_dataset
--- ==========================================================================

-- STEP 1: EXECUTIVE KPI OVERVIEW
-- total_orders 104478/ approved_rate 99.83%/ shipping_rate 98.18%
-- delivery_rate 96.98%/ avg_review_score 4.08/ 
-- avg_delivery_days 12.58/ avg_order_value 153.92
SELECT
			COUNT(*) AS total_orders, 
			ROUND(AVG(is_approved) * 100, 2) AS approved_rate,
			ROUND(AVG(is_shipped) *100, 2) AS shipping_rate,
			ROUND(AVG(is_delivered) *100, 2) AS delivery_rate,
			ROUND(AVG(review_score), 2) AS avg_review_score, 
			ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
			ROUND(AVG(payment_value), 2) AS avg_order_value
FROM final_cleaned_dataset;
-- INSIGHTS:
-- Approval rate is extremely high, indicating minimal payment/order issues.
-- Strong fulfillment performance with high shipping and delivery completion.
-- Average review score above 4 suggests positive customer satisfaction.
-- Average delivery time of ~12.6 days may indicate logistics optimization opportunities.
-- Average order value helps estimate customer spending behavior.

-- STEP 2: FUNNEL DROP-OFF ANALYSIS
-- Created → Approved  176	0.17
-- Approved → Shipped	1722	1.65
-- Shipped → Delivered	1256	1.22
WITH funnel AS (
    SELECT 
        COUNT(*) AS total_orders,
        SUM(is_created) AS created, 
        SUM(is_approved) AS approved, 
        SUM(is_shipped) AS shipped,
        SUM(is_delivered) AS delivered
    FROM final_cleaned_dataset
)

SELECT 
    'Created → Approved' AS stage, 
    created - approved AS drop_off,
    ROUND((created - approved) * 100.0 / created, 2) AS drop_off_rate
FROM funnel

UNION ALL

SELECT 
    'Approved → Shipped' AS stage, 
    approved - shipped AS drop_off, 
    ROUND((approved - shipped) * 100.0 / approved, 2) AS drop_off_rate
FROM funnel

UNION ALL

SELECT 
    'Shipped → Delivered' AS stage,
    shipped - delivered AS drop_off, 
    ROUND((shipped - delivered) * 100.0 / shipped, 2) AS drop_off_rate
FROM funnel;
-- BUSINESS INSIGHTS:
-- The e-commerce funnel demonstrates strong operational efficiency overall.
-- Order approval losses are negligible (0.17%), indicating reliable payment processing.
-- The highest drop-off occurs between approval and shipment (1.65%),
-- suggesting potential inventory shortages, seller delays, or warehouse inefficiencies.
-- Delivery completion remains strong with only 1.22% shipment failure,
-- reflecting relatively effective logistics operations.

-- STEP 3: MONTHLY COHORT PERFORMANCE
ALTER TABLE final_cleaned_dataset
ADD COLUMN order_month TEXT;

UPDATE final_cleaned_dataset
SET order_month = 
							strftime('%Y-%m', order_purchase_timestamp);

SELECT 
			order_month, 
			COUNT(*) AS total_orders, 
			ROUND(AVG(is_approved) * 100, 2) AS approved_rate,
			ROUND(AVG(is_delivered) * 100, 2) AS delivery_rate, 
			ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM final_cleaned_dataset
GROUP BY order_month
ORDER BY order_month;
-- EXECUTIVE INSIGHTS:
--The platform experienced rapid year-over-year order growth.
-- Operational performance remained consistently strong during scaling.
-- Delivery efficiency significantly improved throughout 2018.
-- Holiday-season order surges created temporary logistics slowdowns.
-- Late 2018 records appear incomplete.

-- STEP 4: DELIVERY SPEED DISTRIBUTION
SELECT 
		CASE 
				WHEN delivery_days <= 3 THEN '0 - 3 Days'
				WHEN delivery_days <= 7 THEN '4 - 7 Days'
				WHEN delivery_days <= 14 THEN '8 - 14 Days'
				ELSE '15+ Days'
       END AS delivery_bucket, 
	   
	   COUNT(*) AS orders, 
	   
	   ROUND(COUNT(*) * 100.0 / 
	   SUM(COUNT(*)) OVER (), 2) AS percentage

FROM final_cleaned_dataset
WHERE delivery_days IS NOT NULL

GROUP BY delivery_bucket
ORDER BY orders DESC;
-- EXECUTIVE INSIGHTS:
-- Most deliveries occur within 8–14 days, representing the standard customer experience.
-- Over 31% of deliveries exceed 15 days, indicating potential logistics inefficiencies.
-- Fast delivery capability remains limited, with fewer than 5% of orders delivered within 3 days.
-- Delivery speed optimization presents a major opportunity to improve customer satisfaction and competitive positioning.

-- STEP 5: DELIVERY PERFORMANCE VS CUSTOMER SATISFACTION
SELECT 
			delivery_status, 
			ROUND(AVG(review_score), 2) AS avg_review_score, 
			COUNT(*) AS total_orders
FROM final_cleaned_dataset
WHERE review_score IS NOT NULL
GROUP BY delivery_status;
-- EXECUTIVE INSIGHTS:
-- Customer satisfaction is strongly correlated with delivery performance.
-- On-time deliveries maintain high customer ratings (4.29 average score).
-- Late deliveries reduce satisfaction significantly, averaging only 2.56 stars.
-- Failed deliveries generate severe customer dissatisfaction (1.76 stars),
-- highlighting logistics reliability as a critical business priority.

-- STEP 6: PAYMENT METHOD PERFORMANCE
SELECT 
			payment_type, 
			COUNT(*) AS total_orders, 
			ROUND(AVG(is_delivered) * 100, 2) AS delivery_rate, 
			ROUND(AVG(payment_value), 2) AS avg_payment_value,
			ROUND(AVG(review_score), 2) AS avg_review
FROM final_cleaned_dataset
GROUP BY payment_type
ORDER BY total_orders DESC;
-- EXECUTIVE INSIGHTS:
-- Credit cards dominate platform transactions and generate the highest customer spending.
-- Debit card customers exhibit the strongest satisfaction scores despite low adoption.
-- Voucher-based purchases show lower order values and weaker operational outcomes.
-- Minor payment-type anomalies were identified and flagged as data quality issues.

-- STEP 7: GEOGRAPHIC PERFORMANCE ANALYSIS
SELECT 
			customer_state, 
			COUNT(*) AS total_orders,
			ROUND(AVG(is_delivered) * 100, 2) AS delivery_rate,
			ROUND(AVG(delivery_days), 2) AS avg_delivery_days, 
			ROUND(AVG(review_score), 2) AS avg_review_score
FROM final_cleaned_dataset
GROUP BY customer_state
ORDER BY delivery_rate DESC;
-- EXECUTIVE INSIGHTS:
-- Sao Paulo represents the marketplace’s operational hub,
-- combining high order volume, fast delivery, and strong customer satisfaction.
-- Remote northern regions experience significantly slower delivery times,
-- indicating geographic logistics challenges.
-- Longer delivery times are associated with weaker customer review scores,
-- reinforcing the importance of delivery speed in customer experience.
-- High-volume states should remain primary operational optimization targets.

-- STEP 8: APPROVAL DELAY IMPACT
SELECT 
			CASE
					WHEN approval_days <= 1 THEN 'Same Day'
					WHEN approval_days <= 3 THEN '1 - 3 Days'
					ELSE '3+ Days'
			END AS approval_speed, 
			COUNT (*) AS total_orders, 
			ROUND(AVG(is_delivered) * 100, 2) AS delivery_rate, 
			ROUND(AVG(review_score), 2) AS avg_review_score
FROM final_cleaned_dataset
GROUP BY approval_speed
ORDER BY delivery_rate DESC;
-- EXECUTIVE INSIGHTS:
-- Faster approval speeds are strongly associated with higher delivery success rates.
-- Orders approved after 3+ days experience significant operational deterioration.
-- Customer satisfaction declines as approval delays increase.
-- Streamlining approval workflows may improve fulfillment efficiency and customer experience.

--STEP 9: REVIEW PARTICIPATION FUNNEL
SELECT 
			COUNT(*) AS delivered_orders,
			COUNT(review_id) AS reviewed_orders, 
			ROUND(COUNT(review_id) * 100.0 / COUNT(*), 2) AS review_submission_rate
FROM final_cleaned_dataset
WHERE is_delivered = 1;
-- EXECUTIVE INSIGHTS:
-- Nearly all delivered orders in the dataset contain associated review records.
-- The unusually high participation rate suggests reviews may be tightly coupled
-- with delivered transactions in the source data.
-- Despite potential dataset bias, review activity provides valuable customer
-- sentiment visibility across the marketplace.

-- STEP 10: HIGH-RISK ORDERS
SELECT 
			order_id, 
			customer_state,
			payment_type,
			delivery_days,
			approval_days,
			review_score,
			delivery_status
FROM final_cleaned_dataset
WHERE delivery_days > 10
		  OR  approval_days > 3
ORDER BY delivery_days DESC
LIMIT 50;
-- EXECUTIVE INSIGHTS:
-- A subset of orders experienced extreme delivery delays exceeding 100 days,
-- indicating severe logistics failures.
-- Approval processing remained relatively efficient, suggesting downstream
-- fulfillment and transportation stages are the primary operational bottlenecks.
-- Orders with extreme delivery delays frequently received poor customer reviews,
-- reinforcing the strong relationship between logistics performance and satisfaction.
-- High-risk operational cases appear across multiple geographic regions,
-- highlighting the need for targeted logistics optimization.

-- STEP 11: REVENUE ANALYSIS BY FUNNEL COMPLETION
SELECT 
			delivery_status,
			ROUND(SUM(payment_value), 2) AS total_revenue, 
			ROUND(AVG(payment_value), 2) AS avg_order_value, 
			COUNT(*) AS orders
FROM final_cleaned_dataset
GROUP BY delivery_status;
-- EXECUTIVE INSIGHTS:
-- On-time deliveries generate the vast majority of marketplace revenue.
-- Failed deliveries represent significant financial and operational risk.
-- High-value orders exhibit higher average failure and delay exposure.
-- Improving logistics reliability may protect premium customer revenue
--   and strengthen customer retention.

-- STEP 12: CORRELATION SIGNAL: DELIVERY TIME VS REVIEWS
SELECT 
			review_score, 
			ROUND(AVG(delivery_days), 2) AS avg_delivery_days, 
			COUNT(*) AS orders
FROM final_cleaned_dataset
WHERE review_score IS NOT NULL
GROUP BY review_score
ORDER BY review_score;
-- EXECUTIVE INSIGHTS:
-- Customer satisfaction improves consistently as delivery times decrease.
-- 1-star reviews are associated with significantly longer delivery times.
-- Customers giving 5-star reviews experience the fastest deliveries on average.
-- Logistics speed appears to be a major driver of customer sentiment and platform reputation.

--- ======================================================================
-- FINAL BUSINESS RECOMMENDATIONS:
-- Prioritize logistics optimization in remote regions.
-- Reduce approval delays exceeding 3 days.
-- Improve monitoring of high-value orders at risk of late delivery.
-- Expand fast-delivery capabilities to improve customer satisfaction.
-- Investigate operational causes of extreme delivery outliers.
--- ======================================================================