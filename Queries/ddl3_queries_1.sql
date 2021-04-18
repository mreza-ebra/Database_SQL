/* 1 before */

SELECT COUNT(B.BUSINESS_ID)
FROM BUSINESS B, locate L
WHERE b.review_count > 5 AND b.business_stars > 4.2 AND l.business_id = b.business_id AND l.statee = 'ON';

/* 1 */

SELECT COUNT(B.BUSINESS_ID)
FROM BUSINESS B, Locate_2 L
WHERE b.review_count > 5 AND b.business_stars > 4.2 
	AND l.business_id = b.business_id AND l.statee = 'on';

/* 2 */

SELECT b_quiet.avg_rate - b_loud.avg_rate
FROM (SELECT AVG(b1.business_stars) as Avg_rate
        FROM business b1, suit_good_for_meal s1, meal m1, sound_noise_level n1
        WHERE b1.business_id = s1.business_id AND s1.meal_id = m1.meal_id
        AND m1.dinner = 1 AND b1.business_id = n1.business_id 
        AND (n1.noise_level= 0 or n1.noise_level=1)) b_quiet,
        (SELECT AVG(b2.business_stars) as Avg_rate
        FROM business b2, suit_good_for_meal s2, meal m2, sound_noise_level n2
        WHERE b2.business_id = s2.business_id AND s2.meal_id = m2.meal_id
        AND m2.dinner = 1 AND b2.business_id = n2.business_id 
        AND (n2.noise_level= 2 or n2.noise_level=3)) b_loud;

/* 3 */

SELECT b1.namee, b1.business_stars, b1.review_count
FROM business b1, play_music p1, music m1, has_categories h1
WHERE b1.business_id = p1.business_id AND p1.music_id = m1.music_id
    AND m1.live = 1 AND b1.business_id = h1.business_id 
    AND h1.labell = 'IrishPub';

/* 4 years */
WITH g1 AS (SELECT DISTINCT u1.user_idd, u1.useful
        FROM userr u1, elite e1
        WHERE u1.average_stars >= 2 AND u1.average_stars < 4 AND u1.user_idd in e1.user_idd),
	g2 AS (SELECT DISTINCT u2.user_idd, u2.useful
        FROM userr u2, elite e2
        WHERE u2.average_stars >= 4 AND u2.average_stars <= 5 AND u2.user_idd in e2.user_idd),
	g3 AS (SELECT DISTINCT u3.user_idd, u3.useful
        FROM userr u3, elite e3
        WHERE u3.average_stars >= 2 AND u3.average_stars < 4 AND u3.user_idd not in e3.user_idd),
	g4 AS (SELECT DISTINCT u4.user_idd, u4.useful
        FROM userr u4, elite e4
        WHERE u4.average_stars >= 4 AND u4.average_stars <= 5 AND u4.user_idd not in e4.user_idd)	
SELECT AVG(g1.useful) AS low_mark_elite, AVG(g2.useful) AS high_mark_elite,
        AVG(g3.useful) AS low_mark_non_elite, AVG(g4.useful) AS high_mark_non_elite	
FROM g1, g2, g3, g4
FROM   (SELECT DISTINCT u1.user_idd, u1.useful
        FROM userr u1, elite e1
        WHERE u1.average_stars >= 2 AND u1.average_stars < 4 AND u1.user_idd in e1.user_idd) g1,
        (SELECT DISTINCT u2.user_idd, u2.useful
        FROM userr u2, elite e2
        WHERE u2.average_stars >= 4 AND u2.average_stars <= 5 AND u2.user_idd in e2.user_idd) g2,
        (SELECT DISTINCT u3.user_idd, u3.useful
        FROM userr u3, elite e3
        WHERE u3.average_stars >= 2 AND u3.average_stars < 4 AND u3.user_idd not in e3.user_idd) g3,
        (SELECT DISTINCT u4.user_idd, u4.useful
        FROM userr u4, elite e4
        WHERE u4.average_stars >= 4 AND u4.average_stars <= 5 AND u4.user_idd not in e4.user_idd) g4

/* 4 real */
SELECT AVG(g1.useful) AS low_mark_elite
FROM   (SELECT DISTINCT u1.user_idd, u1.useful
        FROM userr u1, elite e1
        WHERE u1.average_stars >= 2 AND u1.average_stars < 4 AND u1.user_idd in e1.user_idd) g1;

SELECT  AVG(g2.useful) AS high_mark_elite
FROM    (SELECT DISTINCT u2.user_idd, u2.useful
        FROM userr u2, elite e2
        WHERE u2.average_stars >= 4 AND u2.average_stars <= 5 AND u2.user_idd in e2.user_idd) g2;
		
SELECT  AVG(g3.useful) AS low_mark_non_elite
FROM    (SELECT DISTINCT u3.user_idd, u3.useful
        FROM userr u3, elite e3
        WHERE u3.average_stars >= 2 AND u3.average_stars < 4 AND u3.user_idd not in e3.user_idd) g3;
		
SELECT  AVG(g4.useful) AS high_mark_non_elite
FROM    (SELECT DISTINCT u4.user_idd, u4.useful
        FROM userr u4, elite e4
        WHERE u4.average_stars >= 4 AND u4.average_stars <= 5 AND u4.user_idd not in e4.user_idd) g4;
		
/* 5 */
SELECT AVG(b.review_count), AVG(b.business_stars)
FROM BUSINESS b, 
    (SELECT COUNT(c.business_id) AS cat_count, c.business_id
    FROM has_categories C
    GROUP BY c.business_id) C1, 
    (SELECT LENGTH(p.parking_id) - LENGTH(REPLACE(p.parking_id, 'T', '')) AS part_num, p.business_id AS business_id
    FROM has_business_parking P) P1
WHERE b.business_id = c1.business_id AND b.business_id = p1.business_id 
AND c1.cat_count >= 2 AND p1.part_num >= 1;

/* 6 */
SELECT b_sel.cnt/b_all.cnt
FROM (SELECT count(b1.business_id) as cnt
        FROM business b1, suit_good_for_meal s1, meal m1
        WHERE b1.business_id = s1.business_id AND s1.meal_id = m1.meal_id
        AND m1.latenight = 1) b_sel,
    (SELECT count(b2.business_id) as cnt
        FROM business b2) b_all;

/* 7 new*/
SELECT DISTINCT l2.city
FROM locate_2 l2
WHERE l2.city not in (SELECT DISTINCT l1.city
    FROM business_hours h1, locate_2 l1
    WHERE l1.business_id = h1.business_id AND h1.dayy = 7);
	
/* 7 old*/
SELECT DISTINCT l2.city
FROM locate l2
WHERE l2.city not in (SELECT DISTINCT l1.city
    FROM business_hours h1, locate l1
    WHERE l1.business_id = h1.business_id AND h1.dayy = 7);

/* 8 */
SELECT b1.bid as id
FROM (SELECT COUNT(DISTINCT r1.user_idd) as cnt, r1.business_id as bid
        FROM user_create_review_on_business r1
        GROUP BY r1.business_id) b1
WHERE b1.cnt > 1030;

/* 9 */
SELECT *
FROM 	(SELECT b1.namee as BusinessName, b1.review_count as NumberofCount
        FROM business b1, locate l1
        WHERE b1.business_id = l1.business_id AND l1.statee = 'CA'
        ORDER BY b1.business_stars DESC) 
WHERE ROWNUM <= 10;

/* 10 */
SELECT *
FROM
    (SELECT 
        b1.business_id, 
        l1.statee,
        ROW_NUMBER() OVER (
            PARTITION BY l1.statee
            ORDER BY b1.business_stars
        ) rank
    FROM 
        business b1, locate_2 l1
    WHERE 
        b1.business_id = l1.business_id
    ORDER BY 
        l1.statee) b_ordered
WHERE b_ordered.rank <= 10;

/* 11 */
SELECT DISTINCT l2.city
FROM locate_3 l2
WHERE l2.city not in 
    (SELECT DISTINCT l1.city
    FROM locate_3 l1, 
        (SELECT count(r1.business_id) as cnt, r1.business_id
        FROM user_create_review_on_business r1
        GROUP BY r1.business_id) r2
    WHERE l1.business_id = r2.business_id AND r2.cnt<2);


/* 13 */
SELECT *
FROM(
	SELECT COUNT(DISTINCT r1.business_id) as cnt
	FROM user_create_review_on_business r1
	GROUP BY r1.user_idd
	ORDER BY cnt DESC) 
WHERE ROWNUM = 1;

/* 16 correct */
SELECT b1.namee, AVG(r1.staar) AS stars_count, AVG(b1.review_count)
FROM business b1, locate_3 l1, user_create_review_on_business r1, 
    meet_dietary_restrictions m1, diet d1
WHERE b1.business_id = l1.business_id AND r1.business_id = b1.business_id 
    AND b1.business_id = m1.business_id AND l1.city = 'los angeles'
    AND m1.diet_id = d1.diet_id AND d1.vegan = 1 AND d1.vegetarian = 1
GROUP BY b1.namee
ORDER BY stars_count DESC;

/* 16 test */
SELECT b1.namee, AVG(r1.staar) AS stars_count, AVG(b1.review_count)
FROM business b1, locate_2 l1, user_create_review_on_business r1, 
    meet_dietary_restrictions m1, diet d1
WHERE b1.business_id = l1.business_id AND r1.business_id = b1.business_id 
    AND b1.business_id = m1.business_id 
    AND m1.diet_id = d1.diet_id AND d1.vegan = 1 AND d1.vegetarian = 1
GROUP BY b1.namee
ORDER BY stars_count DESC;


/* 17 */

SELECT AVG(b_upscale.avg_star) - AVG(b_divey.avg_star)
FROM (	
    SELECT AVG(r1.staar) as avg_star, r1.business_id
	FROM user_create_review_on_business r1, experience_ambience e1,
		ambience a1
	WHERE r1.business_id = e1.business_id
		AND e1.ambience_id = a1.ambience_id AND a1.upscale = 1
	GROUP BY r1.business_id) b_upscale,
    (SELECT AVG(r2.staar) as avg_star, r2.business_id
	FROM user_create_review_on_business r2, experience_ambience e2,
		ambience a2
	WHERE r2.business_id = e2.business_id
		AND e2.ambience_id = a2.ambience_id AND a2.divey = 1
	GROUP BY r2.business_id) b_divey

/* 18 */
SELECT COUNT(*)
FROM
    (SELECT b1.review_count,
        ROW_NUMBER() OVER (PARTITION BY l1.city ORDER BY b1.review_count DESC) rank
    FROM business b1, locate_3 l1
    WHERE b1.business_id = l1.business_id
    ORDER BY l1.city) b_ordered
WHERE b_ordered.rank = 5 AND b_ordered.review_count > 100;