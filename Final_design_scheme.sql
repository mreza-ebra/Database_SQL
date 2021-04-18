CREATE TABLE Userr( /* YAO DONE*/
	namee VARCHAR(55) NOT NULL,
	yelping_since DATE NOT NULL,
	user_idd VARCHAR(25), 
	fans INTEGER NOT NULL, 
	review_count INTEGER, 
	cool INTEGER, 
	funny INTEGER, 
	useful INTEGER,
	comp_cool INTEGER, 
	comp_cute INTEGER, 
	com_funny INTEGER, 
	comp_hot INTEGER,
	comp_list INTEGER, 
	comp_more INTEGER, 
	comp_note INTEGER, 
	comp_photos INTEGER, 
	comp_plain INTEGER, 
	comp_profile INTEGER , 
	comp_writer INTEGER, 
	average_stars FLOAT, 
	PRIMARY KEY (user_idd)
); 

CREATE TABLE Elite( /* YAO DONE */
	yearr INTEGER,
    user_idd VARCHAR(25),
    PRIMARY KEY (user_idd, yearr), 
    FOREIGN KEY (user_idd) REFERENCES Userr
); 

CREATE TABLE Friends( /* YAO DONE*/ /* YASSMINE */
    user_id1 VARCHAR(25), 
    user_id2 VARCHAR(25), 
    PRIMARY KEY (user_id1, user_id2),  
    FOREIGN KEY (user_id1) REFERENCES Userr(user_idd)
); 


CREATE TABLE Business( /* YAO DONE */
    business_id VARCHAR(25), 
    namee VARCHAR(100) NOT NULL , 
    review_count INTEGER,
    business_stars FLOAT,
    openn INTEGER, 
    PRIMARY KEY (business_id)
);


CREATE TABLE locate( /* YAO DONE */
	address VARCHAR(120),
	city VARCHAR(50), 
	statee VARCHAR(5), 
	postal_code VARCHAR(10), 
	latitude FLOAT, 
	longitude FLOAT,
	business_id VARCHAR(25),
	PRIMARY KEY (business_id),
	FOREIGN KEY (business_id) REFERENCES Business
);

/*CREATE TABLE hours_key_table(
    hours_key VARCHAR(10), 
    dayy INTEGER , 
    fromm CHAR(4) , 
    too CHAR(4) ,
    PRIMARY KEY (hours_key,dayy,fromm), 
    FOREIGN KEY (dayy, fromm, too) REFERENCES business_hours
);*/

CREATE TABLE business_hours( /* YASSMINE DONE*/
	dayy INTEGER,
    fromm FLOAT, 
    too FLOAT,
	business_id VARCHAR(25),
    PRIMARY KEY (business_id, dayy, fromm, too),  
    CONSTRAINT CHK_DAY CHECK (dayy>=1 AND dayy<=7),
	FOREIGN KEY (business_id) REFERENCES Business
) ; 

CREATE TABLE has_business_parking( /* YASSMINE DONE*/
	parking_id CHAR(5), 
    business_id VARCHAR(25), 
    PRIMARY KEY (business_id), 
    FOREIGN KEY (business_id) REFERENCES Business,
	FOREIGN KEY (parking_id) REFERENCES Parking
);

CREATE TABLE Parking( /* YASSMINE DONE*/
	parking_id CHAR(5),
    garage INTEGER, 
    street INTEGER, 
    validated INTEGER, 
    lot INTEGER, 
    valet INTEGER,  
    UNIQUE (garage,street,validated,lot,valet),
	PRIMARY KEY (parking_id) /*64*/
);

CREATE TABLE suit_good_for_meal(/* YASSMINE DONE */
    meal_id CHAR(6),
	business_id VARCHAR(25),
    PRIMARY KEY (business_id), 
    FOREIGN KEY (business_id) REFERENCES Business,
	FOREIGN KEY (meal_id) REFERENCES Meal
);

CREATE TABLE Meal(/* YASSMINE DONE */
	meal_id CHAR(6),
    dessert INTEGER, 
    latenight INTEGER, 
    lunch INTEGER, 
    dinner INTEGER, 
    brunch INTEGER, 
    breakfast INTEGER,  
    UNIQUE (dessert, latenight, lunch, dinner, brunch, breakfast),
	PRIMARY KEY(meal_id)
);

CREATE TABLE experience_ambiance(/* YASSMINE DONE */
    ambience_id CHAR(9),
    business_id VARCHAR(25), 
    PRIMARY KEY (business_id), 
    FOREIGN KEY (business_id) REFERENCES Business,
	FOREIGN KEY (ambiance_id) REFERENCES Ambiance
);

CREATE TABLE Ambience(/* YASSMINE DONE */
    ambience_id CHAR(9),
	romantic INTEGER, 
    intimate INTEGER, 
    classy INTEGER, 
    hipster INTEGER, 
    divey INTEGER, 
    touristy INTEGER,
    trendy INTEGER, 
    upscale INTEGER, 
    casual INTEGER, 
    UNIQUE (romantic, intimate, classy, hipster, divey, touristy, trendy, upscale, casual),
	PRIMARY KEY(ambiance_id)
);

CREATE TABLE sound_noise_level(/* YASSMINE DONE */ /* already one integer */
    noise_level INTEGER, 
    business_id VARCHAR(25), 
    PRIMARY KEY (business_id), 
    FOREIGN KEY (business_id) REFERENCES Business
);


CREATE TABLE play_music(/* YASSMINE DONE */
    music_id CHAR(7), 
    business_id VARCHAR(25), 
    PRIMARY KEY (business_id), 
    FOREIGN KEY (business_id) REFERENCES Business,
	FOREIGN KEY (music_id) REFERENCES Music
);

CREATE TABLE Music(/* YASSMINE DONE */
    music_id CHAR(7),
	dj INTEGER, 
    background_music INTEGER, 
    no_music INTEGER, 
    jukebox INTEGER, 
    live INTEGER, 
    video INTEGER, 
    karaoke INTEGER, 
    UNIQUE (dj, background_music, no_music, jukebox, live, video, karaoke),
	PRIMARY KEY (music_id)
);

CREATE TABLE meet_dietary_restrictions(/* YASSMINE DONE */
    diet_id CHAR(7), 
    business_id VARCHAR(25), 
    PRIMARY KEY (business_id), 
    FOREIGN KEY (business_id) REFERENCES Business,
	FOREIGN KEY (diet_id) REFERENCES Diet
);

CREATE TABLE Diet(/* YASSMINE DONE */
    diet_id CHAR(7),
	dairy_free INTEGER, 
    gluten_free INTEGER, 
    vegan INTEGER, 
    kosher INTEGER, 
    halal INTEGER, 
    soy_free INTEGER, 
    vegetarian INTEGER, 
    UNIQUE (dairy_free,gluten_free, vegan, kosher, halal, soy_free, vegetarian),
	PRIMARY KEY (diet_id)
);

CREATE TABLE user_create_review_on_business(/* YASSMINE */ /* YAO DONE */
    review_id VARCHAR(25), 
    review_text VARCHAR(120),
    staar INTEGER,
    datee DATE, 
    cool INTEGER, 
    funny INTEGER, 
    useful INTEGER, 
    business_id VARCHAR(25), 
    user_idd VARCHAR(25), 
    PRIMARY KEY (review_id),
    FOREIGN KEY (business_id) REFERENCES Business, 
    FOREIGN KEY (user_idd) REFERENCES Userr,
    UNIQUE (review_id)   
);

CREATE TABLE tip(/* YAO DONE*/
    business_id VARCHAR(25), 
    user_idd VARCHAR(25), 
    comp_count INTEGER, 
    datee DATE, 
    tip_text VARCHAR(500), 
    PRIMARY KEY (business_id, user_idd, review_text),
    FOREIGN KEY (user_idd) REFERENCES Userr, 
    FOREIGN KEY (business_id) REFERENCES Business
);

CREATE TABLE category_labels(/* YAO DONE */ /* still beleive we can get rid of it*/ 
	labell VARCHAR(40),
	PRIMARY KEY (labell) /*each one is a single label*/
);

CREATE TABLE has_categories(/* YAO DONE */
    business_id VARCHAR(25),
    labell VARCHAR(40),
    PRIMARY KEY (business_id, labell),
    FOREIGN KEY (business_id) REFERENCES Business,
	FOREIGN KEY (labell) REFERENCES category_labels
);

