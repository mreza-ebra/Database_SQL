---11---
SELECT city FROM (SELECT city from locate_2) minus (SELECT t2.city from (SELECT business_review_count.business_id, business_review_count.business_count, business_location.city from (SELECT business_id, COUNT(business_id) as business_count from user_create_review_on_business GROUP by business_id)business_review_count
FULL JOIN locate_2 business_location on business_location.business_id = business_review_count.business_id 
WHERE business_review_count.business_id is not null and business_count is not null and city is not null and business_location.business_id is not null and  business_count>=2)t1 
FULL JOIN (SELECT business_review_count.business_id, business_review_count.business_count, business_location.city from (SELECT business_id, COUNT(business_id) as business_count from user_create_review_on_business GROUP by business_id)business_review_count
FULL JOIN locate_2 business_location on business_location.business_id = business_review_count.business_id 
WHERE business_review_count.business_id is not null and business_count is not null and city is not null and business_location.business_id is not null)t2 ON t1.business_id = t2.business_id 
WHERE t1.city is null)  ; 

---12---
--???--Still not done yet 

---13---

SELECT MAX(cid) FROM (SELECT user_idd, COUNT(user_idd) cid FROM (SELECT user_idd, business_id FROM user_create_review_on_business group by user_idd, business_id) GROUP BY user_idd)t;

---14---

SELECT (SELECT AVG(USEFUL) from (SELECT review_id, useful FROM (SELECT e.yearr, e.user_idd as elite_uid, review.useful, review.user_idd, review.datee, review.review_id FROM ELITE e  RIGHT JOIN user_create_review_on_business review ON (e.user_idd = review.user_idd AND e.yearr = EXTRACT(year from review.datee)))t WHERE yearr is not null GROUP BY review_id, useful ) 
) - (SELECT AVG(USEFUL) from (SELECT review_id, useful FROM (SELECT e.yearr, e.user_idd as elite_uid, review.useful, review.user_idd, review.datee, review.review_id FROM ELITE e  RIGHT JOIN user_create_review_on_business review ON (e.user_idd = review.user_idd AND e.yearr = EXTRACT(year from review.datee)))t WHERE yearr is null GROUP BY review_id, useful) 
) FROM DUAL ; 


---15---

SELECT business_id, MEDIAN(staar) FROM (SELECT sgfm.meal_id, sgfm.business_id, bh.dayy, user_review.staar, b.openn  
FROM suit_good_for_meal sgfm 
LEFT OUTER JOIN business_hours bh ON sgfm.business_id = bh.business_id 
LEFT OUTER JOIN business b ON b.business_id = sgfm.business_id 
LEFT OUTER JOIN user_create_review_on_business user_review ON user_review.business_id = sgfm.business_id
WHERE (dayy = 6 or dayy = 7) AND meal_id  LIKE '____T_' AND openn = 1 )t GROUP BY business_id HAVING MEDIAN(staar) >= 4.5; 

---16---

SELECT * from ((SELECT business_id, AVG(staar) from user_create_review_on_business GROUP BY business_id)t LEFT OUTER JOIN BUSINESS b 
ON b.business_id = t.business_id 
RIGHT OUTER JOIN BUSINESS_HOURS bh ON bh.business_id = b.business_id
RIGHT OUTER JOIN meet_dietary_restrictions mdr ON mdr.business_id = b.business_id
RIGHT OUTER JOIN locate_2 location ON location.business_id = b.business_id) 
WHERE fromm<14 AND too>=16 AND (diet_id LIKE '__T___T') AND city = 'los angeles' ; 

---17---

SELECT (SELECT AVG(average_staar) from (SELECT sgfm.business_id, sgfm.meal_id, business_ambiance.ambience_id, t.average_staar FROM suit_good_for_meal sgfm  
FULL JOIN experience_ambience business_ambiance ON sgfm.business_id = business_ambiance.business_id 
FULL JOIN (SELECT business_id, AVG(staar) as average_staar from user_create_review_on_business business_review GROUP BY business_id)t ON t.business_id =sgfm.business_id
WHERE meal_id LIKE '___T__' AND ambience_id LIKE '_______T_'  and meal_id is not null and ambience_id is not null and average_staar is not null) ) - (SELECT AVG(average_staar) from (SELECT sgfm.business_id, sgfm.meal_id, business_ambiance.ambience_id, t.average_staar FROM suit_good_for_meal sgfm  
FULL JOIN experience_ambience business_ambiance ON sgfm.business_id = business_ambiance.business_id 
FULL JOIN (SELECT business_id, AVG(staar) as average_staar from user_create_review_on_business business_review GROUP BY business_id)t ON t.business_id =sgfm.business_id
WHERE meal_id LIKE '___T__' AND ambience_id LIKE '____T____' and meal_id is not null and ambience_id is not null and average_staar is not null)) from DUAL ;  

---18---

SELECT * from (SELECT city, COUNT(city) as count_city from (SELECT business_review_with_count.business_id, business_review_with_count.count_reviews, business_location.city from (SELECT business_id,  COUNT(business_id) as count_reviews from user_create_review_on_business GROUP BY business_id) business_review_with_count
FULL JOIN locate_2 business_location ON business_location.business_id = business_review_with_count.business_id
 where count_reviews>=100 AND city is not null and count_reviews is not null) GROUP BY city) where count_city >=5;
 
---19---
 
 SELECT t1.city, t1.sum_top_ten, t2.sum_all from(SELECT city, SUM(review_count) sum_top_ten from (SELECT * from (SELECT l.city, b.business_id, b.review_count, ROW_NUMBER() OVER(
			PARTITION BY l.city
            ORDER BY b.review_count DESC
			) as rankk 
	FROM 
		locate_2 l, business b WHERE l.business_id = b.business_id) where rankk <= 100) GROUP BY city)t1, 
        (SELECT city, SUM(review_count) sum_all from business b, locate_2 l where l.business_id = b.business_id group by city)t2 WHERE t1.city = t2.city and
        3*t1.sum_top_ten>2*t2.sum_all;
        
---20---

SELECT * from (SELECT business_id, user_idd, ROW_NUMBER() OVER(
			PARTITION BY business_id
            ORDER BY user_count DESC
			) as rankk  from (SELECT t.business_id, t.review_count, u.user_idd, r.user_count from (SELECT * from(SELECT r.business_id, COUNT(r.business_id) as review_count from user_create_review_on_business r GROUP BY business_id ORDER BY review_count DESC)t  WHERE rownum<=10)t,
user_create_review_on_business u, (SELECT user_idd, COUNT(user_idd)user_count from user_create_review_on_business GROUP BY user_idd)r where u.business_id = t.business_id and u.user_idd =r.user_idd)) where rankk <=3  ; 
        
 
 