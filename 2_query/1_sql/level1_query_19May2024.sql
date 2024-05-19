-- Step 1 : process order details - create Ordered revenue column

--drop table #orderdetails_temp
select * into #orderdetails_temp from
(
Select 
* 
, quantityOrdered * priceEach as ordered_revenue
from master.dbo.orderdetails
) temp

-- Step 2 : Create Order Year Qtr column

--drop table #orders_temp
select * into #orders_temp from
(
Select 
* 
, CONCAT(YEAR(CAST(orderdate AS DATE)), '-Q', DATEPART(QUARTER, CAST(orderdate AS DATE)))  as ordered_year_qtr
from master.dbo.orders
) temp

-- Step 3 : join orderdetails and order
--drop table order_final
select * into order_final from
(
select 
odet.*
, ord.ordered_year_qtr
, prd.productName
, prd.productLine
from #orderdetails_temp odet
inner join #orders_temp ord on odet.orderNumber = ord.orderNumber 
inner join master.dbo.products prd on odet.productCode = prd.productCode
) temp

-- Step 4 : create summary

select 
productLine
, ordered_year_qtr
, ROUND( sum(ordered_revenue),2) as ordered_rev_sum
from master.dbo.order_final
group by ordered_year_qtr, productLine
order by 1,2











