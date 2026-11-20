-- spotify-youtube project
-- creating my database of my second project
create database if not exists spotify_db;
use spotify_db;
-- creating my datable table
CREATE TABLE spotify ( artist VARCHAR(255), 
track VARCHAR(255), album VARCHAR(255), 
album_type VARCHAR(50), danceability FLOAT, 
energy FLOAT, loudness FLOAT, 
speechiness FLOAT, acousticness FLOAT, 
instrumentalness FLOAT, liveness FLOAT, 
valence FLOAT, tempo FLOAT, 
duration_min FLOAT, title VARCHAR(255), 
channel VARCHAR(255), 
views BIGINT, likes BIGINT, 
comments BIGINT, licensed VARCHAR(10), 
official_video VARCHAR(10), 
stream BIGINT, energy_liveness FLOAT, 
most_playedon VARCHAR(50) );

select count(*) from spotify;
select * from spotify limit 25;

-- Retrieve all tracks with more than 1 billion streams.
select * from spotify where stream>10000000;

-- List all albums along with their respective artists.

select distinct artist,album from spotify;

-- Get the total number of comments for tracks where licensed = 'TRUE'.

select sum(comments) from spotify 
where licensed='True';

-- Find all tracks where album_type is 'single'.

select track 
from spotify 
where album_type= 'single';

-- Count the total number of tracks by each artist

select artist,count(track)
from spotify
group by artist;

-- Calculate the average danceability of tracks in each album.
select album,avg(danceability) from spotify group by album;

-- Find the top 5 tracks with the highest energy.
with my_cte as (select *, dense_rank () over (order by energy desc) as my_rank
from spotify)
select * from my_cte where my_rank<=5;

--  List tracks where views > likes and official_video = 'TRUE'.
select *
from spotify 
where views> likes and official_video = 'True';

-- Find tracks where liveness is above the average liveness.

select * from spotify where liveness >(select avg(liveness)
from spotify);

-- Calculate the difference between highest and lowest energy for each artist

select artist,max(energy),min(energy),
max(energy)-min(energy) as difference
from spotify 
group by artist ;

-- Find tracks where energy_liveness > 1.2.

select * from spotify 
where energy_liveness >1.2;

--  Top 3 most viewed tracks for each artist using DENSE_RANK().

with my_cte as (select *,
dense_rank() over (partition by artist order by views desc) as my_rank
from spotify)
select * from my_cte where my_rank<=3;

-- Find artists whose tracks are played more on YouTube than Spotify.

with my_cte as (select *,
case when most_playedon = 'Youtube' then 1 else 0 end as Youtube,
case when most_playedon = 'Spotify' then 1 else 0 end as Spotify
from spotify)
select artist,sum(youtube),sum(spotify)
from my_cte 
group by artist
having sum(youtube)>sum(spotify);

-- Calculate the rolling average of streams per artist ordered by track name.
select *,avg(stream) over (partition by artist order by track 
rows between unbounded preceding 
and current row) as rolling_avg
from spotify;

use spotify_db;


-- Categorize tracks by danceability ('High', 'Medium', 'Low') and count totals.


with my_cte as (select *,
case when danceability>0.7 then 'High' when danceability>0.5
 then 'Medium' else 'Low' end as dance_status
from spotify)
select dance_status,count(*)
from my_cte
group by dance_status;
