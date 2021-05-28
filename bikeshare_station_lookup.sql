select
	min(s.station_primary_id) as station_primary_id,
	start_station_id as station_id
from ride_data rd 
join station s
on rd.start_station_name = s.station_name 
where start_station_id != ''
group by start_station_id