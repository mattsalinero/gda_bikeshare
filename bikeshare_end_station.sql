select
	end_station_id,
	total_rides,
	member_rides,
	total_rides - member_rides as casual_rides,
	(cast(member_rides as float) / cast(total_rides as float)) * 100 as member_percent,
	average_ride,
	member_average_ride
from (
	select 
		end_station_id,	
		count(rd.ride_id) as total_rides,
		count(mb.ride_id) as member_rides,
		avg(rd.ride_length) as average_ride,
		avg(mb.ride_length) as member_average_ride
	from ride_data rd 
	left join (
		select ride_id, ride_length
		from ride_data rd2
		where member_casual = 'member'
		) mb
	on rd.ride_id = mb.ride_id 
	group by end_station_id
	) sub
