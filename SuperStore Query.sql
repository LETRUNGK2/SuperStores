--I. Data set exploration 
--profit by category
select category,sub_category,round(sum(profit),1) as total_profit
from superstore 
group by category,sub_category
order by sum(profit) desc

--profit by product name
select  product_name,sum(quantity) as total_quantity,ceiling(sum(profit)) as total_profit
from superstore
group by Product_Name
order by sum(profit) desc

--Profit by region
select superstore.state,region,ceiling(sum(profit)) as total_profit
from superstore
group by state,region
order by total_profit desc

--monthly profit

select datepart(year,ship_Date) as Year,datepart(month,ship_Date) as Month,
floor(sum(profit)) as monthly_profit
from superstore
group by datepart(year,ship_Date),datepart(month,ship_Date)
order by 1,2

--top 15 profitable customers and their segnment 

select top 15 customer_name,segment, ceiling(sum(profit)) as total_profit
from superstore 
group by customer_name,Segment
order by total_profit desc

--return product 
select s.Product_Name,ceiling(sum(s.profit)) as Return_value 
from superstore s
left join Returns r on s.Order_ID = r.order_id
group by s.Product_Name 
order by Return_value desc

select s.state,s.city,ceiling(sum(s.profit)) as Return_value
from superstore s
left join Returns r on s.Order_ID = r.order_id
group by  s.state,s.city
order by return_value  asc

--Return percentage of products sold more than 5 in quantity

with t1 as (
		select s.product_name,count(r.order_id) as total_return 
			from returns r 
			right join superstore s 
		on s.Order_ID = r.order_id
		group by s.product_name
)

select s.product_name,t1.total_return,sum(s.quantity) as total_quantity,
		try_convert(float,t1.total_return*100/sum(s.quantity)) as percentage_return
from superstore s join t1 on s.Product_Name = t1.Product_Name
where s.quantity >= 5 and t1.total_return >= 1
group by s.Product_Name, t1.total_return
order by percentage_return desc

--Total profit by manager 
select p.region,p.person, floor(sum(s.profit)) as total_profit 
	from superstore s 
	join people p on s.region = p.region 
group by p.person,p.region
order by total_profit desc


--Generate a table exclude return's orders 
select s.* from superstore s 
left join returns r on s.order_id = r.order_id 
where r.order_id is null
