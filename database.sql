CREATE DATABASE techlms;
USE techlms;

CREATE TABLE User (
    user_id VARCHAR(15) PRIMARY KEY,
    email VARCHAR(50) NOT NULL,
    Name VARCHAR(50),
    phone VARCHAR(255),
    username VARCHAR(255),
    password VARCHAR(255),
    role ENUM('undergraduate','lecturer','admin','technicalOfficer') NOT NULL
);

CREATE TABLE technical_officer (
    to_id VARCHAR(15),
    PRIMARY KEY(to_id),
    FOREIGN KEY (to_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE lecturer
(
    lecturer_id VARCHAR(15),
    department VARCHAR(70), 
    PRIMARY KEY(lecturer_id),
    FOREIGN KEY(lecturer_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE admin (
    admin_id VARCHAR(15),
    PRIMARY KEY(admin_id),
    FOREIGN KEY (admin_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE Undergraduate (
    undergraduate_id VARCHAR(15),
    department VARCHAR(10),
    PRIMARY KEY(undergraduate_id),
    FOREIGN KEY (undergraduate_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE course_unit
(
    course_code VARCHAR(15),
    name VARCHAR(50), 
    type VARCHAR(10) ,
    credit INT CHECK (credit > 0 AND credit < 4), 
    c_lecturer_id VARCHAR(15),
    PRIMARY KEY(course_code,type),    
    FOREIGN KEY (c_lecturer_id) REFERENCES lecturer(lecturer_id) ON DELETE SET NULL
);



CREATE TABLE undergraduate_course_unit (
    undergraduate_id VARCHAR(15),
    course_code VARCHAR(15),
    PRIMARY KEY (undergraduate_id, course_code),
    FOREIGN KEY (undergraduate_id) REFERENCES Undergraduate(undergraduate_id) ON DELETE CASCADE,
    FOREIGN KEY (course_code) REFERENCES course_unit(course_code) ON DELETE CASCADE
);

CREATE TABLE Medical (
    medical_id VARCHAR(15),
    med_undergraduate_id VARCHAR(15),
    date DATE,
    PRIMARY KEY(medical_id),
    FOREIGN KEY (med_undergraduate_id) REFERENCES Undergraduate(undergraduate_id) ON DELETE CASCADE
);


CREATE TABLE Attendance (
    attendance_id VARCHAR(15),
    at_undergraduate_id VARCHAR(15),
    at_course_code VARCHAR(15),
    at_course_type VARCHAR(10),
    date DATE,
    attendence VARCHAR(20),
    medical_status VARCHAR(15),
    session_no INT NOT NULL,
    at_to_id VARCHAR(15),
    PRIMARY KEY(attendance_id),
    FOREIGN KEY (medical_status) REFERENCES medical(medical_id) ON DELETE CASCADE,
    FOREIGN KEY (at_undergraduate_id) REFERENCES Undergraduate(undergraduate_id) ON DELETE CASCADE,
    FOREIGN KEY (at_course_code, at_course_type) REFERENCES course_unit(course_code, type) ON DELETE CASCADE,
    FOREIGN KEY (at_to_id) REFERENCES technical_officer(to_id) ON DELETE CASCADE
);


CREATE TABLE marks (
    undergraduate_id VARCHAR(15),
    course_code VARCHAR(15),
    Q1 INT CHECK (Q1 BETWEEN 0 AND 100), 
    Q2 INT CHECK (Q2 BETWEEN 0 AND 100),
    Q3 INT CHECK (Q3 BETWEEN 0 AND 100),
    assessment_mark INT CHECK (assessment_mark BETWEEN 0 AND 100),
    mid_exam_theory INT CHECK (mid_exam_theory BETWEEN 0 AND 100),
    mid_exam_practical INT CHECK (mid_exam_practical BETWEEN 0 AND 100),
    final_exam_theory INT CHECK (final_exam_theory BETWEEN 0 AND 100),
    final_exam_practical INT CHECK (final_exam_practical BETWEEN 0 AND 100),
    PRIMARY KEY(undergraduate_id, course_code),
    FOREIGN KEY (undergraduate_id) REFERENCES undergraduate(undergraduate_id) ON DELETE CASCADE,
    FOREIGN KEY (undergraduate_id) REFERENCES course_unit(course_code) ON DELETE CASCADE
);



-- CREATE TABLE marks (
--     student_id VARCHAR(15),
--     course_code VARCHAR(15),
--     Q1 INT CHECK (Q1 BETWEEN 0 AND 100), 
--     Q2 INT CHECK (Q2 BETWEEN 0 AND 100),
--     Q3 INT CHECK (Q3 BETWEEN 0 AND 100),
--     assessment_mark INT CHECK (assessment_mark BETWEEN 0 AND 100),
--     mid_exam_theory INT CHECK (mid_exam_theory BETWEEN 0 AND 100),
--     mid_exam_practical INT CHECK (mid_exam_practical BETWEEN 0 AND 100),
--     final_exam_theory INT CHECK (final_exam_theory BETWEEN 0 AND 100),
--     final_exam_practical INT CHECK (final_exam_practical BETWEEN 0 AND 100),
--     PRIMARY KEY(student_id, course_code),
--     FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
--     FOREIGN KEY (course_code) REFERENCES course_unit(course_code) ON DELETE CASCADE
-- );

-- note ******************************************************************************************************************************
ALTER TABLE attendance
CHANGE attendence attendance VARCHAR(20);

--Insert dta into user table
-- Admin
INSERT INTO User VALUES
('ADM001', 'admin@university.com', 'Admin User', '0701000000', 'admin', 'admin123', 'admin');

-- Lecturers
INSERT INTO User VALUES
('LEC001', 'kasun.bandara07@gmail.com', 'Kasun Bandara', '0771234567', 'kasunb', 'pass123', 'lecturer'),
('LEC002', 'harsha.weerasinghe34@gmail.com', 'Harsha Devappriya', '0702233445', 'harshad', 'pass123', 'lecturer'),
('LEC003', 'chamara.maduranga2001@gmail.com', 'Chamara Maduranga', '0783344556', 'chamaram', 'pass123', 'lecturer'),
('LEC004', 'lakshman.karumar68@gmail.com', 'Lakshman Kumar', '0729988776', 'lakshmank', 'pass123', 'lecturer'),
('LEC005', 'kasun.senanayaka07@gmail.com', 'Kasun Senanayaka', '0746677889', 'kasuns', 'pass123', 'lecturer');

-- Technical Officers
INSERT INTO User VALUES
('TCO001', 'dilini.jayawardena88@gmail.com', 'Dilini Jayawardena', '0755566778', 'dilinij', 'pass123', 'technicalOfficer'),
('TCO002', 'chathurika.abeysinghe77@gmail.com', 'Chathurika Abeysinghe', '0719876543', 'chathurikaa', 'pass123', 'technicalOfficer'),
('TCO003', 'ruwanthi.desilva30@gmail.com', 'Ruwanthi Desilva', '0759988776', 'ruwanthid', 'pass123', 'technicalOfficer'),
('TCO004', 'tharindu.rathnayake09@gmail.com', 'Tharindu Rathnayake', '0774443322', 'tharindur', 'pass123', 'technicalOfficer');

-- Undergraduates
INSERT INTO User VALUES
('UG001', 'saman.ekanayaka77@gmail.com', 'Saman Ekanayaka', '0711234567', 'samanek', 'pass123', 'undergraduate'),
('UG002', 'nadeesha.ekanayake23@gmail.com', 'Nadeesha Ekanayake', '0751234567', 'nadeeshae', 'pass123', 'undergraduate'),
('UG003', 'lahiru.sadaruwan15@gmail.com', 'Lahiru Sadaruwan', '0741234567', 'lahirus', 'pass123', 'undergraduate'),
('UG004', 'sajith.gunaratne56@gmail.com', 'Sajith Madushan', '0781234567', 'sajithm', 'pass123', 'undergraduate'),
('UG005', 'supun.chamod126@gmail.com', 'Supun Chamod', '0712345678', 'supunc', 'pass123', 'undergraduate'),
('UG006', 'gayantha.fernando91@gmail.com', 'Gayantha Fernando', '0768889990', 'gayanthaf', 'pass123', 'undergraduate'),
('UG007', 'nisansala.samarasinghe81@gmail.com', 'Nisansala Samarasinghe', '0701122334', 'nisansalas', 'pass123', 'undergraduate'),
('UG008', 'krishan.amarasinhe50@gmail.com', 'Krishan Amarasinhe', '0705566778', 'krishana', 'pass123', 'undergraduate'),
('UG009', 'hansamal.witharana50@gmail.com', 'Hansamal Witharana', '0779988776', 'hansamalw', 'pass123', 'undergraduate'),
('UG010', 'namal.kumara564@gmail.com', 'Namal Kumara', '0723344556', 'namalk', 'pass123', 'undergraduate'),
('UG011', 'isuru.dealwis04@gmail.com', 'Isuru De Alwis', '0748899776', 'isurud', 'pass123', 'undergraduate'),
('UG012', 'nuwantha.wickramasinghe45@gmail.com', 'Nuwantha Wickramasinghe', '0786655443', 'nuwanthaw', 'pass123', 'undergraduate'),
('UG013', 'kumari.hettiarachchi44@gmail.com', 'Kumari Hettiarachchi', '0712233445', 'kumarih', 'pass123', 'undergraduate'),
('UG014', 'menaka.kodithuwakku59@gmail.com', 'Menaka Kodithuwakku', '0763322114', 'menakak', 'pass123', 'undergraduate'),
('UG015', 'malini.gamage18@gmail.com', 'Malini Gamage', '0756677889', 'malinig', 'pass123', 'undergraduate'),
('UG016', 'piumi.abeykoon50@gmail.com', 'Piumi Abeykoon', '0773344556', 'piumia', 'pass123', 'undergraduate'),
('UG017', 'nadeesha2@gmail.com', 'Nadeesha Ekanayake', '0717766554', 'nadeesha2', 'pass123', 'undergraduate'),
('UG018', 'dilini2@gmail.com', 'Dilini Jayawardena', '0789988776', 'dilini2', 'pass123', 'undergraduate'),
('UG019', 'lahiru.perera15@gmail.com', 'Lahiru Perera', '0742233445', 'lahirup', 'pass123', 'undergraduate'),
('UG020', 'lakmal.gunaratne56@gmail.com', 'Lakmal Gunaratne', '0707788990', 'lakmalg', 'pass123', 'undergraduate');


INSERT INTO technical_officer
VALUES ('TCO001'),
        ('TCO002'),
        ('TCO003'),
        ('TCO004');


INSERT INTO admin
VALUES ('ADM001');

INSERT INTO lecturer(lecturer_id,department)
VALUES 
("LEC001","ICT"),
("LEC002","ICT"),
("LEC003","ICT"),
("LEC004","ICT"),
("LEC005","ICT");


INSERT INTO Undergraduate(undergraduate_id,  department)
VALUES
('UG001', 'ICT'),
('UG002', 'ICT'),
('UG003', 'ICT'),
('UG004', 'ICT'),
('UG005', 'ICT'),
('UG006', 'ICT'),
('UG007', 'ICT'),
('UG008', 'ICT'),
('UG009', 'ICT'),
('UG010', 'ICT'),
('UG011', 'ICT'),
('UG012', 'ICT'),
('UG013', 'ICT'),
('UG014', 'ICT'),
('UG015', 'ICT'),
('UG016', 'ICT'),
('UG017', 'ICT'),
('UG018', 'ICT'),
('UG019', 'ICT'),
('UG020', 'ICT');


INSERT INTO course_unit (course_code,name,type,credit,c_lecturer_id)
VALUES
("ICT2113", "Data Structures and Algorithms","TP", 3,"LEC001"),
("ICT2122", "Object Oriented Programming", "T", 2,"LEC002"),
("ICT2133", "Web Technologies", "TP", 3,"LEC003"),
("ICT2142", "Object Oriented Programming Practicum", "P", 2,"LEC004"),
("ICT2152","E-Commerce Implementation, Management and Security", "T", 2,"LEC005");



 ---Update this table *************************************************************************************************************************************************** 
-- First add sample medical data
INSERT INTO Medical (medical_id, med_undergraduate_id, date) VALUES
-- UG003 with medicals
('MED001', 'UG003', '2025-02-10'),
('MED002', 'UG003', '2025-03-03'),
-- UG008 with medicals
('MED003', 'UG008', '2025-02-17'),
('MED004', 'UG008', '2025-03-10'),
('MED005', 'UG008', '2025-03-24'),
-- UG012 with medicals (still below 80%)
('MED006', 'UG012', '2025-02-24'),
('MED007', 'UG012', '2025-03-17'),
-- UG016 with medicals
('MED008', 'UG016', '2025-02-12'),
('MED009', 'UG016', '2025-03-05'),
('MED010', 'UG016', '2025-03-26');


-- Attendance data for ICT2113 (Data Structures and Algorithms) - TP
-- Starting date: 03.02.2025, Weekly sessions

-- Week 1 (February 3, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00001', 'UG001', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00002', 'UG002', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00003', 'UG003', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00004', 'UG004', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00005', 'UG005', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00006', 'UG006', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00007', 'UG007', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00008', 'UG008', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00009', 'UG009', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00010', 'UG010', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00011', 'UG011', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00012', 'UG012', 'ICT2113', 'TP', '2025-02-03', 'absent', NULL, 1, 'TCO001'),
('AT00013', 'UG013', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00014', 'UG014', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00015', 'UG015', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00016', 'UG016', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00017', 'UG017', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00018', 'UG018', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00019', 'UG019', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001'),
('AT00020', 'UG020', 'ICT2113', 'TP', '2025-02-03', 'present', NULL, 1, 'TCO001');

-- Week 2 (February 10, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00021', 'UG001', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00022', 'UG002', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00023', 'UG003', 'ICT2113', 'TP', '2025-02-10', 'absent', 'MED001', 2, 'TCO001'),
('AT00024', 'UG004', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00025', 'UG005', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00026', 'UG006', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00027', 'UG007', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00028', 'UG008', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00029', 'UG009', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00030', 'UG010', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00031', 'UG011', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00032', 'UG012', 'ICT2113', 'TP', '2025-02-10', 'absent', NULL, 2, 'TCO001'),
('AT00033', 'UG013', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00034', 'UG014', 'ICT2113', 'TP', '2025-02-10', 'absent', NULL, 2, 'TCO001'),
('AT00035', 'UG015', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00036', 'UG016', 'ICT2113', 'TP', '2025-02-10', 'absent', 'MED008', 2, 'TCO001'),
('AT00037', 'UG017', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00038', 'UG018', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00039', 'UG019', 'ICT2113', 'TP', '2025-02-10', 'present', NULL, 2, 'TCO001'),
('AT00040', 'UG020', 'ICT2113', 'TP', '2025-02-10', 'absent', NULL, 2, 'TCO001');

-- Week 3 (February 17, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00041', 'UG001', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00042', 'UG002', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00043', 'UG003', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00044', 'UG004', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00045', 'UG005', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00046', 'UG006', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00047', 'UG007', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00048', 'UG008', 'ICT2113', 'TP', '2025-02-17', 'absent', 'MED003', 3, 'TCO001'),
('AT00049', 'UG009', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00050', 'UG010', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00051', 'UG011', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00052', 'UG012', 'ICT2113', 'TP', '2025-02-17', 'absent', NULL, 3, 'TCO001'),
('AT00053', 'UG013', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00054', 'UG014', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00055', 'UG015', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00056', 'UG016', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00057', 'UG017', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00058', 'UG018', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00059', 'UG019', 'ICT2113', 'TP', '2025-02-17', 'present', NULL, 3, 'TCO001'),
('AT00060', 'UG020', 'ICT2113', 'TP', '2025-02-17', 'absent', NULL, 3, 'TCO001');

-- Week 4 (February 24, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00061', 'UG001', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00062', 'UG002', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00063', 'UG003', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00064', 'UG004', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00065', 'UG005', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00066', 'UG006', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00067', 'UG007', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00068', 'UG008', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00069', 'UG009', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00070', 'UG010', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00071', 'UG011', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00072', 'UG012', 'ICT2113', 'TP', '2025-02-24', 'absent', 'MED006', 4, 'TCO001'),
('AT00073', 'UG013', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00074', 'UG014', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00075', 'UG015', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00076', 'UG016', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00077', 'UG017', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00078', 'UG018', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00079', 'UG019', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001'),
('AT00080', 'UG020', 'ICT2113', 'TP', '2025-02-24', 'present', NULL, 4, 'TCO001');

-- Week 5 (March 3, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00081', 'UG001', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00082', 'UG002', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00083', 'UG003', 'ICT2113', 'TP', '2025-03-03', 'absent', 'MED002', 5, 'TCO001'),
('AT00084', 'UG004', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00085', 'UG005', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00086', 'UG006', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00087', 'UG007', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00088', 'UG008', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00089', 'UG009', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00090', 'UG010', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00091', 'UG011', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00092', 'UG012', 'ICT2113', 'TP', '2025-03-03', 'absent', NULL, 5, 'TCO001'),
('AT00093', 'UG013', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00094', 'UG014', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00095', 'UG015', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00096', 'UG016', 'ICT2113', 'TP', '2025-03-03', 'absent', 'MED009', 5, 'TCO001'),
('AT00097', 'UG017', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00098', 'UG018', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00099', 'UG019', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001'),
('AT00100', 'UG020', 'ICT2113', 'TP', '2025-03-03', 'present', NULL, 5, 'TCO001');

-- Continue with remaining weeks for ICT2113...
-- Week 6 (March 10, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00101', 'UG001', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00102', 'UG002', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00103', 'UG003', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00104', 'UG004', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00105', 'UG005', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00106', 'UG006', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00107', 'UG007', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00108', 'UG008', 'ICT2113', 'TP', '2025-03-10', 'absent', 'MED004', 6, 'TCO001'),
('AT00109', 'UG009', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00110', 'UG010', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00111', 'UG011', 'ICT2113', 'TP', '2025-03-10', 'absent', NULL, 6, 'TCO001'),
('AT00112', 'UG012', 'ICT2113', 'TP', '2025-03-10', 'absent', NULL, 6, 'TCO001'),
('AT00113', 'UG013', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00114', 'UG014', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00115', 'UG015', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00116', 'UG016', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00117', 'UG017', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00118', 'UG018', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00119', 'UG019', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001'),
('AT00120', 'UG020', 'ICT2113', 'TP', '2025-03-10', 'present', NULL, 6, 'TCO001');

-- Week 7 (March 17, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00121', 'UG001', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00122', 'UG002', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00123', 'UG003', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00124', 'UG004', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00125', 'UG005', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00126', 'UG006', 'ICT2113', 'TP', '2025-03-17', 'absent', NULL, 7, 'TCO001'),
('AT00127', 'UG007', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00128', 'UG008', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00129', 'UG009', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00130', 'UG010', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00131', 'UG011', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00132', 'UG012', 'ICT2113', 'TP', '2025-03-17', 'absent', 'MED007', 7, 'TCO001'),
('AT00133', 'UG013', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00134', 'UG014', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00135', 'UG015', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00136', 'UG016', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00137', 'UG017', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00138', 'UG018', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00139', 'UG019', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001'),
('AT00140', 'UG020', 'ICT2113', 'TP', '2025-03-17', 'present', NULL, 7, 'TCO001');

-- Week 8 (March 24, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00141', 'UG001', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00142', 'UG002', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00143', 'UG003', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00144', 'UG004', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00145', 'UG005', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00146', 'UG006', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00147', 'UG007', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00148', 'UG008', 'ICT2113', 'TP', '2025-03-24', 'absent', 'MED005', 8, 'TCO001'),
('AT00149', 'UG009', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00150', 'UG010', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00151', 'UG011', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00152', 'UG012', 'ICT2113', 'TP', '2025-03-24', 'absent', NULL, 8, 'TCO001'),
('AT00153', 'UG013', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00154', 'UG014', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00155', 'UG015', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00156', 'UG016', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00157', 'UG017', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00158', 'UG018', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00159', 'UG019', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001'),
('AT00160', 'UG020', 'ICT2113', 'TP', '2025-03-24', 'present', NULL, 8, 'TCO001');

-- Week 9 (March 31, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00161', 'UG001', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00162', 'UG002', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00163', 'UG003', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00164', 'UG004', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00165', 'UG005', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00166', 'UG006', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00167', 'UG007', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00168', 'UG008', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00169', 'UG009', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00170', 'UG010', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00171', 'UG011', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00172', 'UG012', 'ICT2113', 'TP', '2025-03-31', 'absent', NULL, 9, 'TCO001'),
('AT00173', 'UG013', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00174', 'UG014', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00175', 'UG015', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00176', 'UG016', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00177', 'UG017', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00178', 'UG018', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00179', 'UG019', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001'),
('AT00180', 'UG020', 'ICT2113', 'TP', '2025-03-31', 'present', NULL, 9, 'TCO001');

-- Week 10 (April 7, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00181', 'UG001', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00182', 'UG002', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00183', 'UG003', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00184', 'UG004', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00185', 'UG005', 'ICT2113', 'TP', '2025-04-07', 'absent', NULL, 10, 'TCO001'),
('AT00186', 'UG006', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00187', 'UG007', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00188', 'UG008', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00189', 'UG009', 'ICT2113', 'TP', '2025-04-07', 'absent', NULL, 10, 'TCO001'),
('AT00190', 'UG010', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00191', 'UG011', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00192', 'UG012', 'ICT2113', 'TP', '2025-04-07', 'absent', NULL, 10, 'TCO001'),
('AT00193', 'UG013', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00194', 'UG014', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00195', 'UG015', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00196', 'UG016', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00197', 'UG017', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00198', 'UG018', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00199', 'UG019', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001'),
('AT00200', 'UG020', 'ICT2113', 'TP', '2025-04-07', 'present', NULL, 10, 'TCO001');

-- Week 11 (April 14, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00201', 'UG001', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00202', 'UG002', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00203', 'UG003', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00204', 'UG004', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00205', 'UG005', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00206', 'UG006', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00207', 'UG007', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00208', 'UG008', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00209', 'UG009', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00210', 'UG010', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00211', 'UG011', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00212', 'UG012', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00213', 'UG013', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00214', 'UG014', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00215', 'UG015', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00216', 'UG016', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00217', 'UG017', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00218', 'UG018', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00219', 'UG019', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001'),
('AT00220', 'UG020', 'ICT2113', 'TP', '2025-04-14', 'present', NULL, 11, 'TCO001');

-- Week 12 (April 21, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00221', 'UG001', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00222', 'UG002', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00223', 'UG003', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00224', 'UG004', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00225', 'UG005', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00226', 'UG006', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00227', 'UG007', 'ICT2113', 'TP', '2025-04-21', 'absent', NULL, 12, 'TCO001'),
('AT00228', 'UG008', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00229', 'UG009', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00230', 'UG010', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00231', 'UG011', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00232', 'UG012', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00233', 'UG013', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00234', 'UG014', 'ICT2113', 'TP', '2025-04-21', 'absent', NULL, 12, 'TCO001'),
('AT00235', 'UG015', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00236', 'UG016', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00237', 'UG017', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00238', 'UG018', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00239', 'UG019', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001'),
('AT00240', 'UG020', 'ICT2113', 'TP', '2025-04-21', 'present', NULL, 12, 'TCO001');

-- Week 13 (April 28, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00241', 'UG001', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00242', 'UG002', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00243', 'UG003', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00244', 'UG004', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00245', 'UG005', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00246', 'UG006', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00247', 'UG007', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00248', 'UG008', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00249', 'UG009', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00250', 'UG010', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00251', 'UG011', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00252', 'UG012', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00253', 'UG013', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00254', 'UG014', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00255', 'UG015', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00256', 'UG016', 'ICT2113', 'TP', '2025-04-28', 'absent', 'MED010', 13, 'TCO001'),
('AT00257', 'UG017', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00258', 'UG018', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00259', 'UG019', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001'),
('AT00260', 'UG020', 'ICT2113', 'TP', '2025-04-28', 'present', NULL, 13, 'TCO001');

-- Week 14 (May 5, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00261', 'UG001', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00262', 'UG002', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00263', 'UG003', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00264', 'UG004', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00265', 'UG005', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00266', 'UG006', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00267', 'UG007', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00268', 'UG008', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00269', 'UG009', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00270', 'UG010', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00271', 'UG011', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00272', 'UG012', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00273', 'UG013', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00274', 'UG014', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00275', 'UG015', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00276', 'UG016', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00277', 'UG017', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00278', 'UG018', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00279', 'UG019', 'ICT2113', 'TP', '2025-05-05', 'present', NULL, 14, 'TCO001'),
('AT00280', 'UG020', 'ICT2113', 'TP', '2025-05-05', 'absent', NULL, 14, 'TCO001');

-- Week 15 (May 12, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
('AT00281', 'UG001', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00282', 'UG002', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00283', 'UG003', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00284', 'UG004', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00285', 'UG005', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00286', 'UG006', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00287', 'UG007', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00288', 'UG008', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00289', 'UG009', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00290', 'UG010', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00291', 'UG011', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00292', 'UG012', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00293', 'UG013', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00294', 'UG014', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00295', 'UG015', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00296', 'UG016', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00297', 'UG017', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00298', 'UG018', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00299', 'UG019', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001'),
('AT00300', 'UG020', 'ICT2113', 'TP', '2025-05-12', 'present', NULL, 15, 'TCO001');
