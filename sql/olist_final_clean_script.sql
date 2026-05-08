--- ================================================
--- OLIST E-COMMERCE DATA CLEANING 
--- DATA ANALYST: NOTHABO MICHELLE MOYO
--- DATE: 30/04/2026
--- DATA SOURCE: KAGGLE (olist e-commerce.csv)
--- ================================================

-- STEP 1: BASE TABLE CREATION 
DROP TABLE IF EXISTS clean_orders;

CREATE TABLE clean_orders AS 
SELECT DISTINCT *
FROM olist_orders;

-- STEP 2: DATA INTEGRITY CHECK 
-- Duplicate Check 
-- No duplicates detected
SELECT order_id, COUNT (*) AS cnt
FROM clean_orders
GROUP BY order_id
HAVING cnt > 1;

-- Null Check 
-- Null values in downstream timestamps represent natural funnel attrition 
SELECT 
			COUNT(*) AS total_orders, 
			COUNT(order_purchase_timestamp) AS purchase_ts,
			COUNT(order_approved_at) AS approved_ts,
			COUNT(order_delivered_customer_date) AS delivered_ts
FROM clean_orders;

-- STEP 3: REMOVING LOGICALLY INVALID RECORDS
-- Delivered before purchase (invalid)
DELETE FROM clean_orders
WHERE order_delivered_customer_date IS NOT NULL
AND order_delivered_customer_date < order_purchase_timestamp;

-- Approved before purchase  (invalid)
DELETE FROM clean_orders
WHERE order_approved_at IS NOT NULL
AND order_approved_at < order_purchase_timestamp;

-- STEP 4: STANDARDIZED ORDER STATUS
UPDATE clean_orders
SET order_status = LOWER(TRIM(order_status));

-- STEP 5: CREATION OF FUNNEL FLAGS 
ALTER TABLE clean_orders ADD COLUMN is_created INTEGER;
ALTER TABLE clean_orders ADD COLUMN is_approved INTEGER;
ALTER TABLE clean_orders ADD COLUMN is_shipped INTEGER;
ALTER TABLE clean_orders ADD COLUMN is_delivered INTEGER;

UPDATE clean_orders
SET 
		is_created = CASE WHEN order_purchase_timestamp IS NOT NULL THEN 1 ELSE 0 END, 
		is_approved = CASE WHEN order_approved_at IS NOT NULL THEN 1 ELSE 0 END, 
		is_shipped = CASE WHEN order_delivered_carrier_date IS NOT NULL THEN 1 ELSE 0 END, 
		is_delivered = CASE WHEN order_delivered_customer_date IS NOT NULL THEN 1 ELSE 0 END;
		
-- STEP 6: TIME-BASED FEATURE ENGINEERING 
ALTER TABLE clean_orders ADD COLUMN approval_days REAL;
ALTER TABLE clean_orders ADD COLUMN shipping_days REAL;
ALTER TABLE clean_orders ADD COLUMN delivery_days REAL;
ALTER TABLE clean_orders ADD COLUMN total_fulfillment_days REAL;

UPDATE clean_orders
SET
		approval_days = julianday(order_approved_at) - julianday(order_purchase_timestamp),
		shipping_days = julianday(order_delivered_carrier_date) - julianday(order_approved_at),
		delivery_days = julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp),
		total_fulfillment_days = julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp);
		
-- STEP 7: NEGATIVE OR UNREALISTIC DURATIONS 
UPDATE clean_orders
SET 
			approval_days = NULL
WHERE approval_days < 0;

UPDATE clean_orders
SET
			shipping_days = NULL
WHERE shipping_days < 0;

UPDATE clean_orders
SET 
			delivery_days = NULL
WHERE delivery_days < 0;

-- STEP 8: DELIVERY PERFORMANCE CLASSIFICATION 
ALTER TABLE clean_orders ADD COLUMN delivery_status TEXT;

UPDATE clean_orders
SET delivery_status = 
			CASE 
					WHEN order_delivered_customer_date IS NULL THEN 'Not Delivered'
					WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Late'
					ELSE 'On Time'
			END;

-- STEP 9: JOINING REVIEWS 
DROP TABLE IF EXISTS clean_orders_with_reviews;

CREATE TABLE clean_orders_with_reviews AS 
SELECT 
			o. *, 
			r. review_id,
			r. review_score
FROM clean_orders o
LEFT JOIN olist_order_reviews r
ON o. order_id = r.order_id;

--  STEP 10: CLEAN REVIEW SCORES 
UPDATE clean_orders_with_reviews
SET review_score = NULL
WHERE review_score NOT BETWEEN 1 AND 5;

--- STEP 11: ADDING PAYMENT INFORMATION
DROP TABLE IF EXISTS clean_orders_full;

CREATE TABLE clean_orders_full AS 
SELECT 
		o. *,
		p. payment_type,
		p. payment_value
FROM clean_orders_with_reviews o
LEFT JOIN olist_order_payments p
ON o. order_id = p. order_id;

-- STEP 12: ADDING CUSTOMER LOCATION
DROP TABLE IF EXISTS final_cleaned_dataset;

CREATE TABLE final_cleaned_dataset AS 
SELECT
			o. *,
			c. customer_state
FROM clean_orders_full o
LEFT JOIN olist_customers c
ON o. customer_id = c. customer_id;

-- STEP 13: FINAL VALIDATION CHECKS 
-- Checking funnel consistency
SELECT 
		COUNT(*) AS total_orders, 
		SUM(is_created) AS created, 
		SUM(is_approved) AS approved, 
		SUM(is_shipped) AS shipped, 
		SUM(is_delivered) AS delivered
FROM final_cleaned_dataset;

-- Checking delivery distribution
SELECT delivery_status, COUNT(*) AS orders
FROM final_cleaned_dataset
GROUP BY delivery_status;

-- Checking null critical fields
SELECT 
			COUNT(*) AS 'total', 
			COUNT(delivery_days) AS valid_delivery_days,
			COUNT(review_score) AS valid_reviews
FROM final_cleaned_dataset;




