UPDATE colors SET scheme = '' WHERE scheme = 0;

INSERT INTO COLORS (number, value, scheme) VALUES (0  , -16777216 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (1  , -1495249 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (2  , -15804359 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (3  , -2237165 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (4  , -12891933 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (5  , -420126 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (6  , -14422566 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (7  , -5526613 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (8  , -13355980 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (9  , -2059192 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (10 , -16514044 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (11 , -15720427 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (12 , -11184811 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (13 , -2039584 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (14 , -9874387 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (15 , -394759 , 0);

UPDATE colorDefaults set fg=11, bg=15 WHERE scheme = 0;

