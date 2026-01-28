# Question 1

How far back does the data go, and how recent is it?

<img width="976" height="58" alt="image" src="https://github.com/user-attachments/assets/62730370-5531-4c07-9320-303a26c8fb2c" />



Results: 


<img width="590" height="80" alt="image" src="https://github.com/user-attachments/assets/c5121e87-0007-4f7e-a8ec-f16cb5d6f94d" />

Earliest lead_created_date (16/1/2024)

Latest case_closed_successful_date (28/10/2024)


# Question 2

What is the best-performing marketing channel?

Lead → PV System Sold conversion rate

The best performing channel is the one with the highest proportion of leads that eventually reach “PV System Sold”.

Conversion rate is calculated as:
distinct Leads which already in “PV System Sold”/ Total distinct Leads
	​

Time to conversion (Average Days)

Time to conversion is measured as the number of days between: lead_created_date and case_closed_successful_date for PV System Sold

Aggregated by marketing channel.

Key observations
<img width="1044" height="126" alt="image" src="https://github.com/user-attachments/assets/90687777-ad41-474b-9ed4-c9eecb925afe" />

Channel A has the highest conversion rate.
Channel C has the highst number of leads but lowest conversion rate. 



# Question 3

Top & bottom 3 days by marketing channel using Lead → Sales Call 1 conversion rate

Approach
Grouped leads by: marketing_channel and lead_created_date

### Calculated:
Total leads per day
Leads that reached Sales Call 1
Conversion rate per day

### Ranking logic
Days are ranked within each marketing channel using:


ROW_NUMBER() ordered by  sc1_conversion DESC and  total_leads Desc (Top) 


ROW_NUMBER() ordered by sc1_conversion asc and  total_leads asc (Bottom)

Important clarification

Many days show a 100% conversion rate (1.0).
<img width="1306" height="162" alt="image" src="https://github.com/user-attachments/assets/ce0a5691-c3f5-4bc8-8b0d-3a359111a26a" />

so total_leads was added in the order by to get the 100% with most leads as top3 

Result: 

<img width="1336" height="298" alt="image" src="https://github.com/user-attachments/assets/f207c72b-4579-441e-b2cf-3b75334865c9" />





# Question 4

Cohort analysis dataset by marketing channel

Cohorts are defined by lead creation month (lead_cohort_month).

Each lead belongs to exactly one cohort.

 ### Dataset structure

#### The dataset enables analysis by:

Lead cohort month

Marketing channel

Sales funnel step

Leads reaching each step

Time to reach each step
<img width="1303" height="320" alt="image" src="https://github.com/user-attachments/assets/ae499fbb-2ef8-4b22-bccf-65b970d00435" />



Power BI dashboard was created with measures and filters to answer business questions:
<img width="1290" height="718" alt="image" src="https://github.com/user-attachments/assets/599018cd-6f35-4127-b2f5-9d65c9b0ef24" />
