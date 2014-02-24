select cs.id, min(cs.start_time + interval '4 hours'), s.access_point_id, median(r.level) from common_shortevs as cs
join short_events as s on s.common_shortev_id = cs.id
join records as r on r.short_event_id = s.id
where s.device_id = 1821
group by cs.id, s.access_point_id
order by 2, 3


