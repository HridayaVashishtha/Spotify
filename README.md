# Spotify Music Analysis: A Deep Dive with SQL 

This project is a comprehensive analysis of a Spotify dataset using PostgreSQL. I explored song attributes, artist popularity, and platform performance to uncover interesting trends in the music world. The main goal was to sharpen my advanced SQL skills, including writing complex queries, using window functions, and optimizing database performance.


## The Dataset 

The dataset contains a rich collection of information for each track, blending Spotify's audio feature metrics with YouTube performance statistics.

### Key attributes include:

- **Track Details:** track, artist, album, album_type  
- **Audio Features:** danceability, energy, loudness, acousticness, tempo  
- **Engagement Metrics:** stream (on Spotify), views, likes, comments (on YouTube)

## Technology Stack 

- **Database:** PostgreSQL  
- **DB Management:** pgAdmin 4  
- **Core Language:** SQL (DDL, DML, CTEs, Window Functions)


## Analytical Questions & Insights 

I structured my analysis by working through a series of questions, progressing from easy to advanced to build my skills.

### Easy Level

- Retrieve the names of all tracks that have more than 1 billion streams.  
- List all albums along with their respective artists.  
- Get the total number of comments for tracks where licensed = TRUE.  
- Find all tracks that belong to the album type single.  
- Count the total number of tracks by each artist.

### Medium Level

- Calculate the average danceability of tracks in each album.  
- Find the top 5 tracks with the highest energy values.  
- List all tracks along with their views and likes where official_video = TRUE.  
- For each album, calculate the total views of all associated tracks.  
- Retrieve the track names that have been streamed more on Spotify than viewed on YouTube.

### Advanced Level

- Find the top 3 most-viewed tracks for each artist using window functions.  
- Write a query to find tracks where the liveness score is above the average liveness score of all tracks.  
- Use a WITH clause (CTE) to calculate the difference between the highest and lowest energy values for tracks in each album.  
- Find tracks where the energy-to-liveness ratio is greater than 1.2.  
- Calculate the cumulative sum of likes for tracks ordered by the number of views, using a window function.

## Spotlight on Performance: Query Optimization 

A key part of this project was learning to make my queries not just correct, but also fast.  
I identified a slow-running query that filtered tracks by artist. Using `EXPLAIN ANALYZE`, I found the initial query took ~7.0 ms to execute because it required a full table scan.

### The Solution: I created an index on the artist column.

```sql
CREATE INDEX idx_artist ON spotify(artist);
```
## The Result:
After indexing, the same query's execution time dropped to ~0.15 ms — a performance improvement of over 97%!
This demonstrates the massive impact of proper indexing on database efficiency.
