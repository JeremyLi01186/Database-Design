alter table CLASS_2_PATIENT
add DOC_ID varchar(255) null;

alter table CLASS_2_PATIENT
add foreign key (DOC_ID) references DOCTOR(DOC_ID);

alter table CLASS_1_PATIENT
add DOC_ID varchar(255) null;

alter table CLASS_1_PATIENT
add foreign key (DOC_ID) references DOCTOR(DOC_ID);

alter table PAYMENT
add CLASS_2_ID varchar(255) null;

alter table PAYMENT
add foreign key (CLASS_2_ID) references CLASS_2_PATIENT(CLASS_2_ID);


alter table PAYMENT
add foreign key (T_ID) references TREATMENT(T_ID);
