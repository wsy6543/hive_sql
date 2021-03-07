create table t1(
    id int,
    name string,
    hobby array<string>,
    addr  map<string, string>
)
row format delimited
fields terminated by ";"
collection items terminated by ","
map keys terminated by ":";





create external table t2(
    id int,
    name string,
    hobby array<string>,
    addr  map<string, string>
)
row format delimited
fields terminated by ";"
collection items terminated by ","
map keys terminated by ":";




create table course(
    id int,
    name string,
    score int
)
clustered by (id) into 3 buckets
row format delimited
fields terminated by ';'
collection items terminated by ','
map keys terminated by ':';


create table course_common(
    id int,
name string,
score int )
row format delimited
fields terminated by ';'
collection items terminated by ','
map keys terminated by ':';




with tmp as (
select name, subject, mark
  from studscore lateral view explode(score) t1 as subject, mark
)
select name, max(mark) maxscore
  from tmp
group by name;