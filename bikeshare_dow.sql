select
	day,
	case
		when day = 1 then 'Sunday'
		when day = 2 then 'Monday'
		when day = 3 then 'Tuesday'
		when day = 4 then 'Wednesday'
		when day = 5 then 'Thursday'
		when day = 6 then 'Friday'
		when day = 7 then 'Saturday'
	end as day_name,
	total_rides,
	member_rides,
	total_rides - member_rides as casual_rides,
	(cast(member_rides as float) / cast(total_rides as float)) * 100 as member_percent,
	average_ride,
	member_average_ride
from (
	select 
		day_of_week as day,	
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
	group by day_of_week
	) sub