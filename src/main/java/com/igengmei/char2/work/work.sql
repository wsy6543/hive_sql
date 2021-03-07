-- 第一题
SELECT team
FROM (
  SELECT team, (year - row_number() over (partition by team order by year)) num
  FROM t2
) tmp
GROUP BY team, num
HAVING COUNT(*) = 3;

-- res
-- 公牛
-- 公牛
-- 湖人


-- 第二题
select id,time,price, case when price >p1 and price >p2 then '波峰' when  price <p1 and price <p2 then '波谷' end futer from (select id,time,price,LAG(price,1,price) over(partition by id order by time) p1, LEAD(price,1,price) over(partition by id ,order by time) p2 from t2 ) t3 where (price >p1 and price >p2)  or ( price <p1 and price <p2 );



-- 第三题
select id,sum(sc) logTime, count(*)  logCount from(
    select id ,dt, fzField,sum(fzField) over(partition by id order by dt) fzFields,sc from (
    select id,dt,
(
UNIX_TIMESTAMP(dt,"yyyy/MM/dd HH:mm")-
UNIX_TIMESTAMP(lag(dt,1,dt) over(partition by id order by dt) ,"yyyy/MM/dd HH:mm")
)/60 sc,
case when (UNIX_TIMESTAMP(dt,"yyyy/MM/dd HH:mm")-
UNIX_TIMESTAMP(lag(dt,1,dt) over(partition by id order by dt) ,"yyyy/MM/dd HH:mm"))/60 >30 then 1
else 0
end fzField
from t3
) b
) c group  by  id,fzFields;