create database customer_behavior;
use customer_behavior;

-- what is the total revenue generatesd by male vs female?
select gender, sum(purchase_amount) as Total_Rvenue
from customer
group by gender; 

-- which customers used a discount but still spent more than the average purchase amount? 
select customer_id, purchase_amount
from customer
where discount_applied = "Yes" and
purchase_amount > (select avg(purchase_amount) from customer);

-- which are the top 5 products with the highest average review rating?
select item_purchased, round(avg(review_rating),2) as Highest_Review_Rating
from customer
group by item_purchased
order by Highest_Review_Rating desc
limit 5; 

-- compare the average purchase amount between Standard and Express Shipping?
select shipping_type, round(avg(purchase_amount),2) as Average_Purchase_Amount
from customer 
where shipping_type in ('Standard','Express')
group by shipping_type;

-- Do subscribed customers spend more? Compare average spend and total revenue between subscribers and non-subscribers?
select subscription_status, 
count(customer_id) as Total_Customers, 
sum(purchase_amount) as Total_Revenue, 
round(avg(purchase_amount),2) as Average_Spend
from customer
group by subscription_status
order by Total_Revenue,Average_Spend desc;

-- which 5 products have the highest percentage of purchase with discount applied?
select item_purchased, round( count(case when discount_applied = 'Yes' then 1 end )*100/count(*),2) as purchase_percentage
from customer
group by item_purchased
order by purchase_percentage desc
limit 5;

-- segment customer into New, Returning and Loyal based on their total number of previous purchases, and show the count of each purchase?  
with customer_type as(
select 
case
 when previous_purchases = 1 then 'New'
 when previous_purchases between 2 and 10 then 'Returning'
 else 'Loyal'
 end as customer_segment
from customer
)

select customer_segment, count(*) as Number_of_customers
from customer_type
group by customer_segment;

-- what are the top 3 most purchased products within each category?
with item_counts as(
select category, 
item_purchased,
count(*) as total_orders,
row_number() over(partition by category order by count(*)  desc) as item_rank
from customer 
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <=3;

-- Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
select subscription_status, 
count(customer_id) as repeat_buyers 
from customer
where previous_purchases > 5
group by subscription_status;
 
-- what is the revenue contribution of each age group?
select age_group, sum(purchase_amount) revenue
from customer
group by age_group
order by revenue desc;
