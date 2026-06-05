-- Healthcare Analytics Queries: Patient Demographics:Retrieve the number of patients grouped by gender and calculate the average age of patients.

SELECT COUNT(patientID) as NoOfPatient, AVG(age) as AverageAge , gender
FROM Patients 
GROUP BY gender;

-- Hospital Utilization: Identify hospitals with the highest number of admissions.

SELECT hospitalName, COUNT(admissionID) as TotalAdmission
FROM Hospitals JOIN Admissions ON Hospitals.hospitalID = admissions.hospitalID
GROUP BY hospitals.HospitalID, hospitals.HospitalName
ORDER BY totalAdmission DESC;


-- Treatment Costs: Calculate the total cost of treatments provided at each hospital.

SELECT  HospitalName, SUM(Cost) as TreatmentCost 
FROM hospitals 
LEFT JOIN Admissions ON Hospitals.HospitalID = Admissions.HospitalID 
LEFT JOIN Treatments ON Admissions.AdmissionID = Treatments.AdmissionID
GROUP BY hospitals.HospitalID, hospitals.HospitalName
ORDER BY TreatmentCost DESC; 

 
-- Length of Stay Analysis: Extract the average length of stay for patients grouped by hospital.

SELECT AVG(DATEDIFF(Admissions.DischargeDate , Admissions.AdmissionDate)) AS AvgLengthOfStay
FROM hospitals JOIN Admissions ON  Hospitals.hospitalID = admissions.HospitalID 
WHERE admissions.DischargeDate IS NOT NULL 
GROUP BY Hospitals.hospitalID, hospitals.HospitalName; 

-- List all patients who stayed longer than 7 days in any hospital.

SELECT DISTINCT FullName AS PatientsName, DATEDIFF(Admissions.DischargeDate , Admissions.AdmissionDate) AS LengthOfStay 
FROM patients JOIN admissions ON patients.PatientID = admissions.PatientID
WHERE admissions.DischargeDate IS NOT NULL AND DATEDIFF(Admissions.DischargeDate , Admissions.AdmissionDate) > 7;

-- Identify treatments that have been performed more than 5 times across all hospitals

SELECT ProcedureName,
       COUNT(*) AS TotalTimesPerformed
FROM Treatments
GROUP BY ProcedureName
HAVING COUNT(*) > 5;

-- Combine admission and treatment data to display complete patient histories 

SELECT patients.FullName,
       hospitals.HospitalName,
       admissions.AdmissionDate,
       admissions.DischargeDate,
       admissions.ReasonForAdmission,
       treatments.ProcedureName,
       treatments.Cost,
       treatments.Outcome
FROM Patients 
JOIN Admissions  
    ON patients.PatientID = admissions.PatientID
JOIN Hospitals 
    ON admissions.HospitalID = hospitals.HospitalID
LEFT JOIN Treatments  
    ON admissions.AdmissionID = treatments.AdmissionID
ORDER BY patients.FullName, admissions.AdmissionDate;


-- Combine lists of patients admitted for different reasons (e.g., surgery and therapy).

SELECT FullName, ReasonForAdmission
FROM Patients 
JOIN Admissions  
    ON patients.PatientID = admissions.PatientID
WHERE admissions.ReasonForAdmission = 'Surgery'

UNION

SELECT FullName, ReasonForAdmission
FROM Patients 
JOIN Admissions  
    ON patients.PatientID = admissions.PatientID
WHERE admissions.ReasonForAdmission = 'Therapy'; 


-- Use a subquery to find the hospital with the highest average treatment cost 

SELECT HospitalName, AvgCost
FROM (
    SELECT HospitalName,
           AVG(treatments.Cost) AS AvgCost
    FROM Hospitals 
    JOIN Admissions  
        ON hospitals.HospitalID = admissions.HospitalID
    JOIN Treatments 
        ON admissions.AdmissionID = treatments.AdmissionID
    GROUP BY hospitals.HospitalID, hospitals.HospitalName
) AS AvgTreatment
ORDER BY AvgCost DESC
LIMIT 1; 


-- Create a view named HospitalPerformance to display the total number of admissions, average length of stay, and total revenue generated for each hospital.

CREATE VIEW Hospital_Performance AS
SELECT HospitalName,
       COUNT(DISTINCT admissions.AdmissionID) AS TotalAdmissions,
       AVG(DATEDIFF(admissions.DischargeDate, admissions.AdmissionDate)) AS AvgLengthOfStay,
       COALESCE(SUM(treatments.Cost), 0) AS TotalRevenue
FROM Hospitals 
LEFT JOIN Admissions 
    ON hospitals.HospitalID = admissions.HospitalID
LEFT JOIN Treatments  
    ON admissions.AdmissionID = treatments.AdmissionID
GROUP BY hospitals.HospitalID, hospitals.HospitalName; 


-- Use the RANK function to rank hospitals based on their total revenue 

SELECT HospitalName,
       TotalRevenue,
       RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueRank
FROM Hospital_Performance; 


-- Use DENSE_RANK to rank treatments based on their frequency.

SELECT ProcedureName,
       TreatmentCount,
       DENSE_RANK() OVER (ORDER BY TreatmentCount DESC) AS TreatmentRank
FROM (
    SELECT ProcedureName,
           COUNT(*) AS TreatmentCount
    FROM Treatments
    GROUP BY ProcedureName
) t;
