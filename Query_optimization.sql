DROP INDEX review_index;
DROP INDEX star_index;
create index star_index on Business (business_stars);
create index review_index on Business (business_stars);
SELECT COUNT(B.BUSINESS_ID)
FROM BUSINESS B, Locate_3 L
WHERE b.review_count > 5 AND b.business_stars > 4.2 
	AND l.business_id = b.business_id AND l.statee = 'on';

explain plan for SELECT L.city
FROM locate_3 L, (SELECT B.business_id
				  FROM Business B
				  WHERE B.review_count > 1) B2
WHERE B2.business_id = L.business_id
GROUP BY L.city;

create index uid_index on user_create_review_on_business (user_idd);
drop index idx_city;
explain plan for SELECT COUNT(*)
FROM
    (SELECT b1.review_count,
        ROW_NUMBER() OVER (PARTITION BY l1.city ORDER BY b1.review_count DESC) rank
    FROM business b1, locate_3 l1
    WHERE b1.business_id = l1.business_id
    ORDER BY l1.city) b_ordered
WHERE b_ordered.rank = 5 AND b_ordered.review_count > 100;
    
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);