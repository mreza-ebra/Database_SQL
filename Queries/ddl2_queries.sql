/* 1 */
SELECT AVG(U.review_count) 
FROM Userr U;

/* 2 */
SELECT COUNT(L.business_id) 
FROM locate_2 L
WHERE L.statee = 'qc' OR L.statee = 'ab';

SELECT COUNT(L.business_id) 
FROM locate L
WHERE L.statee = 'QC' OR L.statee = 'AB';

/*3 to be verified*/
SELECT B.business_id,B.namee, H2.nc
FROM Business B, (SELECT H.business_id, count(H.business_id) as nc
                  FROM has_categories H
                  GROUP BY H.business_id
                  order by count(H.business_id) DESC) H2
WHERE B.business_id = H2.business_id AND ROWNUM = 1;

/* 4 */
SELECT COUNT(DISTINCT H.business_id) 
FROM has_categories H
WHERE H.labell = 'DryCleaners' OR H.labell = 'DryCleaning';

/* 5*/
SELECT B.business_id, B.review_count 
FROM Business B, meet_dietary_restrictions M, Diet D
WHERE B.review_count > 150 AND B.business_id = M.business_id AND M.diet_id = D.diet_id
      AND REGEXP_COUNT (M.diet_id, 'T') >= 2;

/* 6 */
SELECT F.user_id1, F.fr_cnt
FROM (SELECT F2.user_id1, COUNT(F2.user_id1) as fr_cnt
      FROM Friends F2
      GROUP BY F2.user_id1
      ORDER BY COUNT(F2.user_id1) DESC) F
WHERE ROWNUM <= 10;

/* 7 */
SELECT B.namee, B.business_stars, B.review_count 
FROM locate L, Business B
WHERE B.business_id = L.business_id AND L.city = 'San Diego' AND B.openn = 1
ORDER BY B.review_count DESC;

/* 8 Verified*/
SELECT L.statee, L.cnt 
FROM (SELECT L2.statee, COUNT(L2.statee) as cnt
      FROM locate_2 L2
      GROUP BY L2.statee
      ORDER BY COUNT(L2.statee) DESC) L
WHERE ROWNUM = 1;
      
/* 9 Verified*/
SELECT AVG(U.average_stars) AS total_average, E.start_year 
FROM Userr U, (SELECT MIN(E1.yearr) as start_year, E1.user_idd 
			   FROM Elite E1
			   GROUP BY E1.user_idd) E
WHERE U.user_idd = E.user_idd
GROUP BY E.start_year
ORDER BY E.start_year;

/* 10 to be verified*/
SELECT B.namee, (PERCENTILE_DISC(0.5)
                 WITHIN GROUP (ORDER BY R.staar )
                 OVER (PARTITION BY R.business_id )) AS median_star
FROM Business B, user_create_review_on_business R, locate L 
WHERE B.openn = 1 AND L.city = 'New York' AND B.business_id = R.business_id 
	  AND B.business_id = L.business_id /* conditions */    
ORDER BY median_star; /* VERIFIED final table should be ordered by medain_star */

SELECT*
FROM(SELECT DISTINCT B.namee, PERCENTILE_DISC(0.5) /* median review of each business */
						WITHIN GROUP (ORDER BY R.staar ) /* order by start rating */
						OVER (PARTITION BY R.business_id ) AS median_star
    FROM Business B, user_create_review_on_business R, locate_2 L 
    WHERE B.openn = 1 AND L.statee = 'ny' AND B.business_id = R.business_id 
        AND B.business_id = L.business_id /* conditions */
    ORDER BY median_star DESC) /* final table should be ordered by medain_star */
WHERE ROWNUM <= 10;


/* 11 */
SELECT AVG(N.cnt) AS mean, MAX(N.cnt) AS maximum, MIN(N.cnt) AS minimum     
FROM (SELECT H.business_id, COUNT(H.business_id) AS cnt 
	  FROM has_categories H
	  GROUP BY H.business_id) N; /* N is the new table grouped by id and sorted by repitition */

SELECT AVG(N.cnt) AS mean, MAX(N.cnt) AS maximum, MIN(N.cnt) AS minimum, 
    percentile_disc(0.5) within group (order by N.cnt) as median    
FROM (SELECT H.business_id, COUNT(H.business_id) AS cnt 
	  FROM has_categories H
	  GROUP BY H.business_id) N;

/* 12 verified */
SELECT B.namee AS Name, B.business_stars AS Stars, B.review_count AS Reveiews 
FROM Business B, Parking P, has_business_parking H, business_hours T, locate_2 L
WHERE B.business_id = H.business_id AND T.business_id = B.business_id 
	AND L.business_id = B.business_id AND H.parking_id = P.parking_id 
	AND P.valet = 1 AND L.city = 'las vegas' AND T.dayy = 5 /* Friday */
	AND T.fromm <= 19 AND (T.too >= 23 OR T.too = 0);



