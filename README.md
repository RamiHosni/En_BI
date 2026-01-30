
# Enpal BI / Data Analyst Take-Home Assignment

## Question 1: Data coverage

**Question:** How far back does the data go, and how recent is it?

**Results:**

| Metric                                | Date         |
|--------------------------------------|-------------|
| Earliest `lead_created_date`          | 16/01/2024  |
| Latest `case_closed_successful_date`  | 28/10/2024  |

---

## Question 2: Best-performing marketing channel

**Question:** Which marketing channel performs best in terms of:

1. Lead → PV System Sold conversion rate  
2. Time to conversion

### Conversion Rate
- **Definition:** Proportion of leads that eventually reach “PV System Sold”  
- **Formula:**  
```

Conversion Rate = count(distinct pv.lead_id)::float / count (distinct l.lead_id)

```

**Observation:**  
- Channel A has the highest conversion rate.  
- Channel C has the highest number of leads but the lowest conversion rate.  

### Time to Conversion
- **Definition:** Average number of days from `lead_created_date` to `case_closed_successful_date` for leads that reached PV System Sold  
- Aggregated by marketing channel

---

## Question 3: Top & bottom 3 days by marketing channel (Lead → Sales Call 1 conversion rate)

**Approach:**  
- Grouped leads by `marketing_channel` and `lead_created_date`  
- Calculated:  
- Total leads per day  
- Leads that reached Sales Call 1  
- Conversion rate per day  

**Ranking Logic:**  
- Top 3 days per channel:  
```

ROW_NUMBER() OVER (PARTITION BY marketing_channel ORDER BY sc1_conversion DESC, total_leads DESC) 

```
- Bottom 3 days per channel:  
```

ROW_NUMBER() OVER (PARTITION BY marketing_channel ORDER BY sc1_conversion ASC, total_leads ASC)

```

**Clarifications:**  
- Some days have 100% conversion rate (1.0) (more than 3 days).  
- Added `total_leads` in the ordering to ensure days with most leads appear in top 3.

---

## Question 4: Cohort analysis dataset by marketing channel

**Cohort Definition:**  
- Each lead is assigned to a cohort based on the **lead creation month (`lead_cohort_month`)**  
- Each lead belongs to exactly one cohort

### Dataset Structure
The dataset enables analysis of:

| Column / Metric        | Description |
|------------------------|-------------|
| `lead_cohort_month`    | Month when the lead was created |
| `marketing_channel`    | Marketing channel that sourced the lead |
| `sales_funnel_steps`   | Funnel step (Sales Call 1 → Sales Call 2 → PV System Sold) |
| `leads_in_chohort`     | Number of leads in each step |
| `converted_leads`      | Number of leads in each step which was done(have a closed date) |
| `avg_days_to_step`     | Average Time (in days) to reach each step |


**Notes:**  
- Power BI dashboard was used to explore trends in time-to-conversion and cohort development for the live session (Part 2).  
- The dataset is designed to answer business questions such as:  
- How is each cohort developing over time?  
- What is the preformance of each marketing channel?  
- Which channels convert fastest?
- how many totally inactive leads?
- and more

---

**Assumptions / General Notes:**  
- Leads without a successful PV System Sold case are treated as right-censored (still in progress).  
- Conversion rate is calculated based on distinct leads per channel.  
- Time-to-conversion uses the difference in days between `lead_created_date` and `case_closed_successful_date`.
- The dataset answers quetions 4 in addition to other observations.


