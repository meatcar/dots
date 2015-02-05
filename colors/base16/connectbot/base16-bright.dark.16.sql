UPDATE colors SET scheme = '' WHERE scheme = 0;

INSERT INTO COLORS (number, value, scheme) VALUES (0  , -16777216 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (1  , -327392 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (2  , -6175143 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (3  , -154831 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (4  , -9456686 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (5  , -2915901 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (6  , -8992841 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (7  , -2039584 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (8  , -5197648 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (9  , -234204 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (10 , -13619152 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (11 , -11513776 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (12 , -3092272 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (13 , -657931 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (14 , -4299716 , 0);
INSERT INTO COLORS (number, value, scheme) VALUES (15 , -1 , 0);

UPDATE colorDefaults set fg=7, bg=0 WHERE scheme = 0;

