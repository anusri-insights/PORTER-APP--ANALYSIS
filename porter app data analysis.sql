use mydb;
create table NCR_RIDES(
   Ride_date date,
   Ride_time time,
   Booking_id varchar(50),
   Booking_status varchar(20),
   Customer_id varchar(30),
   Vehicle_type varchar(50),
   Pickup_location varchar(100),
   Drop_location varchar(100),
   Avg_vtat decimal(5,2),
   Avg_ctat decimal(5,2),
   Cancelled_by_customer int,
   Reason_customer_cancellation text,
   Cancelled_by_driver int,
   reason_driver_cancellation text,
   Incomplete_rides int,
   Reason_for_incompletion text,
   Booking_value decimal(10,2),
   Ride_distance decimal(6,3),
   Driver_rating decimal(3,2),
   Customer_rating decimal(3,2),
   Payment_type varchar(30)
   );
   -- Data cleaning
 select*from ncr_rides;
 -- null replacing
 update ncr_rides
SET Reason_customer_cancellation = 'Not cancelled'
WHERE Reason_customer_cancellation IS NULL;

update ncr_rides
SET Cancelled_by_driver = 0
WHERE Cancelled_by_driver IS NULL;

update ncr_rides
SET Reason_driver_cancellation = 'Ride is not cancelled'
WHERE Reason_driver_cancellation IS NULL;

update ncr_rides
SET Incomplete_rides = 0
WHERE Incomplete_rides IS NULL;

update ncr_rides
SET Reason_for_incompletion = 'Ride is completed'
WHERE Reason_for_incompletion =0;

update ncr_rides
SET Booking_value = 45
WHERE Booking_value IS NULL;

Update ncr_rides
SET Ride_distance = 4.6
WHERE Ride_distance=45 ;

Update ncr_rides
SET Driver_rating = 2.9
WHERE Driver_rating is null ;

Update ncr_rides
SET Customer_rating = 2.6
WHERE Customer_rating is null ;
SET SQL_SAFE_UPDATES = 0;
Update ncr_rides
SET Payment_type= 'Cash'
WHERE Payment_type='cash';

-- checking

SELECT COUNT(DISTINCT Booking_id) as total_sale FROM ncr_rides;
SELECT COUNT(DISTINCT customer_id) as total_sale FROM ncr_rides;
SELECT Customer_id, COUNT(*) AS occurrences
FROM ncr_rides
GROUP BY Customer_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS null_count
FROM ncr_rides
WHERE Payment_type IS null;

ALTER TABLE ncr_rides DROP COLUMN temp_id;
select Booking_id;
select distinct Customer_id
from ncr_rides;
delete from ncr_rides
where temp_id not in (select min(temp_id) from ncr_rides group by Booking_id);
select temp_id from ncr_rides;
 -- Keep only the first occurrence based on booking_id
WITH ranked AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY temp_id) AS rn
  FROM ncr_rides
)
SELECT * FROM ranked WHERE rn = 1;
select distinct Customer_id
from ncr_rides;

-- PROJECT

-- 1) LIST ALL COMPLETED RIDES
SELECT DISTINCT Booking_id
FROM ncr_rides
WHERE booking_value > 0
  AND incomplete_rides =0
  AND Cancelled_by_customer = 0
  AND Cancelled_by_driver = 0
  AND Booking_status = 'Completed';
  
  -- 2) SHOW ALL RIDES BOOKED WITH UPI METHOD
  SELECT DISTINCT Booking_id From ncr_rides
  Where Payment_type = 'UPI';
  
  -- 3)FIND ALL RIDES WHERE THE VEHICLE TYPE IS AUTO
  SELECT DISTINCT Booking_id FROM ncr_rides
  WHERE Vehicle_type = 'Auto';
   
  -- 4) FIND THE TOTAL NUMBER OF RIDES BOOKED BY EACH VEHICLE TYPE 
  SELECT Vehicle_type, COUNT(*) AS total_rides
FROM ncr_rides
GROUP BY Vehicle_type;

-- 5) CALCULATE THE AVG BOOKING VALUE FOR COMPLETED RIDES
SELECT avg(Booking_value) as completed_rides FROM ncr_rides 
where Booking_status='Completed'
group by Booking_value
ORDER BY Booking_value desc;

-- 6) FIND THE MAXIMUM RIDE DISTANCE TRAVELLED
SELECT   MAX(Ride_distance) AS MAXIMUM_RIDE_DISTANCE
FROM ncr_rides;

-- 7) GET THE TOP 5 CUSTOMER WHO SPENDTHE MOST
SELECT Customer_id,
SUM(Booking_value) AS total_value
From ncr_rides
GROUP BY Customer_id
ORDER BY Customer_id desc
LIMIT 5;

-- 8) SHOW THE MOST COMMON REASON FOR CANCELLATION BY CUSTOMER
SELECT 
    Reason_customer_cancellation,
    COUNT(*) AS cancellation_count
FROM 
    ncr_rides
WHERE 
    Reason_customer_cancellation IS NOT NULL
GROUP BY 
    Reason_customer_cancellation
ORDER BY 
    cancellation_count DESC
LIMIT 1;
-- 9) FIND DRIVER RATE VS CUSTOMER RATE DIFFERENCE FOR EACH RIDE
SELECT 
   DISTINCT (Booking_id),
    Driver_rating,
    Customer_rating,
    (Driver_rating - Customer_rating) AS rating_difference
FROM 
    ncr_rides
WHERE 
    Driver_rating IS NOT NULL AND Customer_rating IS NOT NULL;
    
    -- 10) FIND THE BUSIEST PICKUP LOCATION
    SELECT Pickup_location,COUNT(*) AS LOCATION
    FROM ncr_rides
    WHERE Pickup_location is not null
    group by Pickup_location
    order by LOCATION desc
    limit 1;

    -- END--



 

 