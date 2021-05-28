select
	bike_type,
	total_rides,
	member_rides,
	total_rides - member_rides as casual_rides,
	(cast(member_rides as float) / cast(total_rides as float)) * 100 as member_percent,
	average_ride,
	member_average_ride,
	number_stations
from (
	select 
		rideable_type as bike_type,	
		count(rd.ride_id) as total_rides,
		count(mb.ride_id) as member_rides,
		avg(rd.ride_length) as average_ride,
		avg(mb.ride_length) as member_average_ride,
		count(distinct start_station_id) as number_stations
	from ride_data rd 
	left join (
		select ride_id, ride_length
		from ride_data rd2
		where member_casual = 'member'
		) mb
	on rd.ride_id = mb.ride_id 
	group by rideable_type 
	) sub