--Practice File 
select * from Train_csv
--Q1.Rank Passengers by fare in decending order
select *,
dense_rank() over(partition by Pclass order by Fare desc)
from Train_csv

--Q2.calculate the average Fare of customers on the basis of pclass
select *,
avg(fare) over(partition by Pclass )
from Train_csv

--Q3.Assign a unique row number to each Passenger within their Pclass
select *,
row_number() over(partition by Pclass order by Pclass)
from Train_csv

--Q4.find the  highest Fare for each class
select distinct top 3 
max(fare) over(Partition by Pclass)
from Train_csv

--Q5.find the cumelative sum of fare for survived Passengers in each Pclass
select * ,
sum(Fare) over(partition by pclass order by Fare rows between unbounded preceding and current row)
from Train_csv
where survived='1'

--Q6.Find the median age for passenger each class
select Name,
Percentile_disc(0.5) within group(order by Age) over(partition by Pclass )
from Train_csv

--Q7.Assign bucket number to each Passenger on the basis of age in the intervale of 10
select Name,Age,Pclass,case 
     when age<10 then '1'
     when age >=10 and age <21 then '2'
     when age >=21 and age < 31 then '3'
     when age >=31 and age <41 then '4'
     when age >=41 and age < 51 then '5'
     when age >=50 and age <61 then '6'
     when age >=61 and age < 71 then '7'
     when age >=71 and age < 81 then '8'
     else 'No value'
     end as Age_bucket     
from Train_csv
order by Age_bucket;

--Q8.find the first and last Passenger Name on the basis of Pclass and order by name
select * ,
first_value(Name) over(partition by Pclass order by Name),
last_value(Name) over(partition by Pclass order by name rows between current row and unbounded following)
from Train_csv
order by Name

--Q9.Calculate the lag and lead fare for each passenger
select *,
lead(Fare) over(order by fare) as lead_fare,
lag(fare) over(order  by fare) as lag_fare
from train_csv

--Subquary section

--Q10.Find those passengers who paid more then average fare of their class
with ClassAvgFare as (select *,
                      avg(fare) over(partition by Pclass) as avg_fare 
                      from Train_csv)
select * from ClassAvgFare
where fare > ClassAvgFare.avg_fare

--Q11.Find the top 3 highest Fare and their corresponding passengers
select * from Train_csv
where fare IN (select distinct top 3 fare from Train_csv ORDER BY Fare desc)

--Q12.find the average age of passeners on each class ,excluded of those who did'nt survived 
select Pclass,avg(age) from Train_csv
where survived='1'
group by Pclass

--Q13.Find the passenger who were in a cabin with more than tow passengers
select * from Train_csv
where Cabin in (select Cabin 
                from Train_csv 
                group by Cabin
                having count(*) >2)

