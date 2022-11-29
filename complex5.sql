/* INSERT DATA IN USER_T */
INSERT INTO user_t (USER_ID, PASSWORD, FIRST_NAME, LAST_NAME, DEPARTMENT, TOTAL_CREDIT, YEAR, ROLE) 
      VALUES ('63070503405', 'Chayathit3405_', 'Chayathit', 'Rattanapokil', 'Computer Engineering', 0, 1, 'Student');
INSERT INTO user_t (USER_ID, PASSWORD, NATIONAL_ID, FIRST_NAME, LAST_NAME, DEPARTMENT, TOTAL_CREDIT, YEAR, ROLE) 
      VALUES ('63070503461', 'Kunnithi', '1234567891011', 'Kunnithi', 'Treecharoensomboon', 'Computer Engineering', 0, 1, 'Student');

/* INSERT DATA IN ENROLLMENT */
INSERT INTO enrollment (ENROLLMENT_ID, USER_ID, TOTAL_PRICE, PAYMENT_STATUS, SEMESTER, ACADEMIC_YEAR) VALUES ('6307050340512563', '63070503405', 56000, 1, 1, 2563);
INSERT INTO enrollment (ENROLLMENT_ID, USER_ID, TOTAL_PRICE, PAYMENT_STATUS, SEMESTER, ACADEMIC_YEAR) VALUES ('6307050346112563', '63070503461', 56000, 1, 1, 2563);

/* INSERT DATA IN PRICE_COURSE */
INSERT INTO price_course (Price_Rate_ID, CREDIT, PRICE) VALUES ('PR12000', 1, 2000);
INSERT INTO price_course (Price_Rate_ID, CREDIT, PRICE) VALUES ('PR36000', 3, 6000);

/* INSERT DATA IN COURSE TABLE */
INSERT INTO course (COURSE_CODE, COURSE_TITLE, PRICE_RATE_ID) VALUES ('CPE213', 'Data Models', 'PR36000');
INSERT INTO course (COURSE_CODE, COURSE_TITLE, PRICE_RATE_ID) VALUES ('CPE231', 'Database Systems', 'PR36000');
INSERT INTO course (COURSE_CODE, COURSE_TITLE, PRICE_RATE_ID) VALUES ('CPE224', 'Computer Achitectures', 'PR36000');
INSERT INTO course (COURSE_CODE, COURSE_TITLE, PRICE_RATE_ID) VALUES ('GEN111', 'Man and Ethics of Living', 'PR12000');

/* INSERT DATA IN SECTION TABLE */
INSERT INTO section (SECTION_CODE, COURSE_CODE, MAX_STUDENT, DAY, STRAT_TIME) VALUES ('CPE213_31', 'CPE213', 55, 'Monday', TIME'08:30');
INSERT INTO section (SECTION_CODE, COURSE_CODE, MAX_STUDENT, DAY, STRAT_TIME) VALUES ('CPE231_31', 'CPE231', 27, 'Monday', TIME'13:30');
INSERT INTO section (SECTION_CODE, COURSE_CODE, MAX_STUDENT, DAY, STRAT_TIME) VALUES ('CPE231_32', 'CPE231', 28, 'Monday', TIME'13:30');
INSERT INTO section (SECTION_CODE, COURSE_CODE, MAX_STUDENT, DAY, STRAT_TIME) VALUES ('CPE224_31', 'CPE224', 56, 'Tuesday', TIME'08:30');
INSERT INTO section (SECTION_CODE, COURSE_CODE, MAX_STUDENT, DAY, STRAT_TIME) VALUES ('GEN111_33', 'GEN111', 44, 'Wednesday', TIME'13:30');

/* INSERT DATA IN ENROLLED_SECTION */
INSERT INTO enrolled_section (ENROLLMENT_ID, SECTION_CODE, GRADE) VALUES ('6307050340512563', 'CPE213_31', 4);
INSERT INTO enrolled_section (ENROLLMENT_ID, SECTION_CODE, GRADE) VALUES ('6307050340512563', 'CPE231_31', 3.5);
INSERT INTO enrolled_section (ENROLLMENT_ID, SECTION_CODE) VALUES ('6307050340512563', 'CPE224_31');
INSERT INTO enrolled_section (ENROLLMENT_ID, SECTION_CODE, GRADE) VALUES ('6307050340512563', 'GEN111_33', 4);
INSERT INTO enrolled_section (ENROLLMENT_ID, SECTION_CODE, GRADE) VALUES ('6307050346112563', 'CPE213_31', 4);
INSERT INTO enrolled_section (ENROLLMENT_ID, SECTION_CODE, GRADE) VALUES ('6307050346112563', 'CPE231_32', 4);
INSERT INTO enrolled_section (ENROLLMENT_ID, SECTION_CODE) VALUES ('6307050346112563', 'CPE224_31');
INSERT INTO enrolled_section (ENROLLMENT_ID, SECTION_CODE, GRADE) VALUES ('6307050346112563', 'GEN111_33', 3.5);

/* JOIN TABLE FOR THIS COMPLEX */
SELECT u.USER_ID, FIRST_NAME, DEPARTMENT, TOTAL_CREDIT, GPAX
FROM ((((price_course pc JOIN course c ON pc.PRICE_RATE_ID = c.PRICE_RATE_ID) 
        JOIN section s ON c.COURSE_CODE = s.COURSE_CODE) 
       JOIN enrolled_section es ON s.SECTION_CODE = es.SECTION_CODE) 
      JOIN enrollment e ON es.ENROLLMENT_ID = e.ENROLLMENT_ID) 
      JOIN user_t u ON e.USER_ID = u.USER_ID
WHERE u.USER_ID = '63070503405';

/* Caluculate GPA */
UPDATE enrollment
SET GPA = (SELECT SUM(GRADE*CREDIT)/SUM(CREDIT)
           FROM (((price_course pc JOIN course c ON pc.PRICE_RATE_ID = c.PRICE_RATE_ID) 
                   JOIN section s ON c.COURSE_CODE = s.COURSE_CODE) 
                  JOIN enrolled_section es ON s.SECTION_CODE = es.SECTION_CODE) 
                 JOIN enrollment e ON es.ENROLLMENT_ID = e.ENROLLMENT_ID
           WHERE es.ENROLLMENT_ID = '6307050340512563')
WHERE ENROLLMENT_ID = '6307050340512563';

/* Calculate GPAX */
UPDATE user_t
SET GPAX = (SELECT SUM(GPA)/COUNT(GPA)
            FROM ((((price_course pc JOIN course c ON pc.PRICE_RATE_ID = c.PRICE_RATE_ID) 
                   JOIN section s ON c.COURSE_CODE = s.COURSE_CODE) 
                  JOIN enrolled_section es ON s.SECTION_CODE = es.SECTION_CODE) 
                 JOIN enrollment e ON es.ENROLLMENT_ID = e.ENROLLMENT_ID)
                 JOIN user_t u ON e.USER_ID = u.USER_ID
                 WHERE u.USER_ID = '63070503405'), 
    TOTAL_CREDIT = (SELECT SUM(CREDIT)
                    FROM ((((price_course pc JOIN course c ON pc.PRICE_RATE_ID = c.PRICE_RATE_ID) 
                        JOIN section s ON c.COURSE_CODE = s.COURSE_CODE) 
                        JOIN enrolled_section es ON s.SECTION_CODE = es.SECTION_CODE) 
                        JOIN enrollment e ON es.ENROLLMENT_ID = e.ENROLLMENT_ID)
                        JOIN user_t u ON e.USER_ID = u.USER_ID
                    WHERE u.USER_ID = '63070503405')
WHERE USER_ID = '63070503405';

/* Change Year */
UPDATE user_t
SET YEAR = (SELECT MAX(ACADEMIC_YEAR)-MIN(ACADEMIC_YEAR)+1
            FROM enrollment
            WHERE USER_ID = '63070503405')
WHERE USER_ID = '63070503405';