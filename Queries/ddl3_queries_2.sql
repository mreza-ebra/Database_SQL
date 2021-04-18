/* 5 */
SELECT AVG(B.review_count), AVG(B.business_stars) 
FROM Business B, has_business_parking H, Parking P, (SELECT COUNT(c.business_id) AS cat_count, c.business_id
                                                     FROM has_categories C 
                                                     GROUP BY c.business_id) C1
WHERE C1.cat_count >= 2 AND B.business_id = H.business_id AND H.parking_id = P.parking_id AND 
	B.business_id = C1.business_id AND REGEXP_COUNT (P.parking_id, 'T') >= 1;
				
/* 6 */
SELECT B2.cnt/B1.cnt as Ratio
FROM (SELECT COUNT(B.business_id) as cnt
      FROM Business B) B1, (SELECT COUNT(B.business_id) as cnt
                            FROM suit_good_for_meal S, Meal M,Business B
                            WHERE B.business_id = S.business_id AND M.meal_id = S.meal_id AND M.latenight = 1) B2;

/* 7 */
SELECT DISTINCT(L2.city)
FROM (SELECT L.city
	  FROM locate_3 L, Business_hours H 
	  WHERE H.dayy <> 7 AND L.business_id = H.business_id) L2
GROUP BY L2.city
ORDER By L2.city;

/* 7 */
SELECT L2.city
FROM (SELECT L.city
	  FROM locate L, Business_hours H 
	  WHERE H.dayy <> 7 AND L.business_id = H.business_id) L2
GROUP BY L2.city
ORDER By L2.city;

/* 8 Verified*/
SELECT U.business_id, COUNT(DISTINCT U.user_idd) AS uniqe_ids
FROM user_create_review_on_business U
GROUP BY U.Business_id
HAVING COUNT(DISTINCT U.user_idd) > 1030;

/* 9 */
SELECT *
FROM (SELECT B.business_id, B.namee, B.business_stars
      FROM Business B, locate_3 L
      WHERE L.statee = 'ca' AND L.business_id = B.business_id
      ORDER BY B.business_stars DESC)
WHERE ROWNUM <= 10;

/* 9 */
SELECT *
FROM (SELECT B.business_id, B.namee, B.business_stars
      FROM Business B, locate L
      WHERE L.statee = 'CA' AND L.business_id = B.business_id
      ORDER BY B.business_stars DESC)
WHERE ROWNUM <= 10;

/* 10 */
SELECT *
FROM (SELECT B.business_id, L.statee, B.business_stars, 
      ROW_NUMBER() OVER(PARTITION BY L.statee ORDER BY B.business_stars DESC) AS b_rank
      FROM locate_3 L, Business B
      WHERE L.business_id = B.business_id) T
WHERE T.b_rank <= 10;

SELECT *
FROM (SELECT B.business_id, L.statee, B.business_stars, 
      ROW_NUMBER() OVER(PARTITION BY L.statee ORDER BY B.business_stars DESC) AS b_rank
      FROM locate L, Business B
      WHERE L.business_id = B.business_id) T
WHERE T.b_rank <= 10;



/* 11 */
SELECT L.city
FROM locate_2 L, (SELECT B.business_id
				  FROM Business B
				  WHERE B.review_count > 1) B2
WHERE B2.business_id = L.business_id
GROUP BY L.city;

/* 11 Alterntive Not use this */
SELECT DISTINCT(L.city)
FROM locate_3 L, Business B, (SELECT C.business_id as idd
                              FROM USER_CREATE_REVIEW_ON_BUSINESS C
                              GROUP BY C.business_id
                              HAVING COUNT(C.business_id) >= 2) U
WHERE B.business_id = L.business_id AND U.idd = B.business_id;


                  
/* 12 */
SELECT COUNT(DISTINCT(R.idd))
FROM (SELECT T.business_id as idd 
	  FROM tip T
	  WHERE INSTR(T.tip_text, 'awesome') > 0) R,
     (SELECT T1.business_id as idd
      FROM TIP T1, TIP T2
      WHERE T1.user_idd = T2.user_idd AND (T1.datee - T2.datee) <= 1 AND 
     (T1.datee - T2.datee) > 0 AND T1.tip_text <> T2.tip_text) P
WHERE R.idd = P.idd;

SELECT *
FROM TIP T1, TIP T2
WHERE T1.user_idd = T2.user_idd AND (T1.datee - T2.datee) <= 1 AND 
(T1.datee - T2.datee) > 0 AND T1.tip_text <> T2.tip_text;
                        
/* 13*/
SELECt *
    FROM(SELECT U.user_idd, COUNT(DISTINCT(U.business_id)) as cnt
    FROM user_create_review_on_business U
    GROUP BY U.user_idd
    ORDER BY cnt DESC)
    WHERE ROWNUM = 1;

SELECT DISTINCT U.business_id, user_idd 
FROM user_create_review_on_business U;
      
/* 14 */
SELECT R1.elite_avg - R2.non_elite_avg as average_diff
FROM (SELECT AVG(R.useful) as elite_avg  
      FROM USER_CREATE_REVIEW_ON_BUSINESS R, Elite E
      WHERE R.user_idd = E.user_idd) R1, 
     (SELECT AVG(R.useful) as non_elite_avg
      FROM USER_CREATE_REVIEW_ON_BUSINESS R
      MINUS
      SELECT R2.useful  
      FROM USER_CREATE_REVIEW_ON_BUSINESS R2, Elite E
      WHERE R2.user_idd = E.user_idd) R2;

SELECT AVG(R.useful) as elite_avg  
FROM USER_CREATE_REVIEW_ON_BUSINESS R, Elite E
WHERE R.user_idd = E.user_idd;

SELECT AVG(R.useful) as non_elite_avg
FROM USER_CREATE_REVIEW_ON_BUSINESS R
MINUS
SELECT R2.useful  
FROM USER_CREATE_REVIEW_ON_BUSINESS R2, Elite E
WHERE R2.user_idd = E.user_idd;
      
/* 15 */
SELECT DISTINCT(B.namee)
FROM  Business B, Meal M, suit_good_for_meal S, business_hours H,
						(SELECT DISTINCT(R.business_id), PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY R.staar DESC)OVER(PARTITION BY R.business_id ) AS median_star
                         FROM USER_CREATE_REVIEW_ON_BUSINESS R) T	
WHERE T.business_id = B.business_id AND H.business_id = B.business_id AND  
	  S.business_id = B.business_id  AND S.meal_id = M.meal_id AND 
	  B.openn = 1 AND T.median_star >= 4.5 AND M.brunch = 1 AND 
	  (H.dayy = 7 OR H.dayy = 6);
      
SELECT DISTINCT(R.business_id), PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY R.staar DESC)OVER (PARTITION BY R.business_id ) AS median_star
FROM USER_CREATE_REVIEW_ON_BUSINESS R
ORDER BY PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY R.staar DESC)OVER (PARTITION BY R.business_id) DESC;

/* 18 , C.rev_cnt, C.b_rank*/
SELECT C.cname, C.rev_cnt, C.b_rank
FROM (SELECT L.city as cname, B.review_count as rev_cnt, ROW_NUMBER() OVER(PARTITION BY L.city ORDER BY B.review_count DESC) AS b_rank
      FROM locate L, Business B
      WHERE L.business_id = B.business_id AND B.review_count >= 100) C,
     (SELECT L.city as cname, count(L.city) as cnt
      FROM locate L
      GROUP BY L.city
      HAVING count(L.city) >= 5
      ORDER BY count(L.city)) S
WHERE C.cname = S.cname AND C.b_rank <= 5;

SELECT L.city as cname, count(L.city) as cnt
FROM locate L
GROUP BY L.city
HAVING count(L.city) >= 5
ORDER BY count(L.city);

/* 19 WITH dept_count AS (
  SELECT deptno, COUNT(*) AS dept_count
  FROM   emp
  GROUP BY deptno)*/
WITH ranked_table AS (SELECT L.city as cname, B.review_count as rev_cnt, ROW_NUMBER() OVER(PARTITION BY L.city ORDER BY B.review_count DESC) AS b_rank
FROM locate_2 L, Business B
WHERE L.business_id = B.business_id)
SELECT RT.cname
FROM ranked_table RT
WHERE cnt IN (SELECT SUM(RT.rev_cnt) as cnt
              FROM ranked_table RT);

SELECT L.city as cname, B.review_count as rev_cnt, ROW_NUMBER() OVER(PARTITION BY L.city ORDER BY B.review_count DESC) AS b_rank
FROM locate_2 L, Business B
WHERE L.business_id = B.business_id;

/* 20 */
SELECT *
FROM (SELECT R.user_idd as user_idd, B.review_count as rev_cnt, ROW_NUMBER() OVER(PARTITION BY B.business_id ORDER BY B.review_count DESC) AS b_rank
      FROM USER_CREATE_REVIEW_ON_BUSINESS R, Business B
      WHERE R.business_id = B.business_id) C;
      
SELECT R.user_idd as user_idd, B.review_count as rev_cnt, ROW_NUMBER() OVER(PARTITION BY B.review_count ORDER BY B.review_count DESC) AS b_rank, R.business_id as bid
FROM USER_CREATE_REVIEW_ON_BUSINESS R, Business B
WHERE R.business_id = B.business_id;

SELECT *
FROM (SELECT C.bid 
      FROM (SELECT B.business_id as bid, B.review_count, ROW_NUMBER() OVER(ORDER BY B.review_count DESC) AS b_rank
            FROM Business B) C
            WHERE C.b_rank <= 10) BusinessTop,
           (SELECT R.user_idd, T.bid, ROW_NUMBER() OVER(PARTITION BY T.business_id ORDER BY COUNT(R.user_idd) DESC) AS u_rank
            FROM BusinessTop T, USER_CREATE_REVIEW_ON_BUSINESS R
            WHERE T.bid = R.business_id) U
WHERE U.u_rank <= 3;

SELECT R.user_idd, COUNT(User_idd) as cnt, R.business_id
FROM USER_CREATE_REVIEW_ON_BUSINESS R
GROUP BY R.user_idd, R.business_id;

SELECT C.bid 
      FROM (SELECT B.business_id as bid, B.review_count, ROW_NUMBER() OVER(ORDER BY B.review_count DESC) AS b_rank
            FROM Business B) C
            WHERE C.b_rank <= 10;
            
WITH dept_count AS (
  SELECT deptno, COUNT(*) AS dept_count
  FROM   emp
  GROUP BY deptno)
SELECT e.ename AS employee_name,
       dc1.dept_count AS emp_dept_count,
       m.ename AS manager_name,
       dc2.dept_count AS mgr_dept_count
FROM   emp e,
       dept_count dc1,
       emp m,
       dept_count dc2
WHERE  e.deptno = dc1.deptno
AND    e.mgr = m.empno
AND    m.deptno = dc2.deptno;
