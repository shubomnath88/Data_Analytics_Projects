create database healthcare;
use healthcare;

create table diagnoses(
DiagnosisID int primary key,
DiagnosisName varchar(255)
);

create table outcomes(
OutcomeID int primary key,
OutcomeName varchar(255)
);

create table patients(
PatientID int primary key,
Name varchar(255),
Age int,
Gender char(1),
DiagnosisID int,
AdmissionDate date,
DischargeDate date,
OutcomeID int,
TreatmentCost decimal(10,2),
foreign key (DiagnosisID) references diagnoses(DiagnosisID),
foreign key (OutcomeID) references outcomes(OutcomeID)
);

create table labs(
LabID int primary key,
PatientID int,
TestName varchar(255),
Result decimal(10,2),
NormalRange varchar(255),
foreign key (PatientID) references patients(PatientID)
);

select * from patients;
select * from labs;
select * from diagnoses;
select * from outcomes;

-- retrieve detailed paitened lab history

select p.PatientID, p.Name, d.DiagnosisName, o.OutcomeName, l.TestName, l.Result, l.NormalRange
from patients p
join diagnoses d on p.DiagnosisID = d.DiagnosisID
join outcomes o on p.OutcomeID = o.OutcomeID
join labs l on p.PatientID = l.PatientID
order by p.PatientID, l.TestName;

-- Average lab results by Diagnosis
select d.DiagnosisName, l.TestName, avg(l.Result) Average_Result
from patients p
join diagnoses d on p.DiagnosisID = d.DiagnosisID
join labs l on p.PatientID = l.PatientID
group by d.DiagnosisName, l.TestName;

-- count of abnormal lab results
select p.PatientID, p.Name, count(*) Abnormal_count
from patients p
join labs l on p.PatientID = l.PatientID
where (l.TestName = 'Blood Pressure' and l.Result<120) or
(l.TestName = 'Hemoglobin' and l.Result>280)
group by p.PatientID, p.Name
order by Abnormal_count desc;

-- Diagnosis with the highest treatment cost
select p.Name, d.DiagnosisName, sum(p.TreatmentCost) Total_Cost
from patients p
join diagnoses d on p.DiagnosisID = d.DiagnosisID
group by p.Name, d.DiagnosisName
order by Total_Cost desc;

-- Paitent at risk by Age and Gender
select p.PatientID, p.Name, p.Gender, p.Age, d.DiagnosisName, o.OutcomeName
from patients p
join diagnoses d on p.DiagnosisID = d.DiagnosisID
join outcomes o on p.OutcomeID = o.OutcomeID
where p.Age > 65 and o.OutcomeName != 'Recovered';

-- lab trends over time for a specific paitent
select l.TestName, l.Result, p.AdmissionDate
from labs l
join patients p on l.PatientID = p.PatientID
where p.PatientID in (2, 4, 6, 8, 10, 12)
order by p.AdmissionDate;

-- Distribution of outcome by Diagnosis
select d.DiagnosisName, o.OutcomeName, count(*) OutcomeCount
from patients p 
join diagnoses d on p.DiagnosisID = d.DiagnosisID
join outcomes o on p.OutcomeID = o.OutcomeID
group by d.DiagnosisName, o.OutcomeName
order by d.DiagnosisName, o.OutcomeName desc;