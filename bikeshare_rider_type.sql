select
	member_casual as rider_type,
	count(ride_id) as total_rides,
	avg(ride_length) as average_ride,
	count(distinct start_station_id) as number_stations
from ride_data rd
group by member_casual 