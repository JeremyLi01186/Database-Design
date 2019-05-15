CREATE TABLE CLASS_1_PATIENT 
(
  PATIENT_ID VARCHAR(255) NOT NULL, 
  PERSON_ID VARCHAR(255) NOT NULL, 
  CLASS_2_ID VARCHAR(255), 
  DOC_ID VARCHAR(255),
  EMPLOYEE_NUM VARCHAR(255), 
  primary key (PATIENT_ID)
 /*foreign key (PERSON_ID) references PERSON(PERSON_ID)*/
);

CREATE TABLE EMPLOYEE 
(
  PERSON_ID VARCHAR(255) NOT NULL, 
  EMPLOYEE_NUM VARCHAR(255) NOT NULL, 
  START_DATE DATE, 
  CLASS_2_ID VARCHAR(255), 
  primary key (EMPLOYEE_NUM)
  /*foreign key (PERSON_ID) references PERSON(PERSON_ID)*/
);

CREATE TABLE DOCTOR 
(
  EMPLOYEE_NUM VARCHAR(255) NOT NULL,
  DOC_ID VARCHAR(255),
  DOC_TYPE VARCHAR(255),
  primary key(DOC_ID)
  /*foreign key (EMPLOYEE_NUM) references EMPLOYEE(EMPLOYEE_NUM)*/
);

CREATE TABLE NURSE 
(
  EMPLOYEE_NUM VARCHAR(255) NOT NULL,
  NURSE_ID VARCHAR(255) NOT NULL,
  primary key(NURSE_ID)
  /*foreign key (EMPLOYEE_NUM) references EMPLOYEE(EMPLOYEE_NUM)*/
);

CREATE TABLE ROOM 
(
  ROOM_ID VARCHAR(255) NOT NULL,
  ROOM_TYPE VARCHAR(255), 
  ROOM_DURATION VARCHAR(255),
  NURSE_ID VARCHAR(255) NOT NULL,
  primary key(ROOM_ID)
  /*foreign key (NURSE_ID) references NURSE(NURSE_ID)*/
);

CREATE TABLE RECEPTIONIST 
(
  RECEPTIONIST_ID VARCHAR(255) NOT NULL, 
  EMPLOYEE_NUM VARCHAR(255) NOT NULL,
  primary key (RECEPTIONIST_ID)
  /*foreign key (EMPLOYEE_NUM) references EMPLOYEE(EMPLOYEE_NUM)*/
);

CREATE TABLE RECORDS 
(
  RECORD_ID VARCHAR(255) NOT NULL,
  RECEPTIONIST_ID VARCHAR(255),
  PATIENT_ID VARCHAR(255), 
  VISIT_DATE DATE,
  APPOINTMENT DATE,
  RECORD_DESCRIPTION VARCHAR(255),
  primary key(RECORD_ID)
  /*foreign key (RECEPTIONIST_ID) references RECEPTIONIST(RECEPTIONIST_ID),*/
  /*foreign key (PATIENT_ID) references CLASS_1_PATIENT(PATIENT_ID)*/
);

CREATE TABLE PAYMENT 
(
  PAYMENT_ID VARCHAR2(20) NOT NULL,
  PAYMENT_DATE DATE, 
  TOTAL_AMOUNT_DUE VARCHAR(20), 
  RECEPTIONIST_ID VARCHAR(20), 
  PATIENT_ID VARCHAR(40), 
  T_ID VARCHAR(20), 
  CASH_AMOUNT VARCHAR(100), 
  I_ID VARCHAR(60), 
  I_PROVIDERID VARCHAR(100), 
  I_COVERAGE VARCHAR(250), 
  I_AMOUNT VARCHAR(100),
  CLASS_2_ID varchar(255),
  primary key (PAYMENT_ID)
  /*foreign key (RECEPTIONIST_ID) references RECEPTIONIST(RECEPTIONIST_ID),*/
  /*foreign key (PATIENT_ID) references CLASS_1_PATIENT(PATIENT_ID)*/
);

CREATE TABLE TREATMENT 
(
  T_ID VARCHAR(200) NOT NULL, 
  T_NAME VARCHAR(250),
  T_DURATION VARCHAR(200),
  primary key(T_ID)
);

CREATE TABLE CLASS_2_PATIENT 
(
  T_ID VARCHAR(200),
  EMPLOYEE_NUM VARCHAR(200), 
  CLASS_2_ID VARCHAR(200) NOT NULL,
  DATE_OF_ADMITTED DATE, 
  ROOM_ID VARCHAR(255),
  DOC_ID varchar(255),
  primary key(CLASS_2_ID)
  /*foreign key(T_ID) references TREATMENT(T_ID),*/
  /*foreign key(ROOM_ID) references ROOM(ROOM_ID)*/
);

CREATE TABLE MEDICAL_INFORMATION 
(
  MEDICINE_CODE VARCHAR(200) NOT NULL,
  T_ID VARCHAR(200) NOT NULL,
  CLASS_2_ID VARCHAR2(200) NOT NULL,
  primary key (MEDICINE_CODE,T_ID,CLASS_2_ID)
  /*foreign key(T_ID) references TREATMENT(T_ID),*/
  /*foreign key(CLASS_2_ID) references CLASS_2_PATIENT(CLASS_2_ID)*/
);

CREATE TABLE PHARMACY 
(
  MEDICINE_CODE VARCHAR(200) NOT NULL, 
  P_PRICE VARCHAR(200), 
  P_NAME VARCHAR(200), 
  P_QUANTITY VARCHAR(200), 
  P_EXPIRECTION_DATE DATE,
  primary key(MEDICINE_CODE)
);

CREATE TABLE VISITOR_LOG 
(
  CLASS_2_ID VARCHAR(200),
  VISITOR_ID VARCHAR(200) NOT NULL,
  VISITOR_NAME VARCHAR(200),
  V_ADDRESS VARCHAR(200),
  V_CONTACT_INFO VARCHAR(200),
  primary key(VISITOR_ID)
  /*foreign key (CLASS_2_ID) references CLASS_2_PATIENT(CLASS_2_ID)*/
);

CREATE TABLE ACCESS1 
(
  DOC_ID VARCHAR(200) NOT NULL, 
  MEDICINE_CODE VARCHAR(200) NOT NULL, 
  T_ID VARCHAR(200) NOT NULL, 
  CLASS_2_ID VARCHAR(200) NOT NULL,
  primary key (DOC_ID, MEDICINE_CODE, T_ID, CLASS_2_ID)
  /*foreign key (MEDICINE_CODE, T_ID, CLASS_2_ID) references MEDICAL_INFORMATION(MEDICINE_CODE, T_ID, CLASS_2_ID),*/
  /*foreign key (DOC_ID) references DOCTOR(DOC_ID)*/
);



drop table EMPLOYEE;


CREATE TABLE EMPLOYEE 
(
  EMPLOYEE_NUM VARCHAR(255) NOT NULL, 
  PERSON_ID VARCHAR(255), 
  START_DATE DATE, 
  CLASS_2_ID VARCHAR(255), 
  primary key (EMPLOYEE_NUM)
  /*foreign key (PERSON_ID) references PERSON(PERSON_ID)*/
);

/*Reordermeds*/
CREATE VIEW ReorderMeds AS 
SELECT  P_EXPIRATION_DATE, P_QUANTITY
FROM PHARMACY
WHERE P_QUANTITY<1000 AND (TO_DATE(P_EXPIRATION_DATE, 'DD-MON-YY') - TO_DATE(sysdate, 'DD-MON-YY'))<30;


/*TOP_DOCTOR*/
CREATE VIEW TOP_DOCTOR AS
SELECT P.F_Name,P.L_Name,E.Start_Date
FROM PERSON P,DOCTOR D,employee E
WHERE P.Person_ID=e.employee_num and d.employee_num=e.employee_num and d.doc_id in
(
    (
    SELECT DOC_ID
    FROM class_1_patient
    group by Doc_id
    having count(*)>5
    )
    INTERSECT
    (
    SELECT DOC_ID
    FROM class_2_patient
    group by Doc_id
    having count(*)>=10
    )
);

/*4. Find the name of medicines associated with the most common treatment in the hospital.*/
/*SELECT
	*
FROM
	(
		SELECT
			--MEDICAL_INFORMATION.T_ID,
			 COUNT (MEDICAL_INFORMATION.T_ID) AS rnk
		FROM
			MEDICAL_INFORMATION
		WHERE
			MEDICAL_INFORMATION.T_ID IS NOT NULL
		GROUP BY
			MEDICAL_INFORMATION.T_ID
		ORDER BY
			COUNT (MEDICAL_INFORMATION.T_ID) DESC
	) WHERE ROWNUM <=2
*/



/*5.Find all the doctors who have not had a patient in the last 5 months. (Hint:
Consider the date of payment as the day the doctor has attended a patient/been 
consulted by a patient.)*/


/*7. Find the most occupied room in the hospital and the duration of the stay.*/
SELECT ROOM_ID, ROOM_DURATION
FROM ROOM
WHERE ROOM_DURATION IN
(
SELECT MAX(ROOM_DURATION)AS OCCUPIED
FROM ROOM
)

/*10 List the total number of patients that have been admitted to the hospital 
after the most current employee has joined.*/
SELECT COUNT(*)
FROM CLASS_2_PATIENT
WHERE CLASS_2_PATIENT.DATE_OF_ADMITTED > 
        (
            SELECT MAX(START_DATE)
       	 	FROM EMPLOYEE
        )


/*13 Find the name of the doctors of patients who have visited the hospital only 
once for consultation and have not been admitted to the hospital.*/
--PERSON() CLASS_2_PATIENT(DATE_OF_ADM)
select  F_NAME,M_NAME,L_NAME
--from PERSON 
FROM PERSON, DOCTOR, CLASS_1_PATIENT, RECDS
WHERE RECDS.PATIENT_ID =CLASS_1_PATIENT.PATIENT_ID 
    and CLASS_1_PATIENT.DOC_ID = DOCTOR.DOC_ID 
    and DOCTOR.EMPLOYEE_NUM =PERSON.PERSON_ID
    and RECDS.Patient_ID IN
( 
SELECT count(RECDS.VISIT_DATE)
FROM RECDS
--WHERE RECDS.VISIT_DATE
GROUP BY RECDS.Patient_ID
HAVING COUNT(VISIT_DATE)=1
)

