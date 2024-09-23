-- Section A --
-- Based off the 8 sample customers provided in the sample from the `subscriptions` table, write a brief description about each customer's onboarding journey.

SELECT * 
  FROM subscriptions AS s 
  JOIN plans AS p ON s.plan_id = p.plan_id
 WHERE s.customer_id IN (1, 2, 11, 13, 15, 16, 18, 19);

-- Section B --
-- 1. How many customers has Foodie-Fi ever had?

SELECT COUNT(DISTINCT customer_id) AS total_customers
  FROM subscriptions;

 -- 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value? 

 SELECT MONTH (s.start_date) AS 'month',
       COUNT(s.plan_id) AS total_free_trial
  FROM subscriptions AS s
  JOIN plans AS p ON s.plan_id = p.plan_id
 WHERE p.plan_name = 'trial'
 GROUP BY MONTH; 

-- 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name?

WITH 2020_and_before AS (
             SELECT plan_id,
                    COUNT(customer_id) AS total_events
               FROM subscriptions
              WHERE YEAR(start_date) <= 2020
           GROUP BY plan_id
          ),
          after_2020 AS (
             SELECT plan_id,
                    COUNT(customer_id) AS total_events
               FROM subscriptions
              WHERE YEAR(start_date) > 2020
           GROUP BY plan_id
          )
   SELECT p.plan_name,
          t1.total_events AS 2020_and_before,
          t2.total_events AS after_2020
     FROM 2020_and_before t1
     JOIN after_2020 t2 ON t1.plan_id = t2.plan_id
     JOIN plans p ON p.plan_id = t1.plan_id;

-- 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

SELECT COUNT(s.customer_id) AS customer_count,
          ROUND(COUNT(s.customer_id) * 100 / 
          (SELECT COUNT(DISTINCT customer_id) FROM subscriptions),1) AS perc
     FROM subscriptions AS s
     JOIN plans p ON s.plan_id = p.plan_id
    WHERE plan_name = 'churn';

-- 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

WITH next_plan AS (
             SELECT s.customer_id,
                    s.plan_id,
                    p.plan_name,
                    LEAD(p.plan_name) OVER (PARTITION BY s.customer_id ORDER BY s.start_date) AS next_plan
               FROM subscriptions AS s
               JOIN plans AS p ON s.plan_id = p.plan_id
          )
   SELECT COUNT(DISTINCT customer_id) AS total_customers,
          ROUND(COUNT(DISTINCT customer_id) * 100 / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions),0)
          AS perc
     FROM next_plan
    WHERE plan_name = 'trial'
      AND next_plan = 'churn';

-- 6. What is the number and percentage of customer plans after their initial free trial?

WITH next_plan AS (
             SELECT s.customer_id,
                    s.plan_id,
                    p.plan_name,
                    LEAD(p.plan_name) OVER (PARTITION BY s.customer_id ORDER BY s.start_date) AS next_plan
               FROM subscriptions AS s
               JOIN plans AS p ON s.plan_id = p.plan_id
          )
   SELECT next_plan,
          COUNT(customer_id) AS total_customers,
          ROUND(COUNT(customer_id) * 100 / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1) AS perc
     FROM next_plan
    WHERE plan_name = 'trial'
    GROUP BY next_plan
    ORDER BY perc DESC;

-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

WITH cte AS (
             SELECT customer_id,
                    plan_id,
                    start_date,
                    LEAD(plan_id) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_plan,
                    LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_start_date
               FROM subscriptions
          )
   SELECT p.plan_name,
          COUNT(cte.customer_id) AS total_customers,
          ROUND(COUNT(cte.customer_id) * 100 / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1) AS perc
     FROM cte
     JOIN plans AS p ON cte.plan_id = p.plan_id
    WHERE '2020-12-31' BETWEEN cte.start_date AND cte.next_start_date
       OR (
          cte.next_start_date IS NULL
      AND cte.start_date < '2020-12-31'
          )
 GROUP BY p.plan_name
 ORDER BY total_customers;

-- 8. How many customers have upgraded to an annual plan in 2020?

   SELECT COUNT(DISTINCT s.customer_id) AS total_customers
     FROM subscriptions s
     JOIN plans p ON s.plan_id = p.plan_id
    WHERE p.plan_name = 'pro annual'
      AND YEAR(start_date) = 2020;

-- 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

WITH trial_customers AS (
             SELECT s.customer_id,
                    s.start_date
               FROM subscriptions AS s
               JOIN plans AS p ON s.plan_id = p.plan_id
              WHERE p.plan_name = 'trial'
          ),
          annual_customers AS (
             SELECT s.customer_id,
                    s.start_date
               FROM subscriptions s
               JOIN plans AS p ON s.plan_id = p.plan_id
              WHERE p.plan_name = 'pro annual'
          )
   SELECT ROUND(AVG(DATEDIFF(a.start_date, t.start_date)), 1) AS avg_annual_upgrade_period
     FROM trial_customers AS t
     JOIN annual_customers AS ON t.customer_id = a.customer_id
    WHERE a.start_date IS NOT NULL;

-- 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

WITH trial_customers AS (
             SELECT s.customer_id,
                    s.start_date
               FROM subscriptions s
               JOIN plans p ON s.plan_id = p.plan_id
              WHERE p.plan_name = 'trial'
          ),
          annual_customers AS (
             SELECT s.customer_id,
                    s.start_date
               FROM subscriptions AS s
               JOIN plans AS p ON s.plan_id = p.plan_id
              WHERE p.plan_name = 'pro annual'
          )
   SELECT CONCAT(
          FLOOR(DATEDIFF(a.start_date, t.start_date) / 30) * 30, "-", 
          FLOOR(DATEDIFF(a.start_date, t.start_date) / 30) * 30 + 30,
          ' days'
          ) AS upgrade_period,
          COUNT(DISTINCT t.customer_id) AS total_customers,
          ROUND(AVG(DATEDIFF(a.start_date, t.start_date)), 0) AS avg_upgrade_duration
     FROM trial_customers AS t
     JOIN annual_customers AS a ON t.customer_id = a.customer_id
    WHERE a.start_date IS NOT NULL
 GROUP BY 1
 ORDER BY upgrade_period + 0;

-- 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

WITH next_plan AS (
             SELECT s.customer_id,
                    p.plan_name,
                    s.start_date,
                    LEAD(p.plan_name) OVER (PARTITION BY customer_id ORDER BY s.start_date) AS next_plan,
                    LEAD(s.start_date) OVER (PARTITION BY customer_id ORDER BY s.start_date) AS next_plan_start_date
               FROM subscriptions AS s
               JOIN plans AS p ON s.plan_id = p.plan_id
          )
   SELECT COUNT(DISTINCT customer_id) AS total_customers
     FROM next_plan
    WHERE next_plan = 'basic monthly'
      AND plan_name = 'pro monthly'
      AND YEAR(next_plan_start_date) = 2020;

-- Section C -- 

WITH RECURSIVE payment_dates AS (
             SELECT s.customer_id,
                    p.plan_id,
                    p.plan_name,
                    s.start_date AS payment_date,
                    CASE
                        WHEN LEAD(s.start_date) OVER (PARTITION BY customer_id ORDER BY s.start_date) IS NULL THEN '2020-12-31'
                        ELSE DATE_ADD(s.start_date, INTERVAL DATEDIFF(s.start_date, LEAD(s.start_date) OVER (PARTITION BY customer_id ORDER BY s.start_date)) MONTH)
                        END AS last_date,
                    p.price AS amount
               FROM subscriptions AS s
               JOIN plans AS p ON s.plan_id = p.plan_id
              WHERE p.plan_name != 'trial'
                AND YEAR(s.start_date) = 2020
              UNION
             SELECT customer_id,
                    plan_id,
                    plan_name,
                    DATE_ADD(payment_date, INTERVAL 1 MONTH) AS payment_date,
                    last_date,
                    amount
               FROM payment_dates
              WHERE DATE_ADD(payment_date, INTERVAL 1 MONTH) <= last_date
                AND plan_name != 'pro annual'
          )
   SELECT customer_id,
          plan_id,
          plan_name,
          payment_date,
          amount,
          ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date) AS payment_order
     FROM payment_dates
    WHERE amount IS NOT NULL
 ORDER BY customer_id;