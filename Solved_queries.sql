SELECT * FROM spotify;

----------------------------------------------------------------------------------------------
------------------------------------- Easy Category ------------------------------------------
----------------------------------------------------------------------------------------------
/*
1. Retrieve the names of all tracks that have more than 1 billion streams.
2. List all albums along with their respective artists.
3. Get the total number of comments for tracks where licensed = TRUE.
4. Find all tracks that belong to the album type single.
5. Count the total number of tracks by each artist.
*/

-- Retrieve the names of all tracks that have more than 1 billion streams.
SELECT * FROM spotify
WHERE stream > 1000000000;

-- List all albums along with their respective artists.
SELECT 
	DISTINCT album, artist 
FROM spotify 
ORDER BY 1;

-- Get the total number of comments for tracks where licensed = TRUE.
SELECT 
	SUM(comments) AS total_comments 
FROM spotify 
WHERE licensed = 'true';

-- Find all tracks that belong to the album type single.
SELECT * FROM spotify
WHERE album_type ILIKE 'single';

-- Count the total number of tracks by each artist.
SELECT 
	artist,
	COUNT(*) as total_songs
FROM spotify
GROUP BY artist
ORDER BY 2;

----------------------------------------------------------------------------------------------
------------------------------------- Medium Category ----------------------------------------
----------------------------------------------------------------------------------------------
/*
1. Calculate the average danceability of tracks in each album.
2. Find the top 5 tracks with the highest energy values.
3. List all tracks along with their views and likes where official_video = TRUE.
4. For each album, calculate the total views of all associated tracks.
5. Retrieve the track names that have been streamed on Spotify more than YouTube.
*/

-- Calculate the average danceability of tracks in each album.
SELECT 
	album,
	AVG(danceability) AS avg_danceability
FROM spotify 
GROUP BY album;

-- Find the top 5 tracks with the highest energy values.
SELECT
	track,
	AVG(energy)
FROM spotify 
GROUP BY track
ORDER BY 2 DESC
LIMIT 5;

-- List all tracks along with their views and likes where official_video = TRUE.
SELECT
	track,
	SUM(views) AS tot_views,
	SUM(likes) AS tot_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC;

-- For each album, calculate the total views of all associated tracks.
SELECT
	album,
	track,
	SUM(views) AS tot_views
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC;

-- Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT track FROM spotify 
WHERE most_played_on = 'Spotify';


----------------------------------------------------------------------------------------------
------------------------------------ Advance Category ----------------------------------------
----------------------------------------------------------------------------------------------
/*
1. Find the top 3 most-viewed tracks for each artist using window functions.
2. Write a query to find tracks where the liveness score is above the average.
3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
*/

-- Find the top 3 most-viewed tracks for each artist using window functions.
WITH ranking_artist AS
(SELECT
	artist,
	track,
	SUM(views) AS tot_views,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE rank <= 3;

-- Write a query to find tracks where the liveness score is above the average.
SELECT
	track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);

-- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH upper_bound AS
(SELECT 
	album,
	MAX(energy) AS max_energy,
	MIN(energy) AS min_energy
FROM spotify
GROUP BY 1
)
SELECT album, (max_energy - min_energy) AS diff
FROM upper_bound ;

-- Find tracks where the energy-to-liveness ratio is greater than 1.2.
WITH Energy_to_liveness AS
(SELECT 
	track,
	(energy/liveness) AS ratio
FROM spotify
)
SELECT * FROM Energy_to_liveness
WHERE ratio > 1.2;

-- Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT 
    track,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views) AS cumulative_likes
FROM spotify;


-- Query Optimisation
EXPLAIN ANALYSE
SELECT 
	artist,
	track,
	views
FROM spotify
WHERE artist = 'Gorillaz'
	AND most_played_on = 'Youtube'
ORDER BY stream DESC LIMIT 25;

CREATE INDEX artist_index ON spotify (artist);

