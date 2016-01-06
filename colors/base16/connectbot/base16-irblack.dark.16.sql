UPDATE colors SET scheme = '' WHERE scheme = 0;

INSERT INTO COLORS (number, value, scheme) VALUES (0  , -16777216 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (1  , -37792 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (2  , -5701792 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (3  , -74 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (4  , -6894594 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (5  , -35843 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (6  , -3750402 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (7  , -4869206 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (8  , -9671578 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (9  , -1458078 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (10 , -14408670 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (11 , -12040124 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (12 , -7237752 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (13 , -2500660 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (14 , -5141955 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (15 , -132114 , 0);

UPDATE colorDefaults set fg=7, bg=0 WHERE scheme = 0;

