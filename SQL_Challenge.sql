--Question 1 How far back does your data go, and how recent is it ?
SELECT
    MIN(l.lead_created_date) AS earliest_lead_created_date, -- minimum date from the leads (first created)
    MAX(sf.case_closed_successful_date) AS latest_case_closed_successful_date --the last day of a deals closure
FROM leads l join sales_funnel sf on l.lead_id = sf.lead_id



-- Question 2 What is the best-performing marketing channel 
WITH pv_sales AS (
  SELECT
    lead_id,
    case_closed_successful_date AS pv_sold_date
  FROM sales_funnel
  WHERE sales_funnel_steps = 'PV System Sold'
) -- first CTE selecting lead_id closed date (filtering on PV System Sold) 
SELECT
  l.marketing_channel,
  COUNT(DISTINCT l.lead_id) AS total_leads,
  COUNT(DISTINCT pv.lead_id) AS pv_sold_leads,
  COUNT(DISTINCT pv.lead_id)::float / COUNT(DISTINCT l.lead_id) AS conversion_rate, -- pv leads / total leads
  AVG(pv.pv_sold_date::date - l.lead_created_date::date) AS avg_days_to_conversion -- from the lead is created to finalized
FROM leads l
LEFT JOIN pv_sales pv -- all leads
  ON l.lead_id = pv.lead_id
GROUP BY l.marketing_channel
ORDER BY conversion_rate DESC



-- Question 3 bottom 3 days (lead_created_date) by marketing channel
WITH sc1 AS (
  SELECT DISTINCT lead_id
  FROM sales_funnel
  WHERE sales_funnel_steps = 'Sales Call 1'
), --distinct lead_id filtering on 'Sales Call 1'
daily_perf AS (
  SELECT
    l.marketing_channel,
    l.lead_created_date,
    COUNT(DISTINCT l.lead_id) AS total_leads,
    COUNT(DISTINCT sc1.lead_id) AS sc1_leads,
    COUNT(DISTINCT sc1.lead_id)::float / COUNT(DISTINCT l.lead_id) AS sc1_conversion,
    -- first row_number to get the top 3
    --adding total leads because I have more than 1(100%) in conversion so the most value would be the most number of leads
    ROW_NUMBER() OVER (PARTITION BY marketing_channel ORDER BY sc1_conversion DESC, total_leads DESC) AS rn_top, 
    ROW_NUMBER() OVER (PARTITION BY marketing_channel ORDER BY sc1_conversion ASC, total_leads ASC)  AS rn_bottom
  FROM leads l
  LEFT JOIN sc1 ON l.lead_id = sc1.lead_id
  GROUP BY l.marketing_channel, l.lead_created_date
)
SELECT * from daily_perf
WHERE rn_top <= 3 OR rn_bottom <= 3




--Question 4 my data set 
WITH base AS (
  SELECT
    l.lead_id,
    DATE_TRUNC('month', l.lead_created_date)::date AS lead_cohort_month, -- month for cohort analysis
    l.marketing_channel,
    sf.sales_funnel_steps,
    sf.case_closed_successful_date,
    (sf.case_closed_successful_date::date - l.lead_created_date::date) AS days_to_step
  FROM leads l
  LEFT JOIN sales_funnel sf
    ON l.lead_id = sf.lead_id
)
SELECT
  lead_cohort_month,
  marketing_channel,
  sales_funnel_steps,
  COUNT(DISTINCT lead_id) AS leads_in_cohort,
  COUNT(DISTINCT CASE
    WHEN case_closed_successful_date IS NOT NULL THEN lead_id
  END) AS converted_leads,
  AVG(days_to_step) AS avg_days_to_step,
FROM base
GROUP BY
  lead_cohort_month,
  marketing_channel,
  sales_funnel_steps
ORDER BY
  lead_cohort_month,
  marketing_channel,
  sales_funnel_steps



