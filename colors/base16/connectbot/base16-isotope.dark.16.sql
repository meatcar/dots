UPDATE colors SET scheme = '' WHERE scheme = 0;

INSERT INTO COLORS (number, value, scheme) VALUES (0  , -16777216 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (1  , -65536 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (2  , -13369600 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (3  , -65383 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (4  , -16750849 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (5  , -3407617 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (6  , -16711681 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (7  , -3092272 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (8  , -8355712 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (9  , -26368 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (10 , -12566464 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (11 , -10461088 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (12 , -4144960 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (13 , -2039584 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (14 , -13434625 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (15 , -1 , 0);

UPDATE colorDefaults set fg=7, bg=0 WHERE scheme = 0;

