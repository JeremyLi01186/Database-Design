CREATE TABLE VISITOR_LOG 
(
  CLASS_2_ID VARCHAR(200),
  VISITOR_ID VARCHAR(200) NOT NULL,
  VISITOR_NAME VARCHAR(200),
  V_ADDRESS VARCHAR(200),
  V_CONTACT_INFO VARCHAR(200),
  primary key(VISITOR_ID),
  foreign key (CLASS_2_ID) references CLASS_2_PATIENT(CLASS_2_ID)
);

CREATE TABLE ACCESS1 
(
  DOC_ID VARCHAR(200) NOT NULL, 
  MEDICINE_CODE VARCHAR(200) NOT NULL, 
  T_ID VARCHAR(200) NOT NULL, 
  CLASS_2_ID VARCHAR(200) NOT NULL,
  primary key (DOC_ID, MEDICINE_CODE, T_ID, CLASS_2_ID),
  foreign key (MEDICINE_CODE, T_ID, CLASS_2_ID) references MEDICAL_INFORMATION(MEDICINE_CODE, T_ID, CLASS_2_ID),
  foreign key (DOC_ID) references DOCTOR(DOC_ID)
);
