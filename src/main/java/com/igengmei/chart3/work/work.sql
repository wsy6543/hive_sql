with ta as (
select
t.user_id,
t.click_time,
lag(t.click_time) over(partition by t.user_id order by t.click_time) dt2
from homework.user_clicklog  t
),
tb as (select t.user_id,t.click_time,t.dt2,
(unix_timestamp(t.click_time, "yyyy-MM-dd HH:mm:ss") - unix_timestamp(t.dt2, "yyyy-MM-dd HH:mm:ss"))/60 tl,
case when (unix_timestamp(t.click_time, "yyyy-MM-dd HH:mm:ss") - unix_timestamp(t.dt2, "yyyy-MM-dd HH:mm:ss"))/60 >= 30 then 1 else 0 end mark
from ta t),
tc as (select
t.user_id,
t.click_time,
t.dt2,
t.tl,
sum(t.mark) over(partition by t.user_id order by t.click_time rows BETWEEN unbounded preceding and current row) as mark
from tb t)
select
t.user_id,
t.click_time,
ROW_NUMBER() over(partition by t.mark,t.user_id order by t.click_time ) rank
from tc t
