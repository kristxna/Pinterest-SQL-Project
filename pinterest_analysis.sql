-- Top 10 Most Engaging Users
-- Identifying users with the highest average engagement (likes + comments) per post.
WITH user_engagement AS (
    SELECT 
        user_id,
        user_name,
        COUNT(post_id) AS total_posts,
        SUM(COALESCE(likes, 0)) AS total_likes,
        SUM(COALESCE(comments_num, 0)) AS total_comments,
        (SUM(COALESCE(likes, 0)) + SUM(COALESCE(comments_num, 0))) / 
        CASE WHEN COUNT(post_id) = 0 THEN 1 ELSE COUNT(post_id) END AS avg_engagement_per_post
    FROM pinterest_posts
    GROUP BY user_id, user_name
)
SELECT *
FROM user_engagement
ORDER BY avg_engagement_per_post DESC
LIMIT 10;


-------------------------------------------------------------------------------------------------------------------------

-- Viral Posts with Low Follower Counts
-- Identifying viral posts from accounts with fewer than 1,000 followers.
SELECT 
    url,
    title,
    user_name,
    followers,
    COALESCE(likes, 0) AS likes,
    COALESCE(comments_num, 0) AS comments,
    (COALESCE(likes, 0) + COALESCE(comments_num, 0)) AS total_engagement
FROM pinterest_posts
WHERE followers < 1000 AND (likes + comments_num) > 100
ORDER BY total_engagement DESC
LIMIT 10;


-------------------------------------------------------------------------------------------------------------------------

-- Most Popular Content Categories
-- Identifying the top-performing categories based on engagement.
SELECT 
    categories,
    COUNT(*) AS post_count,
    ROUND(AVG(COALESCE(likes, 0)), 2) AS avg_likes,
    ROUND(AVG(COALESCE(comments_num, 0)), 2) AS avg_comments
FROM pinterest_posts
WHERE categories IS NOT NULL AND categories != 'null'
GROUP BY categories
ORDER BY post_count DESC
LIMIT 10;


-------------------------------------------------------------------------------------------------------------------------

-- Optimal Posting Times for Engagement
-- Which hours of the day yield the highest engagement?

SELECT 
    substr(date_posted, instr(date_posted, 'T') + 1, 2) AS posting_hour,
    ROUND(AVG(COALESCE(likes, 0)), 2) AS avg_likes,
    ROUND(AVG(COALESCE(comments_num, 0)), 2) AS avg_comments,
    ROUND((AVG(COALESCE(likes, 0)) + AVG(COALESCE(comments_num, 0))), 2) AS total_avg_engagement
FROM pinterest_posts
WHERE date_posted IS NOT NULL
GROUP BY posting_hour
ORDER BY total_avg_engagement DESC
LIMIT 5;


-------------------------------------------------------------------------------------------------------------------------

-- Most Active Users by Post Volume
-- Which users post the most frequently?
SELECT 
    user_name,
    COUNT(post_id) AS total_posts,
    SUM(COALESCE(likes, 0)) AS total_likes,
    SUM(COALESCE(comments_num, 0)) AS total_comments,
    ROUND((SUM(COALESCE(likes, 0)) + SUM(COALESCE(comments_num, 0))) / COUNT(post_id), 2) AS avg_engagement_per_post
FROM pinterest_posts
GROUP BY user_name
ORDER BY total_posts DESC
LIMIT 10;


-------------------------------------------------------------------------------------------------------------------------

-- Post Type Engagement Analysis
-- Comparing engagement levels across different post types (image and video).
SELECT 
    post_type,
    COUNT(*) AS post_count,
    ROUND(AVG(COALESCE(likes, 0)), 2) AS avg_likes,        
    ROUND(AVG(COALESCE(comments_num, 0)), 2) AS avg_comments 
FROM pinterest_posts
WHERE post_type IS NOT NULL
GROUP BY post_type
ORDER BY avg_likes DESC;


-------------------------------------------------------------------------------------------------------------------------

-- Content Discovery Analysis
-- Which discovery input methods lead to the most engaging content?
SELECT 
    discovery_input,
    COUNT(*) AS total_posts,
    ROUND(AVG(COALESCE(likes, 0)), 2) AS avg_likes,
    ROUND(AVG(COALESCE(comments_num, 0)), 2) AS avg_comments,
    ROUND(AVG(COALESCE(likes, 0) + COALESCE(comments_num, 0)), 2) AS avg_engagement
FROM pinterest_posts
WHERE discovery_input IS NOT NULL AND discovery_input != 'null' 
GROUP BY discovery_input
ORDER BY avg_engagement DESC
LIMIT 20; 
