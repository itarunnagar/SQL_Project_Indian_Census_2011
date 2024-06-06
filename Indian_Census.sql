-- Go to the DataBAse
use Project_01_Indian_Census_2011 ;

-- Then see the First DataSet
select * from Dataset_01 ; 

-- Then see the second DataSet
select * from Dataset_02 ;

-- How many data  or rows available in DataSet...
select count(*) from Dataset_01 ; 
select count(*) from Dataset_02 ;

--Data onnly for Jharkhand And BIhar
select * 
from dataset_01 
where state in ('JharKhand' , 'Bihar') 
order by state; 

-- Total Population of India..
select sum(population) as Total_Population 
from Dataset_02 ; 

--Average Growth 
select avg(growth)*100 as Average_Growth_PErcantage 
from DataSet_01  ; 

-- Average Growth Per State
select state , avg(growth) * 100 as Average_Growth
from Dataset_01 
group by state
order by Average_Growth desc ; 

-- Average Growth Per State Top 05
select State , round(avg(growth) * 100 , 2 ) as Average_Growth
from Dataset_01 
group by state
order by Average_Growth desc
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;


-- Average Sex Ratio..
select round(avg(Sex_Ratio),0) as Avg_Sex_Ratio from Dataset_01 ;

-- Average Sex Ratio Per State
select state , round(avg(Sex_Ratio) , 0) as Avg_Sex_Ratio 
from Dataset_01 
group by state
order by Avg_Sex_Ratio desc ;

-- Average Literacy Rate
select avg(Literacy) as Average_Literacy_rate from dataset_01 ; 

-- Average Litercy Rate BY State
select State , round(avg(Literacy), 0) as Avg_Literacy_per_state 
from Dataset_01 
group by State 
order by Avg_Literacy_per_state desc
offset 0 rows fetch next 5 rows only; 

-- Literacy Rate Greater Than 50 
-- Average Litercy Rate BY State
select State , round(avg(Literacy), 0) as Avg_Literacy_per_state 
from Dataset_01 
group by State 
having  round(avg(Literacy), 0) >= 50 
order by Avg_Literacy_per_state desc ; 

-- State Where Literacy Rate Was High And Sex Ratio Was Low..
select state , round(avg(Literacy),0) as Average_Literacy , round(avg(Sex_Ratio),0) as Average_Sex_Ratio
from Dataset_01
group by state
order by Average_Literacy desc , Average_Sex_Ratio asc 
offset 0 rows fetch next 5 rows only; 


-- Top 3 State Where Growth Perccantage Was Very High...
select  state , round(avg(growth)* 100 , 0) as Average_Growth_Percan
from Dataset_01
group by state
order by Average_Growth_Percan desc 
offset 0 rows fetch next 3 rows only;

-- New Method
select  top 10 state , round(avg(growth)* 100 , 0) as Average_Growth_Percan
from Dataset_01
group by state
order by Average_Growth_Percan desc  ; 


-- Bottom 3 State Where Growth Perccantage Was Very High...
select  state , round(avg(growth)* 100 , 0) as Average_Growth_Percan
from Dataset_01
group by state
order by Average_Growth_Percan asc 
offset 0 rows fetch next 3 rows only;


-- Bottom 3 State Where Sex Ratio Was Very LOw...
select  state , round(avg(Sex_Ratio) , 0) as Average_Growth_Percan
from Dataset_01
group by state
order by Average_Growth_Percan asc 
offset 0 rows fetch next 3 rows only;


-- Top and bottom 3 literacy State
select top 3 state , round(avg(Literacy) , 0) as Average_Literacy_State
from Dataset_01
group by State
order by Average_Literacy_State desc ; 

select top 3 state ,round(avg(Literacy) , 0) as Average_Literacy_State
from Dataset_01
group by State
order by Average_Literacy_State ;

-- Combine All The Columns
-- TOp 03 and Bottm 03 State
select *
from (select top 3 state , round(avg(Literacy) , 0) as Average_Literacy_State
from Dataset_01
group by State
order by Average_Literacy_State desc  ) A 
union all
select *
from (select top 3 state ,round(avg(Literacy) , 0) as Average_Literacy_State
from Dataset_01
group by State
order by Average_Literacy_State asc) B 
order by Average_Literacy_State desc ;

-- State Starting With  A
select *
from Dataset_01
where state like 'a%' ; 

-- State Starting With  A,E,I,O,U
select *
from Dataset_01
where state like '[aeiou]%' ;

-- Advance Sql Functions..
select * from Dataset_01 ; 
select * from Dataset_02 ;


-- Combine Both The Data Set 01 And 02 
select a.district , a.state , a.growth , a.sex_ratio , a.literacy , b.area_km2  , b.Population 
from Dataset_01 a join Dataset_02 b
on a.District = b.District;  


-- Based on the State All Populations
With AB as (select a.district , a.state , a.growth , a.sex_ratio , a.literacy , b.area_km2  , b.Population 
from Dataset_01 a join Dataset_02 b
on a.District = b.District)
select state , sum(population) as Total_Populations
from AB group by state
order by Total_Populations desc; 

-- Top 5 State Based on Populations..
With AB as (select a.district , a.state , a.growth , a.sex_ratio , a.literacy , b.area_km2  , 
b.Population 
from Dataset_01 a join Dataset_02 b
on a.District = b.District)
select top 5 State , round(sum(population),0) as Total_Populations
from AB group by state
order by Total_Populations desc; 


-- Bottom 5 State Based on Populations..
With AB as (select a.district , a.state , a.growth , a.sex_ratio , a.literacy , b.area_km2  , b.Population 
from Dataset_01 a join Dataset_02 b
on a.District = b.District)
select top 5 state , sum(population) as Total_Populations
from AB group by state
order by Total_Populations asc; 

-- Calculating Numbers of Males And Females
With AB as (select a.district , a.state , a.growth , a.sex_ratio , a.literacy , b.area_km2  , b.Population 
from Dataset_01 a join Dataset_02 b
on a.District = b.District)
select * from AB ;

-- Formula to calculate the Males And Female is  [ Sex Ratio = (male / female)  ]
-- Male = Population / (  Sex_Ratio + 1 ) , Female =>population *((sex_ratio)  / sex_ratio) 
-- So First Find the Male Values...
With AB as (select a.district , a.state , a.growth , (a.sex_ratio/1000 ) as new_Sex_ratio, a.literacy , b.area_km2  , b.Population 
from Dataset_01 a join Dataset_02 b
on a.District = b.District)
select * ,
round(( Population / (new_Sex_ratio + 1) ), 0) as Num_of_Male,
round((Population * new_Sex_ratio ) / (new_Sex_ratio + 1) , 0) as Num_of_Female
from AB ;


-- By New Method...
With AB as (select a.district , a.state , a.growth , (a.sex_ratio/1000 ) as new_Sex_ratio, a.literacy , b.area_km2  , b.Population ,
round(( Population / ((a.sex_ratio/1000 ) + 1) ), 0) as Num_of_Male,
round((Population * (a.sex_ratio/1000 ) ) / ((a.sex_ratio/1000 ) + 1) , 0) as Num_of_Female
from Dataset_01 a join Dataset_02 b
on a.District = b.District)
select * 
from AB ;


-- Top 5 State Where Numbers of Female is Highers
With AB as (select a.district , a.state , a.growth , (a.sex_ratio/1000 ) as new_Sex_ratio, 
a.literacy , b.area_km2  , b.Population ,
round(( Population / ((a.sex_ratio/1000 ) + 1) ), 0) as Num_of_Male,
round((Population * (a.sex_ratio/1000 ) ) / ((a.sex_ratio/1000 ) + 1) , 0) as Num_of_Female
from Dataset_01 a join Dataset_02 b
on a.District = b.District)
select top 5 state , sum(num_of_female)  as Numbers_Of_Female
from AB 
group by state 
order by Numbers_Of_Female desc; 


-- Top Numbers of Males and Females Based on State
With AB as (select a.district , a.state , a.growth , (a.sex_ratio/1000 ) as new_Sex_ratio, a.literacy , b.area_km2  , b.Population ,
round(( Population / ((a.sex_ratio/1000 ) + 1) ), 0) as Num_of_Male,
round((Population * (a.sex_ratio/1000 ) ) / ((a.sex_ratio/1000 ) + 1) , 0) as Num_of_Female
from Dataset_01 a join Dataset_02 b
on a.District = b.District)
select State , sum(Num_of_Female) as Total_Females , sum(Num_of_Male) as Total_Males 
from Ab
group by state ; 


-- Where State is Madhya Pradesh 
With AB as (select a.district , a.state , a.growth , (a.sex_ratio/1000 ) as new_Sex_ratio, a.literacy , b.area_km2  , b.Population ,
round(( Population / ((a.sex_ratio/1000 ) + 1) ), 0) as Num_of_Male,
round((Population * (a.sex_ratio/1000 ) ) / ((a.sex_ratio/1000 ) + 1) , 0) as Num_of_Female
from Dataset_01 a join Dataset_02 b
on a.District = b.District)
select * 
from AB
where state = 'Madhya Pradesh'
order by Num_of_Female desc;

-- Top  City Based on Arra Wise in India..
With AB as (select a.district , a.state , a.growth , (a.sex_ratio/1000 ) as new_Sex_ratio, a.literacy , b.area_km2  , b.Population ,
round(( Population / ((a.sex_ratio/1000 ) + 1) ), 0) as Num_of_Male,
round((Population * (a.sex_ratio/1000 ) ) / ((a.sex_ratio/1000 ) + 1) , 0) as Num_of_Female
from Dataset_01 a join Dataset_02 b
on a.District = b.District)
select District , Area_km2
from AB 
order by Area_km2 desc; 

-- How many area have present in the state
With AB as (select a.district , a.state , a.growth , (a.sex_ratio/1000 ) as new_Sex_ratio,
a.literacy , b.area_km2  , b.Population ,
round(( Population / ((a.sex_ratio/1000 ) + 1) ), 0) as Num_of_Male,
round((Population * (a.sex_ratio/1000 ) ) / ((a.sex_ratio/1000 ) + 1) , 0) as Num_of_Female
from Dataset_01 a join Dataset_02 b
on a.District = b.District)
select top 5 state , sum(Area_km2) as Total_Area
from AB
group by state
order by Total_Area desc ; 


 
-- Total Literate People State of All State
With AB as (select a.district , a.state , a.growth , (a.sex_ratio/1000 ) as new_Sex_ratio, a.literacy , b.area_km2  , b.Population ,
round(( Population / ((a.sex_ratio/1000 ) + 1) ), 0) as Num_of_Male,
round((Population * (a.sex_ratio/1000 ) ) / ((a.sex_ratio/1000 ) + 1) , 0) as Num_of_Female , 
round((Population * Literacy/100) , 0) as total_literate_people
from Dataset_01 a join Dataset_02 b
on a.District = b.District)
select state , sum(total_literate_people) as Total_Literate_IN_State
from Ab
group by state
order by Total_Literate_IN_State desc ; 

-- Literate People and illiterate in Every City
select a.district , a.state , a.Growth , a.Sex_Ratio , a.Literacy , b.Area_km2 , b.Population ,
round((b.Population * a.Literacy/100) , 0) as Literate_People , 
round(( Population - (b.Population * a.Literacy/100)) , 0) as Illiterate_people
from Dataset_01 a join Dataset_02 b 
on a.district = b.district ; 

-- First find the total population of State....
With Ab as (select a.district , a.state , a.Growth , a.Sex_Ratio , a.Literacy , b.Area_km2 , b.Population 
from Dataset_01 a join Dataset_02 b 
on a.district = b.district)
select state , sum(Population) as Total_Population_State 
from Ab 
group by state
order by Total_Population_State ; 

-- Literate People In Every State
With Ab as (select a.district , a.state , a.Growth , a.Sex_Ratio , a.Literacy , b.Area_km2 , b.Population 
from Dataset_01 a join Dataset_02 b 
on a.district = b.district)
select state , round(sum(Literacy/100 * Population), 0)as Total_Literate_People_In_State 
from Ab 
group by state
order by Total_Literate_People_In_State desc; 

-- Literacy Percantage of Every State or Union Teritary...
select State , sum(Population) as Total_Population , sum(Literate_People) as Total_Literate_People ,
sum(Illiterate_people) as Total_Illiterate_People ,
round((SUM(Literate_People) / SUM(Population)) * 100 , 0) AS Literacy_Percentage
from (select a.district , a.state , a.Growth , a.Sex_Ratio , a.Literacy , b.Area_km2 , b.Population ,
round((b.Population * a.Literacy/100) , 0) as Literate_People , 
round(( Population - (b.Population * a.Literacy/100)) , 0) as Illiterate_people
from Dataset_01 a join Dataset_02 b 
on a.district = b.district) ABC
group by State
order by Literacy_Percentage desc; 

-- Previous Census Population of Every State
select Top 5 State , sum(Population) as Total_Population ,
round(sum(Population / (1 + Growth)) , 0) as Previous_Census_Population , 
sum(Literate_People) as Total_Literate_People ,
sum(Illiterate_people) as Total_Illiterate_People ,
round((SUM(Literate_People) / SUM(Population)) * 100 , 0) AS Literacy_Percentage 
from (select a.district , a.state , a.Growth , a.Sex_Ratio , a.Literacy , b.Area_km2 , b.Population ,
round((b.Population * a.Literacy/100) , 0) as Literate_People , 
round(( Population - (b.Population * a.Literacy/100)) , 0) as Illiterate_people
from Dataset_01 a join Dataset_02 b 
on a.district = b.district) ABC
group by State 
order by Previous_Census_Population desc ; 

-- Total population of India Before And After NEw Census
select sum(Total_Population) as Current_Sensus , 
sum(Previous_Census_Population) as Previous_Census_Population , 
(sum(Total_Population) - sum(Previous_Census_Population) )as increasing_peoples
from (select State , sum(Population) as Total_Population ,
round(sum(Population / (1 + Growth)) , 0) as Previous_Census_Population , 
sum(Literate_People) as Total_Literate_People ,
sum(Illiterate_people) as Total_Illiterate_People ,
round((SUM(Literate_People) / SUM(Population)) * 100 , 0) AS Literacy_Percentage 
from (select a.district , a.state , a.Growth , a.Sex_Ratio , a.Literacy , b.Area_km2 , b.Population ,
round((b.Population * a.Literacy/100) , 0) as Literate_People , 
round(( Population - (b.Population * a.Literacy/100)) , 0) as Illiterate_people
from Dataset_01 a join Dataset_02 b 
on a.district = b.district) ABC
group by State ) ABCDE ; 
 

 -- Population VS Area ;
 select sum(Total_Population) as Current_Sensus_2011 , 
sum(Previous_Census_Population) as Previous_Census_Population , 
(sum(Total_Population) - sum(Previous_Census_Population) )as increasing_peoples ,
sum(Total_Area) as Total_Area , 
sum(Total_Population)/ sum(Total_Area) as Population_ON_Area 
from (select State ,sum(Area_km2) as Total_Area , sum(Population) as Total_Population ,
round(sum(Population / (1 + Growth)) , 0) as Previous_Census_Population , 
sum(Literate_People) as Total_Literate_People ,
sum(Illiterate_people) as Total_Illiterate_People ,
round((SUM(Literate_People) / SUM(Population)) * 100 , 0) AS Literacy_Percentage 
from (select a.district , a.state , a.Growth , a.Sex_Ratio , a.Literacy , b.Area_km2 , b.Population ,
round((b.Population * a.Literacy/100) , 0) as Literate_People , 
round(( Population - (b.Population * a.Literacy/100)) , 0) as Illiterate_people
from Dataset_01 a join Dataset_02 b 
on a.district = b.district) ABC
group by State ) ABCDE ; 


-- Top 3 Distrcit from every state where literacy rate was high
select a.District , a.State , a.Growth , a.Sex_Ratio , a.Literacy 
from (select * , dense_rank() over(partition by state order by literacy desc) as Dense_Rnks
from Dataset_01) A
where Dense_Rnks <= 3 ;

-- Top 5 District from every state where growth rate was high
select a.District , a.State , a.Growth , a.Sex_Ratio , a.Literacy 
from (select * , dense_rank() over(partition by state order by growth desc) as Dense_Rnks
from Dataset_01) A
where Dense_Rnks <= 5 ; 









