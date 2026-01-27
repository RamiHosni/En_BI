--Question 1 How far back does your data go, and how recent is it ?
select
    min(l.lead_created_date) as earliest_lead_created_date, -- minimum date from the leads (first created)
    max(sf.case_closed_successful_date) as latest_case_closed_successful_date --the last day of a deals closure
from leads l join sales_funnel sf on l.lead_id = sf.lead_id


-- Question 2 What is the best-performing marketing channel 
with pv_sales as(
select lead_id,
case_closed_successful_date as pv_sold_date
from sales_funnel
where sales_funnel_steps = 'PV System Sold'
) -- first CTE selecting lead_id closed date (filtering on PV System Sold) 
select
	l.marketing_channel,
	count(distinct l.lead_id) as total_leads, -- total form leads table 
	count(distinct pv.lead_id) as pv_sold_leads,
	count(distinct pv.lead_id)::float / count (distinct l.lead_id) as conversion_rate,-- pv leads / total leads
	avg(pv.pv_sold_date::date - l.lead_created_date::date) as average_days_to_conversion -- from the lead is created to finalized
from
	leads l
left join pv_sales pv on --all leads
	l.lead_id = pv.lead_id
group by
	l.marketing_channel
order by
	conversion_rate desc
	
	
-- Question 3 bottom 3 days (lead_created_date) by marketing channel using: Lead → Sales Call 1 conversion rate.  
Sales Call 1 conversion rate.
with sc1 as(
select distinct lead_id
from sales_funnel
where sales_funnel_steps = 'Sales Call 1'
) --distinct lead_id filtering on 'Sales Call 1'
daily_perf as (
select
	l.marketing_channel, 
	l.lead_created_date,
	count(distinct l.lead_id) as total_leads,
	count(distinct sc1.lead_id) as sc1_leads,
	count(distinct sc1.lead_id)::float / count(distinct l.lead_id) as sc1_conversion,
	row_number() over (partition by marketing_channel
order by
	sc1_conversion desc, -- first row_number to get the top 3 
	total_leads desc) as rn_top, --adding total leads because I have more than 1(100%) in conversion so the most value would be the most number of leads
	row_number() over (partition by marketing_channel
order by
	sc1_conversion asc, --gets the lowest
	total_leads asc) as rn_bottom
from
	leads l
left join sc1 on
	l.lead_id = sc1.lead_id
group by
	l.marketing_channel,
	l.lead_created_date
)
select * from daily_perf
where rn_top <= 3 or rn_bottom <= 3
	
	
--Question 4 my data set
with base as (
select
	l.lead_id,
	date_trunc('month', l.lead_created_date)::date as lead_cohort_month, -- month for cohort analysis
	l.marketing_channel,
	sf.sales_funnel_steps,
	sf.case_closed_successful_date,
	(sf.case_closed_successful_date::date - l.lead_created_date::date) AS days_to_step
from
	leads l
left join sales_funnel sf on
	l.lead_id = sf.lead_id
)
select
	lead_cohort_month,
	marketing_channel,
	sales_funnel_steps,
	count(distinct lead_id) AS leads_in_cohort,
	count(distinct case when case_closed_successful_date is not null then lead_id end) as converted_leads,
	avg(days_to_step) as avg_days_to_step,
from
	base
group by
	lead_cohort_month,
	marketing_channel,
	sales_funnel_steps
order by
	lead_cohort_month,
	marketing_channel,
	sales_funnel_steps


	
	

