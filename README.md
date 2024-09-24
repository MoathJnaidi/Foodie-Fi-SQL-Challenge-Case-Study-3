# Foodie-Fi-SQL-Challenge-Case-Study-3
<p align = "center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/3.png" width="43%" height="43%">
</p>

In this repository, you will find my solutions for the 3rd challenge of [8 Week Challenge](https://8weeksqlchallenge.com/) which is [Foodie-Fi](https://8weeksqlchallenge.com/case-study-3/) Challenge.
## Table of Content
1. [Business Case](#business-case)
2. [Available Data](#available-data)
3. [Questions and Solutions](#questions-and-solutions)

## Business Case
Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

## Available Data
The data available for this study is shown in the diagram below:

<p align = "center">
<img src = "https://8weeksqlchallenge.com/images/case-study-3-erd.png" width = "60%" height = "60%"></img></p>

### `plans` table 
<Details>
    <summary>Table Details</summary>
&nbsp;
  
|plan_id|plan_name    |price |
|-------|-------------|------|
|0      |trial        |0.00  |
|1      |basic monthly|9.90  |
|2      |pro monthly  |19.90 |
|3      |pro annual   |199.00|
|4      |churn        |NULL  |

* Customers can choose which plans to join Foodie-Fi when they first sign up.
* Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90
* Pro plan customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription.
* Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.
* When customers cancel their Foodie-Fi service - they will have a `churn` plan record with a `null` price but their plan will continue until the end of the billing period.
</Details>

### `subscriptions` table
<Details>
    <summary>Table Details</summary>
&nbsp;  

|customer_id|plan_id      |start_date|plan_id|plan_name    |price |
|-----------|-------------|----------|-------|-------------|------|
|1          |0            |2020-08-01|0      |trial        |0.00  |
|1          |1            |2020-08-08|1      |basic monthly|9.90  |
|2          |0            |2020-09-20|0      |trial        |0.00  |
|2          |3            |2020-09-27|3      |pro annual   |199.00|
|11         |0            |2020-11-19|0      |trial        |0.00  |
|11         |4            |2020-11-26|4      |churn        |NULL  |
|13         |0            |2020-12-15|0      |trial        |0.00  |
|13         |1            |2020-12-22|1      |basic monthly|9.90  |
|13         |2            |2021-03-29|2      |pro monthly  |19.90 |
|15         |0            |2020-03-17|0      |trial        |0.00  |
|15         |2            |2020-03-24|2      |pro monthly  |19.90 |
|15         |4            |2020-04-29|4      |churn        |NULL  |
|16         |0            |2020-05-31|0      |trial        |0.00  |
|16         |1            |2020-06-07|1      |basic monthly|9.90  |
|16         |3            |2020-10-21|3      |pro annual   |199.00|
|18         |0            |2020-07-06|0      |trial        |0.00  |
|18         |2            |2020-07-13|2      |pro monthly  |19.90 |
|19         |0            |2020-06-22|0      |trial        |0.00  |
|19         |2            |2020-06-29|2      |pro monthly  |19.90 |
|19         |3            |2020-08-29|3      |pro annual   |199.00|

* Customer subscriptions show the exact date where their specific `plan_id` starts.
* If customers downgrade from a pro plan or cancel their `subscription` - the higher plan will remain in place until the period is over - the `start_date` in the subscriptions table will reflect the date that the actual plan changes.
* When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway.
* When customers churn - they will keep their access until the end of their current billing period but the `start_date` will be technically the day they decided to cancel their service.
</Details>

## Questions and Solutions
### Section A: Customer Journey
Based off the 8 sample customers provided in the sample from the `subscriptions` table, write a brief description about each customer's onboarding journey.

```sql 
SELECT * 
  FROM subscriptions AS s 
  JOIN plans AS p ON s.plan_id = p.plan_id
 WHERE s.customer_id IN (1, 2, 11, 13, 15, 16, 18, 19);
```
|customer_id|plan_id      |start_date|plan_id|plan_name    |price |
|-----------|-------------|----------|-------|-------------|------|
|1          |0            |2020-08-01|0      |trial        |0.00  |
|1          |1            |2020-08-08|1      |basic monthly|9.90  |
|2          |0            |2020-09-20|0      |trial        |0.00  |
|2          |3            |2020-09-27|3      |pro annual   |199.00|
|11         |0            |2020-11-19|0      |trial        |0.00  |
|11         |4            |2020-11-26|4      |churn        |NULL  |
|13         |0            |2020-12-15|0      |trial        |0.00  |
|13         |1            |2020-12-22|1      |basic monthly|9.90  |
|13         |2            |2021-03-29|2      |pro monthly  |19.90 |
|15         |0            |2020-03-17|0      |trial        |0.00  |
|15         |2            |2020-03-24|2      |pro monthly  |19.90 |
|15         |4            |2020-04-29|4      |churn        |NULL  |
|16         |0            |2020-05-31|0      |trial        |0.00  |
|16         |1            |2020-06-07|1      |basic monthly|9.90  |
|16         |3            |2020-10-21|3      |pro annual   |199.00|
|18         |0            |2020-07-06|0      |trial        |0.00  |
|18         |2            |2020-07-13|2      |pro monthly  |19.90 |
|19         |0            |2020-06-22|0      |trial        |0.00  |
|19         |2            |2020-06-29|2      |pro monthly  |19.90 |
|19         |3            |2020-08-29|3      |pro annual   |199.00|

* **Customer 1**: Signed up on the 1st of August 2020 and started a free trial for 7 days. Since did not cancel, upgrade or downgrade the subscriptions 
he/she continued with basic monthly plan for $9.90/month
* **Customer 2**: Signed up on 2020-09-20 and before the ending of free trial plan he/she upgraded to annual pro plan for $199/year
* **Customer 11**: Signed up on 2020-11-19, and cancelled the subscription after the free trial ended.
* **Customer 13**: Signed up on 2020-12-15 and continued automatically with the basic monthly plan after the free trial ended. Then upgraded to pro monthly after 3 months
* **Customer 15**: Signed up on 2020-03-17 and upgraded to the pro monthly plan, then cancelled after 1 month.
* **Customer 16**: Signed up on 2020-05-31 and continued automatically with the basic monthly plan after the free trial ended. Then upgraded to the pro annual plan after using the basic monthly plan for approximately 5 months
* **Customer 18**: Signed up on 2020-07-06. Upgraded to the pro monthly plan after the free trial ended
* **Customer 19**: Signed up on 2020-06-22 with a free trial, then switched to pro monthly plan, then switched to pro annual plan
        
### Section B: Data Analysis Questions
#### 1. How many customers has Foodie-Fi ever had?

```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers
  FROM subscriptions;
```
|total_customers|
|---------------|
|1000           |

#### 2.What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value?

```sql
SELECT MONTH (s.start_date) AS 'month',
       COUNT(s.plan_id) AS total_free_trial
  FROM subscriptions AS s
  JOIN plans AS p ON s.plan_id = p.plan_id
 WHERE p.plan_name = 'trial'
 GROUP BY MONTH;    
```
|month|total_free_trial|
|-----|----------------|
|3    |94              |
|10   |79              |
|7    |89              |
|11   |75              |
|6    |79              |
|9    |87              |
|5    |88              |
|1    |88              |
|8    |88              |
|12   |84              |
|2    |68              |
|4    |81              |

#### 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name?
```sql
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
```
|plan_name    |2020_and_before|after_2020|
|-------------|---------------|----------|
|basic monthly|538            |8         |
|pro monthly  |479            |60        |
|pro annual   |195            |63        |
|churn        |236            |71        |


#### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
```sql
   SELECT COUNT(s.customer_id) AS customer_count,
          ROUND(COUNT(s.customer_id) * 100 / 
          (SELECT COUNT(DISTINCT customer_id) FROM subscriptions),1) AS perc
     FROM subscriptions AS s
     JOIN plans p ON s.plan_id = p.plan_id
    WHERE plan_name = 'churn';
```
|customer_count|perc|
|--------------|----|
|307           |30.7|

#### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
```sql
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
```
|total_customers|perc|
|---------------|----|
|92             |9   |

#### 6. What is the number and percentage of customer plans after their initial free trial?
```sql
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
```
|next_plan    |total_customers|perc|
|-------------|---------------|----|
|basic monthly|546            |54.6|
|pro monthly  |325            |32.5|
|churn        |92             |9.2 |
|pro annual   |37             |3.7 |

			
#### 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
```sql
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
```
|plan_name    |total_customers|perc|
|-------------|---------------|----|
|trial        |19             |1.9 |
|pro annual   |195            |19.5|
|basic monthly|224            |22.4|
|churn        |235            |23.5|
|pro monthly  |327            |32.7|

    
#### 8. How many customers have upgraded to an annual plan in 2020?
```sql
   SELECT COUNT(DISTINCT s.customer_id) AS total_customers
     FROM subscriptions s
     JOIN plans p ON s.plan_id = p.plan_id
    WHERE p.plan_name = 'pro annual'
      AND YEAR(start_date) = 2020;
```

|total_customers|
|---------------|
|195            |
#### 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
```sql
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
```
|avg_annual_upgrade_period|
|-------------------------|
|104.6                    |

#### 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
```sql
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
 ORDER BY upgrade_period + 0; -- converting the first column to integer so we can sort the output.
```
|upgrade_period|total_customers|avg_upgrade_duration|
|--------------|---------------|--------------------|
|0-30 days     |48             |10                  |
|30-60 days    |25             |42                  |
|60-90 days    |33             |71                  |
|90-120 days   |35             |100                 |
|120-150 days  |43             |133                 |
|150-180 days  |35             |162                 |
|180-210 days  |27             |190                 |
|210-240 days  |4              |224                 |
|240-270 days  |5              |257                 |
|270-300 days  |1              |285                 |
|300-330 days  |1              |327                 |
|330-360 days  |1              |346                 |

#### 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
```sql
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
```
|total_customers|
|---------------|
|0              |

No customers downgraded from a pro monthly to a basic monthly plan in 2020
    
### Section C: Challenge Payment Question
* The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:
* monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
* upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
* once a customer churns they will no longer make payments
```sql
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

```

|customer_id|plan_id|plan_name    |payment_date|amount|payment_order|
|-----------|-------|-------------|------------|------|-------------|
|1          |1      |basic monthly|2020-08-08  |9.90  |1            |
|1          |1      |basic monthly|2020-09-08  |9.90  |2            |
|1          |1      |basic monthly|2020-10-08  |9.90  |3            |
|1          |1      |basic monthly|2020-11-08  |9.90  |4            |
|1          |1      |basic monthly|2020-12-08  |9.90  |5            |
|2          |3      |pro annual   |2020-09-27  |199.00|1            |
|...
|18         |2      |pro monthly  |2020-07-13  |19.90 |1            |
|18         |2      |pro monthly  |2020-08-13  |19.90 |2            |
|18         |2      |pro monthly  |2020-09-13  |19.90 |3            |
|18         |2      |pro monthly  |2020-10-13  |19.90 |4            |
|18         |2      |pro monthly  |2020-11-13  |19.90 |5            |
|18         |2      |pro monthly  |2020-12-13  |19.90 |6            |
|19         |2      |pro monthly  |2020-06-29  |19.90 |1            |
|19         |3      |pro annual   |2020-08-29  |199.00|2            |

* Please let me know your recommendations about anything I can improve, or if there are any mistakes in my solutions.
  











