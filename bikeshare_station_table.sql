select
	start_station_id as station_id,
	max(start_station_name) as station_name,
	avg(start_lat) as lat,
	avg(start_lng) as lng
from ride_data rd 
where start_station_id != ''
group by start_station_id