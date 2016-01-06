UPDATE colors SET scheme = '' WHERE scheme = 0;

INSERT INTO COLORS (number, value, scheme) VALUES (0  , -15262695 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (1  , -5152455 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (2  , -12019357 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (3  , -6259141 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (4  , -12088176 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (5  , -11172453 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (6  , -14902624 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (7  , -7892342 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (8  , -10523292 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (9  , -6328004 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (10 , -14472667 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (11 , -11378601 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (12 , -8878211 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (13 , -2103326 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (14 , -7965591 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (15 , -1248018 , 0);

UPDATE colorDefaults set fg=11, bg=15 WHERE scheme = 0;

