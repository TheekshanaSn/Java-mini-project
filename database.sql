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
                         med_course_code VARCHAR(15),
                         date DATE,
                         reason VARCHAR(255) ,
                         med_session_no VARCHAR(15),
                         PRIMARY KEY(medical_id),
                         FOREIGN KEY (med_course_code) REFERENCES course_unit(course_code) ,
                         FOREIGN KEY (med_undergraduate_id) REFERENCES Undergraduate(undergraduate_id)
);



CREATE TABLE Attendance (
                            attendance_id VARCHAR(15),
                            at_undergraduate_id VARCHAR(15),
                            at_course_code VARCHAR(15),
                            at_course_type VARCHAR(10),
                            date DATE,
                            attendance VARCHAR(20),
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




CREATE TABLE notice (
                        notice_id INT ,
                        title VARCHAR(100),
                        content VARCHAR(1000),
                        PRIMARY KEY(notice_id)
);



CREATE TABLE Timetable (
                           Timetable_id VARCHAR(15),
                           day VARCHAR(10),
                           time_range varchar(20),
                           course_code VARCHAR(15),
                           course_type VARCHAR(10),
                           lecturer_id VARCHAR(15),
                           PRIMARY KEY(Timetable_id)

);

CREATE TABLE finalmarks (

                            undergraduate_id VARCHAR(15),
                            course_code VARCHAR(15),
                            Finaltheory INT CHECK (Finaltheory BETWEEN 0 AND 100),
                            Finalpracticaly INT CHECK (Finalpracticaly BETWEEN 0 AND 100),
                            PRIMARY KEY(undergraduate_id, course_code),
                            finalmarks double(5,2),
                            FOREIGN KEY (undergraduate_id) REFERENCES Undergraduate(undergraduate_id),
                            FOREIGN KEY (course_code) REFERENCES course_unit(course_code)
);


CREATE TABLE lecture_notes (
                               id INT(11) NOT NULL AUTO_INCREMENT,
                               course_code VARCHAR(10) DEFAULT NULL,
                               file_name VARCHAR(255) DEFAULT NULL,
                               pdf_data LONGBLOB DEFAULT NULL,
                               uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               PRIMARY KEY (id)
);








CREATE TABLE camarks (
                         undergraduate_id VARCHAR(15),
                         course_code VARCHAR(15),
                         Quizze01 INT CHECK (Quizze01 BETWEEN 0 AND 100),
                         Quizze02 INT CHECK (Quizze02 BETWEEN 0 AND 100),
                         Quizze03 INT CHECK (Quizze03 BETWEEN 0 AND 100),
                         Quizze04 INT CHECK (Quizze04 BETWEEN 0 AND 100),
                         Assessments01 INT CHECK (Assessments01 BETWEEN 0 AND 100),
                         Assessments02 INT CHECK (Assessments02 BETWEEN 0 AND 100),
                         Midterm INT CHECK (Midterm BETWEEN 0 AND 100),
                         status  VARCHAR(255),
                         camarks double(5,2),
                         PRIMARY KEY(undergraduate_id, course_code),
                         FOREIGN KEY (undergraduate_id) REFERENCES Undergraduate(undergraduate_id),
                         FOREIGN KEY (course_code) REFERENCES course_unit(course_code)
);

ALTER TABLE Undergraduate
    ADD COLUMN profile_picture BLOB;



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
                     ('LEC005', 'kasun.senanayaka07@gmail.com', 'Kasun Senanayaka', '0746677889', 'kasuns', 'pass123', 'lecturer'),
                     ('LEC006', 'Nimesh.senanayaka07@gmail.com', 'Nimesh Madguranga', '0746677889', 'Nimesh', 'pass123', 'lecturer');

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
    ('LEC001','ICT'),
    ('LEC002','ICT'),
    ('LEC003','ICT'),
    ('LEC004','ICT'),
    ('LEC005','ICT');


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



INSERT INTO lecturer(lecturer_id,department)
VALUES
    ('LEC006','DMS');
INSERT INTO course_unit (course_code,name,type,credit,c_lecturer_id)
VALUES
    ('ENG2122','English III','T',2,'LEC006');





INSERT INTO notice VALUES (1, 'ICT Department', 'All first-year Information commiunication and Technology  students are invited to the Hackthon on Monday at 10:00 AM in Lab 1. Attendance is compulsory.'),
                          (2, 'E money', 'Join us for a guest lecture on " how to earn E money" by Mr. Smith on Wednesday 4 PM in the main auditorium.'),
                          (3, 'Exam registation', 'Students must be register for end examination before  may 30th.'),
                          (4, '1 sem exam', 'ICT student it stat at 30 rd may'),
                          (5, 'Aurudu Function', '30th april "AURUDU" Function  will be held on'),
                          (6, 'lungi night', '3rd year student organized lungi night and Dj function');

INSERT INTO Timetable VALUES ('Tt001', 'Monday', '08:00 AM -11:00 AM', 'ICT2113', 'TP', 'LEC001'),
                             ('Tt002', 'Tuesday','09:00 AM -11:00 AM', 'ICT2122', 'T', 'LEC002'),
                             ('Tt003', 'Wednesday','08:00 AM -10:00 AM', 'ICT2133', 'TP', 'LEC004'),
                             ('Tt004', 'Thursday', '08:00 AM -12:00 PM', 'ICT2143', 'T', 'LEC005'),
                             ('Tt005', 'Friday', '08:00 AM -10:00 AM', 'ICT2142', 'P', 'LEC003');












INSERT INTO course_unit (course_code, name, type, credit, c_lecturer_id)
VALUES
    ('ICT2113', 'Data Structures and Algorithms', 'TP', 3, 'LEC001'),
    ('ICT2122', 'Object Oriented Programming', 'T', 2, 'LEC002'),
    ('ICT2133', 'Web Technologies', 'TP', 3, 'LEC003'),
    ('ICT2142', 'Object Oriented Programming Practicum', 'P', 2, 'LEC004'),
    ('ICT2152', 'E-Commerce Implementation, Management and Security', 'T', 2, 'LEC005');



---Update this table ***************************************************************************************************************************************************
-- First add sample medical data
INSERT INTO Medical (medical_id, med_undergraduate_id,med_course_code, date,reason,med_session_no) VALUES

                                                                                                       ('MED001', 'UG003','ICT2113', '2025-02-10','Cold',2),
                                                                                                       ('MED002', 'UG003','ICT2113', '2025-03-03','Back pain',5),
                                                                                                       ('MED003', 'UG008','ICT2113', '2025-02-17','Headache',3),
                                                                                                       ('MED004', 'UG008','ICT2113', '2025-03-10','Fever',6),
                                                                                                       ('MED005', 'UG008','ICT2113', '2025-03-24','Injury',8),
                                                                                                       ('MED006', 'UG012','ICT2113', '2025-02-24','Fever',4),
                                                                                                       ('MED007', 'UG012','ICT2113', '2025-03-17','Headache',7),
                                                                                                       ('MED008', 'UG016','ICT2113', '2025-02-10','Cold',2),
                                                                                                       ('MED009', 'UG016','ICT2113', '2025-03-03','Fever',5),
                                                                                                       ('MED010', 'UG016','ICT2113', '2025-04-28','Migraine',13),
                                                                                                       ('MED011', 'UG001','ICT2122', '2025-02-04','Migraine',1),
                                                                                                       ('MED012', 'UG004','ICT2122', '2025-02-25','Cold',4),
                                                                                                       ('MED013', 'UG004','ICT2122', '2025-02-17','Headache',3),
                                                                                                       ('MED014', 'UG010','ICT2133', '2025-02-05','Sore Throat',1),
                                                                                                       ('MED015', 'UG002','ICT2133', '2025-03-19','Headache',7),
                                                                                                       ('MED016', 'UG020','ICT2152', '2025-04-01','Stomach Ache',13);




-- Attendance data for ICT2113 (Data Structures and Algorithms) - TP
-- Starting date: 03.02.2025, Weekly sessions

-- Week 1 (February 3, 2025)
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type,date, attendance, medical_status, session_no, at_to_id) VALUES
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
                                                                                                                                                        ('AT00161', 'UG001', 'ICT2113', 'TP', '2025-03-31', 'absent', NULL, 9, 'TCO001'),
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




INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES

                                                                                                                                                        ('AT00301', 'UG001', 'ICT2122', 'T', '2025-02-04', 'absent', 'MED011', 1, 'TCO002'),
                                                                                                                                                        ('AT00302', 'UG002', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00303', 'UG003', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00304', 'UG004', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00305', 'UG005', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00306', 'UG006', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00307', 'UG007', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00308', 'UG008', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00309', 'UG009', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00310', 'UG010', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00311', 'UG011', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00312', 'UG012', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00313', 'UG013', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00314', 'UG014', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00315', 'UG015', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00316', 'UG016', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00317', 'UG017', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00318', 'UG018', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00319', 'UG019', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00320', 'UG020', 'ICT2122', 'T', '2025-02-04', 'present', NULL, 1, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00321', 'UG001', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00322', 'UG002', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00323', 'UG003', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00324', 'UG004', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00325', 'UG005', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00326', 'UG006', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00327', 'UG007', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00328', 'UG008', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00329', 'UG009', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00330', 'UG010', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00331', 'UG011', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00332', 'UG012', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00333', 'UG013', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00334', 'UG014', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00335', 'UG015', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00336', 'UG016', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00337', 'UG017', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00338', 'UG018', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00339', 'UG019', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00340', 'UG020', 'ICT2122', 'T', '2025-02-11', 'present', NULL, 2, 'TCO002');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00341', 'UG001', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00342', 'UG002', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00343', 'UG003', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00344', 'UG004', 'ICT2122', 'T', '2025-02-18', 'absent', 'MED013', 3, 'TCO002'),
                                                                                                                                                        ('AT00345', 'UG005', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00346', 'UG006', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00347', 'UG007', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00348', 'UG008', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00349', 'UG009', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00350', 'UG010', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00351', 'UG011', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00352', 'UG012', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00353', 'UG013', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00354', 'UG014', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00355', 'UG015', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00356', 'UG016', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00357', 'UG017', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00358', 'UG018', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00359', 'UG019', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00360', 'UG020', 'ICT2122', 'T', '2025-02-18', 'present', NULL, 3, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00361', 'UG001', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00362', 'UG002', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00363', 'UG003', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00364', 'UG004', 'ICT2122', 'T', '2025-02-25', 'absent', 'MED012', 4, 'TCO002'),
                                                                                                                                                        ('AT00365', 'UG005', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00366', 'UG006', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00367', 'UG007', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00368', 'UG008', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00369', 'UG009', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00370', 'UG010', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00371', 'UG011', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00372', 'UG012', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00373', 'UG013', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00374', 'UG014', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00375', 'UG015', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00376', 'UG016', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00377', 'UG017', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00378', 'UG018', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00379', 'UG019', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00380', 'UG020', 'ICT2122', 'T', '2025-02-25', 'present', NULL, 4, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00381', 'UG001', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00382', 'UG002', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00383', 'UG003', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00384', 'UG004', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00385', 'UG005', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00386', 'UG006', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00387', 'UG007', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00388', 'UG008', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00389', 'UG009', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00390', 'UG010', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00391', 'UG011', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00392', 'UG012', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00393', 'UG013', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00394', 'UG014', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00395', 'UG015', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00396', 'UG016', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00397', 'UG017', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00398', 'UG018', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00399', 'UG019', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00400', 'UG020', 'ICT2122', 'T', '2025-03-04', 'present', NULL, 5, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00401', 'UG001', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00402', 'UG002', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00403', 'UG003', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00404', 'UG004', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00405', 'UG005', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00406', 'UG006', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00407', 'UG007', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00408', 'UG008', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00409', 'UG009', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00410', 'UG010', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00411', 'UG011', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00412', 'UG012', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00413', 'UG013', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00414', 'UG014', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00415', 'UG015', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00416', 'UG016', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00417', 'UG017', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00418', 'UG018', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00419', 'UG019', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00420', 'UG020', 'ICT2122', 'T', '2025-03-11', 'present', NULL, 6, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00421', 'UG001', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00422', 'UG002', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00423', 'UG003', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00424', 'UG004', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00425', 'UG005', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00426', 'UG006', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00427', 'UG007', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00428', 'UG008', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00429', 'UG009', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00430', 'UG010', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00431', 'UG011', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00432', 'UG012', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00433', 'UG013', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00434', 'UG014', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00435', 'UG015', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00436', 'UG016', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00437', 'UG017', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00438', 'UG018', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00439', 'UG019', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00440', 'UG020', 'ICT2122', 'T', '2025-03-18', 'present', NULL, 7, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00441', 'UG001', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00442', 'UG002', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00443', 'UG003', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00444', 'UG004', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00445', 'UG005', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00446', 'UG006', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00447', 'UG007', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00448', 'UG008', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00449', 'UG009', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00450', 'UG010', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00451', 'UG011', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00452', 'UG012', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00453', 'UG013', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00454', 'UG014', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00455', 'UG015', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00456', 'UG016', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00457', 'UG017', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00458', 'UG018', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00459', 'UG019', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00460', 'UG020', 'ICT2122', 'T', '2025-03-25', 'present', NULL, 8, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code,at_course_type, date, attendance, medical_status,session_no, at_to_id) VALUES
                                                                                                                                                      ('AT00461', 'UG001', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00462', 'UG002', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00463', 'UG003', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00464', 'UG004', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00465', 'UG005', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00466', 'UG006', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00467', 'UG007', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00468', 'UG008', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00469', 'UG009', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00470', 'UG010', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00471', 'UG011', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00472', 'UG012', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00473', 'UG013', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00474', 'UG014', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00475', 'UG015', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00476', 'UG016', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00477', 'UG017', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00478', 'UG018', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00479', 'UG019', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                      ('AT00480', 'UG020', 'ICT2122', 'T', '2025-04-01', 'present', NULL, 9, 'TCO002');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00481', 'UG001', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00482', 'UG002', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00483', 'UG003', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00484', 'UG004', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00485', 'UG005', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00486', 'UG006', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00487', 'UG007', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00488', 'UG008', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00489', 'UG009', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00490', 'UG010', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00491', 'UG011', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00492', 'UG012', 'ICT2122', 'T', '2025-04-08', 'absent', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00493', 'UG013', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00494', 'UG014', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00495', 'UG015', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00496', 'UG016', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00497', 'UG017', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00498', 'UG018', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00499', 'UG019', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00500', 'UG020', 'ICT2122', 'T', '2025-04-08', 'present', NULL, 10, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00501', 'UG001', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00502', 'UG002', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00503', 'UG003', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00504', 'UG004', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00505', 'UG005', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00506', 'UG006', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00507', 'UG007', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00508', 'UG008', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00509', 'UG009', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00510', 'UG010', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00511', 'UG011', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00512', 'UG012', 'ICT2122', 'T', '2025-04-15', 'absent', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00513', 'UG013', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00514', 'UG014', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00515', 'UG015', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00516', 'UG016', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00517', 'UG017', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00518', 'UG018', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00519', 'UG019', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00520', 'UG020', 'ICT2122', 'T', '2025-04-15', 'present', NULL, 11, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00521', 'UG001', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00522', 'UG002', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00523', 'UG003', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00524', 'UG004', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00525', 'UG005', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00526', 'UG006', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00527', 'UG007', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00528', 'UG008', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00529', 'UG009', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00530', 'UG010', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00531', 'UG011', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00532', 'UG012', 'ICT2122', 'T', '2025-04-22', 'absent', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00533', 'UG013', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00534', 'UG014', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00535', 'UG015', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00536', 'UG016', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00537', 'UG017', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00538', 'UG018', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00539', 'UG019', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00540', 'UG020', 'ICT2122', 'T', '2025-04-22', 'present', NULL, 12, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00541', 'UG001', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00542', 'UG002', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00543', 'UG003', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00544', 'UG004', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00545', 'UG005', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00546', 'UG006', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00547', 'UG007', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00548', 'UG008', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00549', 'UG009', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00550', 'UG010', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00551', 'UG011', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00552', 'UG012', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00553', 'UG013', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00554', 'UG014', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00555', 'UG015', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00556', 'UG016', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00557', 'UG017', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00558', 'UG018', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00559', 'UG019', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00560', 'UG020', 'ICT2122', 'T', '2025-04-29', 'present', NULL, 13, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00561', 'UG001', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00562', 'UG002', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00563', 'UG003', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00564', 'UG004', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00565', 'UG005', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00566', 'UG006', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00567', 'UG007', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00568', 'UG008', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00569', 'UG009', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00570', 'UG010', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00571', 'UG011', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00572', 'UG012', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00573', 'UG013', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00574', 'UG014', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00575', 'UG015', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00576', 'UG016', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00577', 'UG017', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00578', 'UG018', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00579', 'UG019', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00580', 'UG020', 'ICT2122', 'T', '2025-05-06', 'present', NULL, 14, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00581', 'UG001', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00582', 'UG002', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00583', 'UG003', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00584', 'UG004', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00585', 'UG005', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00586', 'UG006', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00587', 'UG007', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00588', 'UG008', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00589', 'UG009', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00590', 'UG010', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00591', 'UG011', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00592', 'UG012', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00593', 'UG013', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00594', 'UG014', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00595', 'UG015', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00596', 'UG016', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00597', 'UG017', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00598', 'UG018', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00599', 'UG019', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00600', 'UG020', 'ICT2122', 'T', '2025-05-13', 'present', NULL, 15, 'TCO002');



INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00601', 'UG001', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00602', 'UG002', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00603', 'UG003', 'ICT2142', 'P', '2025-02-04', 'absent', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00604', 'UG004', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00605', 'UG005', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00606', 'UG006', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00607', 'UG007', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00608', 'UG008', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00609', 'UG009', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00610', 'UG010', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00611', 'UG011', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00612', 'UG012', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00613', 'UG013', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00614', 'UG014', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00615', 'UG015', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00616', 'UG016', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00617', 'UG017', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00618', 'UG018', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00619', 'UG019', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002'),
                                                                                                                                                        ('AT00620', 'UG020', 'ICT2142', 'P', '2025-02-04', 'present', NULL, 1, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00621', 'UG001', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00622', 'UG002', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00623', 'UG003', 'ICT2142', 'P', '2025-02-11', 'absent', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00624', 'UG004', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00625', 'UG005', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00626', 'UG006', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00627', 'UG007', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00628', 'UG008', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00629', 'UG009', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00630', 'UG010', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00631', 'UG011', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00632', 'UG012', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00633', 'UG013', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00634', 'UG014', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00635', 'UG015', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00636', 'UG016', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00637', 'UG017', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00638', 'UG018', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00639', 'UG019', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002'),
                                                                                                                                                        ('AT00640', 'UG020', 'ICT2142', 'P', '2025-02-11', 'present', NULL, 2, 'TCO002');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00641', 'UG001', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00642', 'UG002', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00643', 'UG003', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00644', 'UG004', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00645', 'UG005', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00646', 'UG006', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00647', 'UG007', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00648', 'UG008', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00649', 'UG009', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00650', 'UG010', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00651', 'UG011', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00652', 'UG012', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00653', 'UG013', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00654', 'UG014', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00655', 'UG015', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00656', 'UG016', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00657', 'UG017', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00658', 'UG018', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00659', 'UG019', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002'),
                                                                                                                                                        ('AT00660', 'UG020', 'ICT2142', 'P', '2025-02-18', 'present', NULL, 3, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00661', 'UG001', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00662', 'UG002', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00663', 'UG003', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00664', 'UG004', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00665', 'UG005', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00666', 'UG006', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00667', 'UG007', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00668', 'UG008', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00669', 'UG009', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00670', 'UG010', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00671', 'UG011', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00672', 'UG012', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00673', 'UG013', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00674', 'UG014', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00675', 'UG015', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00676', 'UG016', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00677', 'UG017', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00678', 'UG018', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00679', 'UG019', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002'),
                                                                                                                                                        ('AT00680', 'UG020', 'ICT2142', 'P', '2025-02-25', 'present', NULL, 4, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00681', 'UG001', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00682', 'UG002', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00683', 'UG003', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00684', 'UG004', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00685', 'UG005', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00686', 'UG006', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00687', 'UG007', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00688', 'UG008', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00689', 'UG009', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00690', 'UG010', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00691', 'UG011', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00692', 'UG012', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00693', 'UG013', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00694', 'UG014', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00695', 'UG015', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00696', 'UG016', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00697', 'UG017', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00698', 'UG018', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00699', 'UG019', 'ICT2142', 'P', '2025-03-04', 'absent', NULL, 5, 'TCO002'),
                                                                                                                                                        ('AT00700', 'UG020', 'ICT2142', 'P', '2025-03-04', 'present', NULL, 5, 'TCO002');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00701', 'UG001', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00702', 'UG002', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00703', 'UG003', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00704', 'UG004', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00705', 'UG005', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00706', 'UG006', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00707', 'UG007', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00708', 'UG008', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00709', 'UG009', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00710', 'UG010', 'ICT2142', 'P', '2025-03-11', 'absent', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00711', 'UG011', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00712', 'UG012', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00713', 'UG013', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00714', 'UG014', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00715', 'UG015', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00716', 'UG016', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00717', 'UG017', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00718', 'UG018', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00719', 'UG019', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002'),
                                                                                                                                                        ('AT00720', 'UG020', 'ICT2142', 'P', '2025-03-11', 'present', NULL, 6, 'TCO002');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00721', 'UG001', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00722', 'UG002', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00723', 'UG003', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00724', 'UG004', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00725', 'UG005', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00726', 'UG006', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00727', 'UG007', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00728', 'UG008', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00729', 'UG009', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00730', 'UG010', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00731', 'UG011', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00732', 'UG012', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00733', 'UG013', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00734', 'UG014', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00735', 'UG015', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00736', 'UG016', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00737', 'UG017', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00738', 'UG018', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00739', 'UG019', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002'),
                                                                                                                                                        ('AT00740', 'UG020', 'ICT2142', 'P', '2025-03-18', 'present', NULL, 7, 'TCO002');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00741', 'UG001', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00742', 'UG002', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00743', 'UG003', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00744', 'UG004', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00745', 'UG005', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00746', 'UG006', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00747', 'UG007', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00748', 'UG008', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00749', 'UG009', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00750', 'UG010', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00751', 'UG011', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00752', 'UG012', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00753', 'UG013', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00754', 'UG014', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00755', 'UG015', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00756', 'UG016', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00757', 'UG017', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00758', 'UG018', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00759', 'UG019', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002'),
                                                                                                                                                        ('AT00760', 'UG020', 'ICT2142', 'P', '2025-03-25', 'present', NULL, 8, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00761', 'UG001', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00762', 'UG002', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00763', 'UG003', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00764', 'UG004', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00765', 'UG005', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00766', 'UG006', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00767', 'UG007', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00768', 'UG008', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00769', 'UG009', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00770', 'UG010', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00771', 'UG011', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00772', 'UG012', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00773', 'UG013', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00774', 'UG014', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00775', 'UG015', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00776', 'UG016', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00777', 'UG017', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00778', 'UG018', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00779', 'UG019', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002'),
                                                                                                                                                        ('AT00780', 'UG020', 'ICT2142', 'P', '2025-04-01', 'present', NULL, 9, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00781', 'UG001', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00782', 'UG002', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00783', 'UG003', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00784', 'UG004', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00785', 'UG005', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00786', 'UG006', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00787', 'UG007', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00788', 'UG008', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00789', 'UG009', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00790', 'UG010', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00791', 'UG011', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00792', 'UG012', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00793', 'UG013', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00794', 'UG014', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00795', 'UG015', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00796', 'UG016', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00797', 'UG017', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00798', 'UG018', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00799', 'UG019', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002'),
                                                                                                                                                        ('AT00800', 'UG020', 'ICT2142', 'P', '2025-04-08', 'present', NULL, 10, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00801', 'UG001', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00802', 'UG002', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00803', 'UG003', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00804', 'UG004', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00805', 'UG005', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00806', 'UG006', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00807', 'UG007', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00808', 'UG008', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00809', 'UG009', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00810', 'UG010', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00811', 'UG011', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00812', 'UG012', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00813', 'UG013', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00814', 'UG014', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00815', 'UG015', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00816', 'UG016', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00817', 'UG017', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00818', 'UG018', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00819', 'UG019', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002'),
                                                                                                                                                        ('AT00820', 'UG020', 'ICT2142', 'P', '2025-04-15', 'present', NULL, 11, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00821', 'UG001', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00822', 'UG002', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00823', 'UG003', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00824', 'UG004', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00825', 'UG005', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00826', 'UG006', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00827', 'UG007', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00828', 'UG008', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00829', 'UG009', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00830', 'UG010', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00831', 'UG011', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00832', 'UG012', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00833', 'UG013', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00834', 'UG014', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00835', 'UG015', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00836', 'UG016', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00837', 'UG017', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00838', 'UG018', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00839', 'UG019', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002'),
                                                                                                                                                        ('AT00840', 'UG020', 'ICT2142', 'P', '2025-04-22', 'present', NULL, 12, 'TCO002');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00841', 'UG001', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00842', 'UG002', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00843', 'UG003', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00844', 'UG004', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00845', 'UG005', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00846', 'UG006', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00847', 'UG007', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00848', 'UG008', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00849', 'UG009', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00850', 'UG010', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00851', 'UG011', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00852', 'UG012', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00853', 'UG013', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00854', 'UG014', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00855', 'UG015', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00856', 'UG016', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00857', 'UG017', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00858', 'UG018', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00859', 'UG019', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002'),
                                                                                                                                                        ('AT00860', 'UG020', 'ICT2142', 'P', '2025-04-29', 'present', NULL, 13, 'TCO002');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00861', 'UG001', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00862', 'UG002', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00863', 'UG003', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00864', 'UG004', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00865', 'UG005', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00866', 'UG006', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00867', 'UG007', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00868', 'UG008', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00869', 'UG009', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00870', 'UG010', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00871', 'UG011', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00872', 'UG012', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00873', 'UG013', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00874', 'UG014', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00875', 'UG015', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00876', 'UG016', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00877', 'UG017', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00878', 'UG018', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00879', 'UG019', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002'),
                                                                                                                                                        ('AT00880', 'UG020', 'ICT2142', 'P', '2025-05-06', 'present', NULL, 14, 'TCO002');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00881', 'UG001', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00882', 'UG002', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00883', 'UG003', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00884', 'UG004', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00885', 'UG005', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00886', 'UG006', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00887', 'UG007', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00888', 'UG008', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00889', 'UG009', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00890', 'UG010', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00891', 'UG011', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00892', 'UG012', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00893', 'UG013', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00894', 'UG014', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00895', 'UG015', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00896', 'UG016', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00897', 'UG017', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00898', 'UG018', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00899', 'UG019', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002'),
                                                                                                                                                        ('AT00900', 'UG020', 'ICT2142', 'P', '2025-05-13', 'present', NULL, 15, 'TCO002');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00901', 'UG001', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00902', 'UG002', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00903', 'UG003', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00904', 'UG004', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00905', 'UG005', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00906', 'UG006', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00907', 'UG007', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00908', 'UG008', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00909', 'UG009', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00910', 'UG010', 'ICT2133', 'TP', '2025-02-05', 'absent', 'MED014', 1, 'TCO003'),
                                                                                                                                                        ('AT00911', 'UG011', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00912', 'UG012', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00913', 'UG013', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00914', 'UG014', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00915', 'UG015', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00916', 'UG016', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00917', 'UG017', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00918', 'UG018', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00919', 'UG019', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003'),
                                                                                                                                                        ('AT00920', 'UG020', 'ICT2133', 'TP', '2025-02-05', 'present', NULL, 1, 'TCO003');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00921', 'UG001', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00922', 'UG002', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00923', 'UG003', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00924', 'UG004', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00925', 'UG005', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00926', 'UG006', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00927', 'UG007', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00928', 'UG008', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00929', 'UG009', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00930', 'UG010', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00931', 'UG011', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00932', 'UG012', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00933', 'UG013', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00934', 'UG014', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00935', 'UG015', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00936', 'UG016', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00937', 'UG017', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00938', 'UG018', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00939', 'UG019', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003'),
                                                                                                                                                        ('AT00940', 'UG020', 'ICT2133', 'TP', '2025-02-12', 'present', NULL, 2, 'TCO003');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00941', 'UG001', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00942', 'UG002', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00943', 'UG003', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00944', 'UG004', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00945', 'UG005', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00946', 'UG006', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00947', 'UG007', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00948', 'UG008', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00949', 'UG009', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00950', 'UG010', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00951', 'UG011', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00952', 'UG012', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00953', 'UG013', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00954', 'UG014', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00955', 'UG015', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00956', 'UG016', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00957', 'UG017', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00958', 'UG018', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00959', 'UG019', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003'),
                                                                                                                                                        ('AT00960', 'UG020', 'ICT2133', 'TP', '2025-02-19', 'present', NULL, 3, 'TCO003');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00961', 'UG001', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00962', 'UG002', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00963', 'UG003', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00964', 'UG004', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00965', 'UG005', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00966', 'UG006', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00967', 'UG007', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00968', 'UG008', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00969', 'UG009', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00970', 'UG010', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00971', 'UG011', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00972', 'UG012', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00973', 'UG013', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00974', 'UG014', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00975', 'UG015', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00976', 'UG016', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00977', 'UG017', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00978', 'UG018', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00979', 'UG019', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003'),
                                                                                                                                                        ('AT00980', 'UG020', 'ICT2133', 'TP', '2025-02-26', 'present', NULL, 4, 'TCO003');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT00981', 'UG001', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00982', 'UG002', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00983', 'UG003', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00984', 'UG004', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00985', 'UG005', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00986', 'UG006', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00987', 'UG007', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00988', 'UG008', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00989', 'UG009', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00990', 'UG010', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00991', 'UG011', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00992', 'UG012', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00993', 'UG013', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00994', 'UG014', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00995', 'UG015', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00996', 'UG016', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00997', 'UG017', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00998', 'UG018', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT00999', 'UG019', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003'),
                                                                                                                                                        ('AT01000', 'UG020', 'ICT2133', 'TP', '2025-03-05', 'present', NULL, 5, 'TCO003');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT1001', 'UG001', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1002', 'UG002', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1003', 'UG003', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1004', 'UG004', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1005', 'UG005', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1006', 'UG006', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1007', 'UG007', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1008', 'UG008', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1009', 'UG009', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1010', 'UG010', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1011', 'UG011', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1012', 'UG012', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1013', 'UG013', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1014', 'UG014', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1015', 'UG015', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1016', 'UG016', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1017', 'UG017', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1018', 'UG018', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1019', 'UG019', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003'),
                                                                                                                                                        ('AT1020', 'UG020', 'ICT2133', 'TP', '2025-03-12', 'present', NULL, 6, 'TCO003');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT1021', 'UG001', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1022', 'UG002', 'ICT2133', 'TP', '2025-03-19', 'absent', 'MED015', 7, 'TCO003'),
                                                                                                                                                        ('AT1023', 'UG003', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1024', 'UG004', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1025', 'UG005', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1026', 'UG006', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1027', 'UG007', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1028', 'UG008', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1029', 'UG009', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1030', 'UG010', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1031', 'UG011', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1032', 'UG012', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1033', 'UG013', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1034', 'UG014', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1035', 'UG015', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1036', 'UG016', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1037', 'UG017', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1038', 'UG018', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1039', 'UG019', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003'),
                                                                                                                                                        ('AT1040', 'UG020', 'ICT2133', 'TP', '2025-03-19', 'present', NULL, 7, 'TCO003');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT1041', 'UG001', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1042', 'UG002', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1043', 'UG003', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1044', 'UG004', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1045', 'UG005', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1046', 'UG006', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1047', 'UG007', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1048', 'UG008', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1049', 'UG009', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1050', 'UG010', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1051', 'UG011', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1052', 'UG012', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1053', 'UG013', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1054', 'UG014', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1055', 'UG015', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1056', 'UG016', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1057', 'UG017', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1058', 'UG018', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1059', 'UG019', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003'),
                                                                                                                                                        ('AT1060', 'UG020', 'ICT2133', 'TP', '2025-03-26', 'present', NULL, 8, 'TCO003');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01061', 'UG001', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01062', 'UG002', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01063', 'UG003', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01064', 'UG004', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01065', 'UG005', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01066', 'UG006', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01067', 'UG007', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01068', 'UG008', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01069', 'UG009', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01070', 'UG010', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01071', 'UG011', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01072', 'UG012', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01073', 'UG013', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01074', 'UG014', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01075', 'UG015', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01076', 'UG016', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01077', 'UG017', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01078', 'UG018', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01079', 'UG019', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003'),
                                                                                                                                                        ('AT01080', 'UG020', 'ICT2133', 'TP', '2025-04-02', 'present', NULL, 9, 'TCO003');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01081', 'UG001', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01082', 'UG002', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01083', 'UG003', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01084', 'UG004', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01085', 'UG005', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01086', 'UG006', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01087', 'UG007', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01088', 'UG008', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01089', 'UG009', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01090', 'UG010', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01091', 'UG011', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01092', 'UG012', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01093', 'UG013', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01094', 'UG014', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01095', 'UG015', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01096', 'UG016', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01097', 'UG017', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01098', 'UG018', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01099', 'UG019', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003'),
                                                                                                                                                        ('AT01100', 'UG020', 'ICT2133', 'TP', '2025-04-09', 'present', NULL, 10, 'TCO003');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01101', 'UG001', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01102', 'UG002', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01103', 'UG003', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01104', 'UG004', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01105', 'UG005', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01106', 'UG006', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01107', 'UG007', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01108', 'UG008', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01109', 'UG009', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01110', 'UG010', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01111', 'UG011', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01112', 'UG012', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01113', 'UG013', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01114', 'UG014', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01115', 'UG015', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01116', 'UG016', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01117', 'UG017', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01118', 'UG018', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01119', 'UG019', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003'),
                                                                                                                                                        ('AT01120', 'UG020', 'ICT2133', 'TP', '2025-04-16', 'present', NULL, 11, 'TCO003');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01121', 'UG001', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01122', 'UG002', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01123', 'UG003', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01124', 'UG004', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01125', 'UG005', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01126', 'UG006', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01127', 'UG007', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01128', 'UG008', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01129', 'UG009', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01130', 'UG010', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01131', 'UG011', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01132', 'UG012', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01133', 'UG013', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01134', 'UG014', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01135', 'UG015', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01136', 'UG016', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01137', 'UG017', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01138', 'UG018', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01139', 'UG019', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003'),
                                                                                                                                                        ('AT01140', 'UG020', 'ICT2133', 'TP', '2025-04-23', 'present', NULL, 12, 'TCO003');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01141', 'UG001', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01142', 'UG002', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01143', 'UG003', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01144', 'UG004', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01145', 'UG005', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01146', 'UG006', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01147', 'UG007', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01148', 'UG008', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01149', 'UG009', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01150', 'UG010', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01151', 'UG011', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01152', 'UG012', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01153', 'UG013', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01154', 'UG014', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01155', 'UG015', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01156', 'UG016', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01157', 'UG017', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01158', 'UG018', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01159', 'UG019', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003'),
                                                                                                                                                        ('AT01160', 'UG020', 'ICT2133', 'TP', '2025-04-30', 'present', NULL, 13, 'TCO003');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01161', 'UG001', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01162', 'UG002', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01163', 'UG003', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01164', 'UG004', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01165', 'UG005', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01166', 'UG006', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01167', 'UG007', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01168', 'UG008', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01169', 'UG009', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01170', 'UG010', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01171', 'UG011', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01172', 'UG012', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01173', 'UG013', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01174', 'UG014', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01175', 'UG015', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01176', 'UG016', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01177', 'UG017', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01178', 'UG018', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01179', 'UG019', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003'),
                                                                                                                                                        ('AT01180', 'UG020', 'ICT2133', 'TP', '2025-05-07', 'present', NULL, 14, 'TCO003');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01181', 'UG001', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01182', 'UG002', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01183', 'UG003', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01184', 'UG004', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01185', 'UG005', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01186', 'UG006', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01187', 'UG007', 'ICT2133', 'TP', '2025-05-14', 'absent', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01188', 'UG008', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01189', 'UG009', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01190', 'UG010', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01191', 'UG011', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01192', 'UG012', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01193', 'UG013', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01194', 'UG014', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01195', 'UG015', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01196', 'UG016', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01197', 'UG017', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01198', 'UG018', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01199', 'UG019', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003'),
                                                                                                                                                        ('AT01200', 'UG020', 'ICT2133', 'TP', '2025-05-14', 'present', NULL, 15, 'TCO003');



INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01201', 'UG001', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01202', 'UG002', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01203', 'UG003', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01204', 'UG004', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01205', 'UG005', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01206', 'UG006', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01207', 'UG007', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01208', 'UG008', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01209', 'UG009', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01210', 'UG010', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01211', 'UG011', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01212', 'UG012', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01213', 'UG013', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01214', 'UG014', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01215', 'UG015', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01216', 'UG016', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01217', 'UG017', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01218', 'UG018', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01219', 'UG019', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004'),
                                                                                                                                                        ('AT01220', 'UG020', 'ICT2152', 'T', '2025-02-07', 'present', NULL, 1, 'TCO004');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01221', 'UG001', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01222', 'UG002', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01223', 'UG003', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01224', 'UG004', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01225', 'UG005', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01226', 'UG006', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01227', 'UG007', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01228', 'UG008', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01229', 'UG009', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01230', 'UG010', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01231', 'UG011', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01232', 'UG012', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01233', 'UG013', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01234', 'UG014', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01235', 'UG015', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01236', 'UG016', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01237', 'UG017', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01238', 'UG018', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01239', 'UG019', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('AT01240', 'UG020', 'ICT2152', 'T', '2025-02-13', 'present', NULL, 2, 'TCO004');
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01241', 'UG001', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01242', 'UG002', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01243', 'UG003', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01244', 'UG004', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01245', 'UG005', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01246', 'UG006', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01247', 'UG007', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01248', 'UG008', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01249', 'UG009', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01250', 'UG010', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01251', 'UG011', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01252', 'UG012', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01253', 'UG013', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01254', 'UG014', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01255', 'UG015', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01256', 'UG016', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01257', 'UG017', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01258', 'UG018', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01259', 'UG019', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('AT01260', 'UG020', 'ICT2152', 'T', '2025-02-20', 'present', NULL, 3, 'TCO004');
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01261', 'UG001', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01262', 'UG002', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01263', 'UG003', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01264', 'UG004', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01265', 'UG005', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01266', 'UG006', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01267', 'UG007', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01268', 'UG008', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01269', 'UG009', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01270', 'UG010', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01271', 'UG011', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01272', 'UG012', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01273', 'UG013', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01274', 'UG014', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01275', 'UG015', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01276', 'UG016', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01277', 'UG017', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01278', 'UG018', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01279', 'UG019', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004'),
                                                                                                                                                        ('AT01280', 'UG020', 'ICT2152', 'T', '2025-02-27', 'present', NULL, 4, 'TCO004');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01281', 'UG001', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01282', 'UG002', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01283', 'UG003', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01284', 'UG004', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01285', 'UG005', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01286', 'UG006', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01287', 'UG007', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01288', 'UG008', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01289', 'UG009', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01290', 'UG010', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01291', 'UG011', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01292', 'UG012', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01293', 'UG013', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01294', 'UG014', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01295', 'UG015', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01296', 'UG016', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01297', 'UG017', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01298', 'UG018', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01299', 'UG019', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01300', 'UG020', 'ICT2152', 'T', '2025-03-06', 'present', NULL, 5, 'TCO004');
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01301', 'UG001', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01302', 'UG002', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01303', 'UG003', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01304', 'UG004', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01305', 'UG005', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01306', 'UG006', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01307', 'UG007', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01308', 'UG008', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01309', 'UG009', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01310', 'UG010', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01311', 'UG011', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01312', 'UG012', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01313', 'UG013', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01314', 'UG014', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01315', 'UG015', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01316', 'UG016', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01317', 'UG017', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01318', 'UG018', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01319', 'UG019', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('AT01320', 'UG020', 'ICT2152', 'T', '2025-03-13', 'present', NULL, 6, 'TCO004');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01321', 'UG001', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01322', 'UG002', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01323', 'UG003', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01324', 'UG004', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01325', 'UG005', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01326', 'UG006', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01327', 'UG007', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01328', 'UG008', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01329', 'UG009', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01330', 'UG010', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01331', 'UG011', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01332', 'UG012', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01333', 'UG013', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01334', 'UG014', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01335', 'UG015', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01336', 'UG016', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01337', 'UG017', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01338', 'UG018', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01339', 'UG019', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004'),
                                                                                                                                                        ('AT01340', 'UG020', 'ICT2152', 'T', '2025-03-20', 'present', NULL, 7, 'TCO004');
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01341', 'UG001', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01342', 'UG002', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01343', 'UG003', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01344', 'UG004', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01345', 'UG005', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01346', 'UG006', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01347', 'UG007', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01348', 'UG008', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01349', 'UG009', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01350', 'UG010', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01351', 'UG011', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01352', 'UG012', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01353', 'UG013', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01354', 'UG014', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01355', 'UG015', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01356', 'UG016', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01357', 'UG017', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01358', 'UG018', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01359', 'UG019', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004'),
                                                                                                                                                        ('AT01360', 'UG020', 'ICT2152', 'T', '2025-03-27', 'present', NULL, 8, 'TCO004');
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01361', 'UG001', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01362', 'UG002', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01363', 'UG003', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01364', 'UG004', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01365', 'UG005', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01366', 'UG006', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01367', 'UG007', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01368', 'UG008', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01369', 'UG009', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01370', 'UG010', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01371', 'UG011', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01372', 'UG012', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01373', 'UG013', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01374', 'UG014', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01375', 'UG015', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01376', 'UG016', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01377', 'UG017', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01378', 'UG018', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01379', 'UG019', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004'),
                                                                                                                                                        ('AT01380', 'UG020', 'ICT2152', 'T', '2025-04-03', 'present', NULL, 9, 'TCO004');
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01381', 'UG001', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01382', 'UG002', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01383', 'UG003', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01384', 'UG004', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01385', 'UG005', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01386', 'UG006', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01387', 'UG007', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01388', 'UG008', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01389', 'UG009', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01390', 'UG010', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01391', 'UG011', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01392', 'UG012', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01393', 'UG013', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01394', 'UG014', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01395', 'UG015', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01396', 'UG016', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01397', 'UG017', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01398', 'UG018', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01399', 'UG019', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004'),
                                                                                                                                                        ('AT01400', 'UG020', 'ICT2152', 'T', '2025-04-10', 'present', NULL, 10, 'TCO004');
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01401', 'UG001', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01402', 'UG002', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01403', 'UG003', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01404', 'UG004', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01405', 'UG005', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01406', 'UG006', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01407', 'UG007', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01408', 'UG008', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01409', 'UG009', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01410', 'UG010', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01411', 'UG011', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01412', 'UG012', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01413', 'UG013', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01414', 'UG014', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01415', 'UG015', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01416', 'UG016', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01417', 'UG017', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01418', 'UG018', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01419', 'UG019', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004'),
                                                                                                                                                        ('AT01420', 'UG020', 'ICT2152', 'T', '2025-04-17', 'present', NULL, 11, 'TCO004');
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01421', 'UG001', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01422', 'UG002', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01423', 'UG003', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01424', 'UG004', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01425', 'UG005', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01426', 'UG006', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01427', 'UG007', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01428', 'UG008', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01429', 'UG009', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01430', 'UG010', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01431', 'UG011', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01432', 'UG012', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01433', 'UG013', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01434', 'UG014', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01435', 'UG015', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01436', 'UG016', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01437', 'UG017', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01438', 'UG018', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01439', 'UG019', 'ICT2152', 'T', '2025-04-24', 'present', NULL, 12, 'TCO004'),
                                                                                                                                                        ('AT01440', 'UG020', 'ICT2152', 'T', '2025-04-24', 'absent', NULL, 12, 'TCO004');
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01441', 'UG001', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01442', 'UG002', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01443', 'UG003', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01444', 'UG004', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01445', 'UG005', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01446', 'UG006', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01447', 'UG007', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01448', 'UG008', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01449', 'UG009', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01450', 'UG010', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01451', 'UG011', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01452', 'UG012', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01453', 'UG013', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01454', 'UG014', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01455', 'UG015', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01456', 'UG016', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01457', 'UG017', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01458', 'UG018', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01459', 'UG019', 'ICT2152', 'T', '2025-04-01', 'present', NULL, 13, 'TCO004'),
                                                                                                                                                        ('AT01460', 'UG020', 'ICT2152', 'T', '2025-04-01', 'absent', 'MED016', 13, 'TCO004');
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01461', 'UG001', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01462', 'UG002', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01463', 'UG003', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01464', 'UG004', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01465', 'UG005', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01466', 'UG006', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01467', 'UG007', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01468', 'UG008', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01469', 'UG009', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01470', 'UG010', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01471', 'UG011', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01472', 'UG012', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01473', 'UG013', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01474', 'UG014', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01475', 'UG015', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01476', 'UG016', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01477', 'UG017', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01478', 'UG018', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01479', 'UG019', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004'),
                                                                                                                                                        ('AT01480', 'UG020', 'ICT2152', 'T', '2025-04-08', 'present', NULL, 14, 'TCO004');
INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01481', 'UG001', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01482', 'UG002', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01483', 'UG003', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01484', 'UG004', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01485', 'UG005', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01486', 'UG006', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01487', 'UG007', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01488', 'UG008', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01489', 'UG009', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01490', 'UG010', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01491', 'UG011', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01492', 'UG012', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01493', 'UG013', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01494', 'UG014', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01495', 'UG015', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01496', 'UG016', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01497', 'UG017', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01498', 'UG018', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01499', 'UG019', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004'),
                                                                                                                                                        ('AT01500', 'UG020', 'ICT2152', 'T', '2025-04-15', 'present', NULL, 15, 'TCO004');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id)
VALUES
    ('AT01501', 'UG001', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01502', 'UG002', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01503', 'UG003', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01504', 'UG004', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01505', 'UG005', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01506', 'UG006', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01507', 'UG007', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01508', 'UG008', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01509', 'UG009', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01510', 'UG010', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01511', 'UG011', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01512', 'UG012', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01513', 'UG013', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01514', 'UG014', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01515', 'UG015', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01516', 'UG016', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01517', 'UG017', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01518', 'UG018', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01519', 'UG019', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004'),
    ('AT01520', 'UG020', 'ENG2122', 'T', '2025-02-08', 'present', NULL, 1, 'TCO004');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('A1521', 'UG001', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1522', 'UG002', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1523', 'UG003', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1524', 'UG004', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1525', 'UG005', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1526', 'UG006', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1527', 'UG007', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1528', 'UG008', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1529', 'UG009', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1530', 'UG010', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1531', 'UG011', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1532', 'UG012', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1533', 'UG013', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1534', 'UG014', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1535', 'UG015', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1536', 'UG016', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1537', 'UG017', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1538', 'UG018', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1539', 'UG019', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004'),
                                                                                                                                                        ('A1540', 'UG020', 'ENG2122', 'T', '2025-02-14', 'present', NULL, 2, 'TCO004');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('A1541', 'UG001', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1542', 'UG002', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1543', 'UG003', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1544', 'UG004', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1545', 'UG005', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1546', 'UG006', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1547', 'UG007', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1548', 'UG008', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1549', 'UG009', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1550', 'UG010', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1551', 'UG011', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1552', 'UG012', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1553', 'UG013', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1554', 'UG014', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1555', 'UG015', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1556', 'UG016', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1557', 'UG017', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1558', 'UG018', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1559', 'UG019', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004'),
                                                                                                                                                        ('A1560', 'UG020', 'ENG2122', 'T', '2025-02-21', 'present', NULL, 3, 'TCO004');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id)
VALUES
    ('AT01561', 'UG001', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01562', 'UG002', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01563', 'UG003', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01564', 'UG004', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01565', 'UG005', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01566', 'UG006', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01567', 'UG007', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01568', 'UG008', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01569', 'UG009', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01570', 'UG010', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01571', 'UG011', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01572', 'UG012', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01573', 'UG013', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01574', 'UG014', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01575', 'UG015', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01576', 'UG016', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01577', 'UG017', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01578', 'UG018', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01579', 'UG019', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004'),
    ('AT01580', 'UG020', 'ENG2122', 'T', '2025-02-28', 'present', NULL, 4, 'TCO004');



INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('AT01581', 'UG001', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01582', 'UG002', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01583', 'UG003', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01584', 'UG004', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01585', 'UG005', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01586', 'UG006', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01587', 'UG007', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01588', 'UG008', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01589', 'UG009', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01590', 'UG010', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01591', 'UG011', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01592', 'UG012', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01593', 'UG013', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01594', 'UG014', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01595', 'UG015', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01596', 'UG016', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01597', 'UG017', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01598', 'UG018', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01599', 'UG019', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004'),
                                                                                                                                                        ('AT01600', 'UG020', 'ENG2122', 'T', '2025-03-07', 'present', NULL, 5, 'TCO004');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id) VALUES
                                                                                                                                                        ('A1601', 'UG001', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1602', 'UG002', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1603', 'UG003', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1604', 'UG004', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1605', 'UG005', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1606', 'UG006', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1607', 'UG007', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1608', 'UG008', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1609', 'UG009', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1610', 'UG010', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1611', 'UG011', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1612', 'UG012', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1613', 'UG013', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1614', 'UG014', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1615', 'UG015', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1616', 'UG016', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1617', 'UG017', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1618', 'UG018', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1619', 'UG019', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004'),
                                                                                                                                                        ('A1620', 'UG020', 'ENG2122', 'T', '2025-03-14', 'present', NULL, 6, 'TCO004');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id)
VALUES
    ('AT01621', 'UG001', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01622', 'UG002', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01623', 'UG003', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01624', 'UG004', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01625', 'UG005', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01626', 'UG006', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01627', 'UG007', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01628', 'UG008', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01629', 'UG009', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01630', 'UG010', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01631', 'UG011', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01632', 'UG012', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01633', 'UG013', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01634', 'UG014', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01635', 'UG015', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01636', 'UG016', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01637', 'UG017', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01638', 'UG018', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01639', 'UG019', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004'),
    ('AT01640', 'UG020', 'ENG2122', 'T', '2025-03-28', 'present', NULL, 9, 'TCO004');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id)
VALUES
    ('A1661', 'UG001', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1662', 'UG002', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1663', 'UG003', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1664', 'UG004', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1665', 'UG005', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1666', 'UG006', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1667', 'UG007', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1668', 'UG008', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1669', 'UG009', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1670', 'UG010', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1671', 'UG011', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1672', 'UG012', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1673', 'UG013', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1674', 'UG014', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1675', 'UG015', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1676', 'UG016', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1677', 'UG017', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1678', 'UG018', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1679', 'UG019', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004'),
    ('A1680', 'UG020', 'ENG2122', 'T', '2025-04-11', 'present', NULL, 10, 'TCO004');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id)
VALUES
    ('AT01681', 'UG001', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01682', 'UG002', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01683', 'UG003', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01684', 'UG004', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01685', 'UG005', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01686', 'UG006', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01687', 'UG007', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01688', 'UG008', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01689', 'UG009', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01690', 'UG010', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01691', 'UG011', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01692', 'UG012', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01693', 'UG013', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01694', 'UG014', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01695', 'UG015', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01696', 'UG016', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01697', 'UG017', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01698', 'UG018', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01699', 'UG019', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004'),
    ('AT01700', 'UG020', 'ENG2122', 'T', '2025-04-18', 'present', NULL, 11, 'TCO004');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id)
VALUES
    ('A1701', 'UG001', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1702', 'UG002', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1703', 'UG003', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1704', 'UG004', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1705', 'UG005', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1706', 'UG006', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1707', 'UG007', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1708', 'UG008', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1709', 'UG009', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1710', 'UG010', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1711', 'UG011', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1712', 'UG012', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1713', 'UG013', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1714', 'UG014', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1715', 'UG015', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1716', 'UG016', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1717', 'UG017', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1718', 'UG018', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1719', 'UG019', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004'),
    ('A1720', 'UG020', 'ENG2122', 'T', '2025-04-25', 'present', NULL, 12, 'TCO004');

INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id)
VALUES
    ('AT01721', 'UG001', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01722', 'UG002', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01723', 'UG003', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01724', 'UG004', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01725', 'UG005', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01726', 'UG006', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01727', 'UG007', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01728', 'UG008', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01729', 'UG009', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01730', 'UG010', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01731', 'UG011', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01732', 'UG012', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01733', 'UG013', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01734', 'UG014', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01735', 'UG015', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01736', 'UG016', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01737', 'UG017', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01738', 'UG018', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01739', 'UG019', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004'),
    ('AT01740', 'UG020', 'ENG2122', 'T', '2025-05-01', 'present', NULL, 13, 'TCO004');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id)
VALUES
    ('AT01741', 'UG001', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01742', 'UG002', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01743', 'UG003', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01744', 'UG004', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01745', 'UG005', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01746', 'UG006', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01747', 'UG007', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01748', 'UG008', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01749', 'UG009', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01750', 'UG010', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01751', 'UG011', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01752', 'UG012', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01753', 'UG013', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01754', 'UG014', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01755', 'UG015', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01756', 'UG016', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01757', 'UG017', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01758', 'UG018', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01759', 'UG019', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004'),
    ('AT01760', 'UG020', 'ENG2122', 'T', '2025-05-08', 'present', NULL, 14, 'TCO004');


INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id)
VALUES
    ('AT01761', 'UG001', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01762', 'UG002', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01763', 'UG003', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01764', 'UG004', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01765', 'UG005', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01766', 'UG006', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01767', 'UG007', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01768', 'UG008', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01769', 'UG009', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01770', 'UG010', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01771', 'UG011', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01772', 'UG012', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01773', 'UG013', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01774', 'UG014', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01775', 'UG015', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01776', 'UG016', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01777', 'UG017', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01778', 'UG018', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01779', 'UG019', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004'),
    ('AT01780', 'UG020', 'ENG2122', 'T', '2025-05-15', 'present', NULL, 15, 'TCO004');







INSERT INTO Attendance (attendance_id, at_undergraduate_id, at_course_code, at_course_type, date, attendance, medical_status, session_no, at_to_id)
VALUES
    ('AT01781', 'UG001', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01782', 'UG002', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01783', 'UG003', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01784', 'UG004', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01785', 'UG005', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01786', 'UG006', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01787', 'UG007', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01788', 'UG008', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01789', 'UG009', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01790', 'UG010', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01791', 'UG011', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01792', 'UG012', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01793', 'UG013', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01794', 'UG014', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01795', 'UG015', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01796', 'UG016', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01797', 'UG017', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01798', 'UG018', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01799', 'UG019', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004'),
    ('AT01800', 'UG020', 'ENG2122', 'T', '2025-05-22', 'present', NULL, 16, 'TCO004');



INSERT INTO camarks(undergraduate_id, course_code, Quizze01, Quizze02, Quizze03, Quizze04, Assessments01, Midterm) VALUES
                                                                                                                       ('UG001', 'ICT2122', 85, 90, 88, 92, 67, 80),
                                                                                                                       ('UG002', 'ICT2122', 75, 75, 50, 60, 58, 65),
                                                                                                                       ('UG003', 'ICT2122', 50, 45, 35, 48, 40, 50),
                                                                                                                       ('UG004', 'ICT2122', 40, 20, 30, 30, 25, 35),
                                                                                                                       ('UG005', 'ICT2122', 78, 85, 82, 75, 68, 72),
                                                                                                                       ('UG006', 'ICT2122', 60, 65, 70, 72, 64, 70),
                                                                                                                       ('UG007', 'ICT2122', 90, 92, 88, 89, 85, 90),
                                                                                                                       ('UG008', 'ICT2122', 45, 55, 50, 52, 48, 55),
                                                                                                                       ('UG009', 'ICT2122', 82, 79, 85, 86, 72, 78),
                                                                                                                       ('UG010', 'ICT2122', 68, 72, 70, 71, 65, 69),
                                                                                                                       ('UG011', 'ICT2122', 95, 93, 94, 97, 88, 91),
                                                                                                                       ('UG012', 'ICT2122', 88, 85, 90, 89, 83, 87),
                                                                                                                       ('UG013', 'ICT2122', 72, 74, 70, 73, 66, 70),
                                                                                                                       ('UG014', 'ICT2122', 58, 60, 63, 62, 59, 64),
                                                                                                                       ('UG015', 'ICT2122', 80, 77, 79, 78, 70, 75),
                                                                                                                       ('UG016', 'ICT2122', 66, 64, 68, 65, 60, 66),
                                                                                                                       ('UG017', 'ICT2122', 91, 89, 92, 90, 85, 88),
                                                                                                                       ('UG018', 'ICT2122', 53, 50, 56, 55, 52, 58),
                                                                                                                       ('UG019', 'ICT2122', 87, 90, 86, 91, 77, 84),
                                                                                                                       ('UG020', 'ICT2122', 62, 68, 65, 64, 60, 67);





INSERT INTO camarks(undergraduate_id, course_code, Quizze01, Quizze02, Quizze03, Assessments01, Assessments02) VALUES
                                                                                                                   ('UG001', 'ICT2133', 85, 90, 88, 92, 90),
                                                                                                                   ('UG002', 'ICT2133', 78, 81, 75, 80, 79),
                                                                                                                   ('UG003', 'ICT2133', 60, 65, 58, 64, 66),
                                                                                                                   ('UG004', 'ICT2133', 45, 50, 48, 55, 50),
                                                                                                                   ('UG005', 'ICT2133', 82, 85, 80, 83, 84),
                                                                                                                   ('UG006', 'ICT2133', 70, 72, 68, 71, 70),
                                                                                                                   ('UG007', 'ICT2133', 90, 92, 89, 93, 92),
                                                                                                                   ('UG008', 'ICT2133', 55, 58, 60, 59, 58),
                                                                                                                   ('UG009', 'ICT2133', 79, 81, 78, 82, 83),
                                                                                                                   ('UG010', 'ICT2133', 65, 67, 70, 68, 70),
                                                                                                                   ('UG011', 'ICT2133', 93, 95, 94, 96, 94),
                                                                                                                   ('UG012', 'ICT2133', 88, 87, 90, 89, 88),
                                                                                                                   ('UG013', 'ICT2133', 74, 72, 70, 75, 74),
                                                                                                                   ('UG014', 'ICT2133', 60, 62, 65, 63, 65),
                                                                                                                   ('UG015', 'ICT2133', 80, 82, 79, 83, 81),
                                                                                                                   ('UG016', 'ICT2133', 67, 69, 65, 68, 67),
                                                                                                                   ('UG017', 'ICT2133', 91, 89, 93, 90, 91),
                                                                                                                   ('UG018', 'ICT2133', 58, 55, 60, 59, 58),
                                                                                                                   ('UG019', 'ICT2133', 86, 88, 85, 87, 88),
                                                                                                                   ('UG020', 'ICT2133', 95, 90, 68, 92, 67);



INSERT INTO camarks(undergraduate_id, course_code, Assessments01, Midterm) VALUES
                                                                               ('UG001', 'ICT2142', 83, 65),
                                                                               ('UG002', 'ICT2142', 75, 70),
                                                                               ('UG003', 'ICT2142', 60, 55),
                                                                               ('UG004', 'ICT2142', 48, 40),
                                                                               ('UG005', 'ICT2142', 88, 82),
                                                                               ('UG006', 'ICT2142', 72, 69),
                                                                               ('UG007', 'ICT2142', 93, 87),
                                                                               ('UG008', 'ICT2142', 50, 45),
                                                                               ('UG009', 'ICT2142', 80, 78),
                                                                               ('UG010', 'ICT2142', 67, 63),
                                                                               ('UG011', 'ICT2142', 95, 90),
                                                                               ('UG012', 'ICT2142', 84, 80),
                                                                               ('UG013', 'ICT2142', 70, 65),
                                                                               ('UG014', 'ICT2142', 58, 52),
                                                                               ('UG015', 'ICT2142', 76, 73),
                                                                               ('UG016', 'ICT2142', 65, 60),
                                                                               ('UG017', 'ICT2142', 90, 88),
                                                                               ('UG018', 'ICT2142', 53, 50),
                                                                               ('UG019', 'ICT2142', 85, 79),
                                                                               ('UG020', 'ICT2142', 62, 58);


INSERT INTO camarks (undergraduate_id, course_code, Quizze01, Quizze02, Quizze03, Assessments01) VALUES
                                                                                                     ('UG001', 'ICT2152', 70, 65, 60, 80),  -- Pass
                                                                                                     ('UG002', 'ICT2152', 85, 75, 60, 90),  -- Pass
                                                                                                     ('UG003', 'ICT2152', 40, 35, 30, 45),  -- Fail
                                                                                                     ('UG004', 'ICT2152', 95, 85, 90, 95),  -- Pass
                                                                                                     ('UG005', 'ICT2152', 60, 70, 65, 75),  -- Pass
                                                                                                     ('UG006', 'ICT2152', 78, 80, 70, 85),  -- Pass
                                                                                                     ('UG007', 'ICT2152', 90, 92, 88, 91),  -- Pass
                                                                                                     ('UG008', 'ICT2152', 50, 45, 40, 55),  -- Pass
                                                                                                     ('UG009', 'ICT2152', 65, 60, 55, 70),  -- Pass
                                                                                                     ('UG010', 'ICT2152', 88, 90, 85, 89),  -- Pass
                                                                                                     ('UG011', 'ICT2152', 72, 68, 64, 78),  -- Pass
                                                                                                     ('UG012', 'ICT2152', 58, 60, 62, 70),  -- Pass
                                                                                                     ('UG013', 'ICT2152', 95, 93, 90, 94),  -- Pass
                                                                                                     ('UG014', 'ICT2152', 46, 48, 50, 55),  -- Pass
                                                                                                     ('UG015', 'ICT2152', 76, 74, 70, 80),  -- Pass
                                                                                                     ('UG016', 'ICT2152', 67, 69, 65, 73),  -- Pass
                                                                                                     ('UG017', 'ICT2152', 39, 55, 50, 50),  -- Fail
                                                                                                     ('UG018', 'ICT2152', 82, 84, 79, 88),  -- Pass
                                                                                                     ('UG019', 'ICT2152', 75, 80, 70, 85),  -- Pass
                                                                                                     ('UG020', 'ICT2152', 30, 28, 25, 40);  -- Fail





INSERT INTO camarks (undergraduate_id, course_code, Quizze01, Quizze02, Quizze03, Assessments01) VALUES
                                                                                                     ('UG001', 'ENG2122', 70, 65, 60, 80),  -- Pass
                                                                                                     ('UG002', 'ENG2122', 85, 75, 60, 90),  -- Pass
                                                                                                     ('UG003', 'ENG2122', 40, 35, 30, 45),  -- Fail
                                                                                                     ('UG004', 'ENG2122', 95, 85, 90, 95),  -- Pass
                                                                                                     ('UG005', 'ENG2122', 60, 70, 65, 75),  -- Pass
                                                                                                     ('UG006', 'ENG2122', 78, 80, 70, 85),  -- Pass
                                                                                                     ('UG007', 'ENG2122', 90, 92, 88, 91),  -- Pass
                                                                                                     ('UG008', 'ENG2122', 50, 45, 40, 55),  -- Pass
                                                                                                     ('UG009', 'ENG2122', 65, 60, 55, 70),  -- Pass
                                                                                                     ('UG010', 'ENG2122', 88, 90, 85, 89),  -- Pass
                                                                                                     ('UG011', 'ENG2122', 72, 68, 64, 78),  -- Pass
                                                                                                     ('UG012', 'ENG2122', 58, 60, 62, 70),  -- Pass
                                                                                                     ('UG013', 'ENG2122', 95, 93, 90, 94),  -- Pass
                                                                                                     ('UG014', 'ENG2122', 46, 48, 50, 55),  -- Pass
                                                                                                     ('UG015', 'ENG2122', 76, 74, 70, 80),  -- Pass
                                                                                                     ('UG016', 'ENG2122', 67, 69, 65, 73),  -- Pass
                                                                                                     ('UG017', 'ENG2122', 50, 55, 50, 50),  -- Fail
                                                                                                     ('UG018', 'ENG2122', 82, 84, 79, 88),  -- Pass
                                                                                                     ('UG019', 'ENG2122', 75, 80, 70, 85),  -- Pass
                                                                                                     ('UG020', 'ENG2122', 30, 28, 25, 40);  -- Fail





-- ICT2113 (Theory + Practical)
INSERT INTO finalmarks (undergraduate_id, course_code, Finaltheory, Finalpracticaly) VALUES
                                                                                         ('UG001', 'ICT2113', 85, 90),
                                                                                         ('UG002', 'ICT2113', 75, 75),
                                                                                         ('UG003', 'ICT2113', 50, 45),
                                                                                         ('UG004', 'ICT2113', 40, 20),
                                                                                         ('UG005', 'ICT2113', 78, 85),
                                                                                         ('UG006', 'ICT2113', 60, 65),
                                                                                         ('UG007', 'ICT2113', 90, 92),
                                                                                         ('UG008', 'ICT2113', 45, 55),
                                                                                         ('UG009', 'ICT2113', 82, 79),
                                                                                         ('UG010', 'ICT2113', 68, 72),
                                                                                         ('UG011', 'ICT2113', 95, 93),
                                                                                         ('UG012', 'ICT2113', 88, 85),
                                                                                         ('UG013', 'ICT2113', 72, 74),
                                                                                         ('UG014', 'ICT2113', 58, 60),
                                                                                         ('UG015', 'ICT2113', 80, 77),
                                                                                         ('UG016', 'ICT2113', 66, 64),
                                                                                         ('UG017', 'ICT2113', 91, 89),
                                                                                         ('UG018', 'ICT2113', 53, 50),
                                                                                         ('UG019', 'ICT2113', 87, 90),
                                                                                         ('UG020', 'ICT2113', 62, 68);

-- ICT2122 (Theory only)
INSERT INTO finalmarks (undergraduate_id, course_code, Finaltheory) VALUES
                                                                        ('UG001', 'ICT2122', 85),
                                                                        ('UG002', 'ICT2122', 75),
                                                                        ('UG003', 'ICT2122', 50),
                                                                        ('UG004', 'ICT2122', 40),
                                                                        ('UG005', 'ICT2122', 78),
                                                                        ('UG006', 'ICT2122', 60),
                                                                        ('UG007', 'ICT2122', 90),
                                                                        ('UG008', 'ICT2122', 45),
                                                                        ('UG009', 'ICT2122', 82),
                                                                        ('UG010', 'ICT2122', 68),
                                                                        ('UG011', 'ICT2122', 95),
                                                                        ('UG012', 'ICT2122', 88),
                                                                        ('UG013', 'ICT2122', 72),
                                                                        ('UG014', 'ICT2122', 58),
                                                                        ('UG015', 'ICT2122', 80),
                                                                        ('UG016', 'ICT2122', 66),
                                                                        ('UG017', 'ICT2122', 91),
                                                                        ('UG018', 'ICT2122', 53),
                                                                        ('UG019', 'ICT2122', 87),
                                                                        ('UG020', 'ICT2122', 62);

-- ICT2133 (Theory + Practical)
INSERT INTO finalmarks (undergraduate_id, course_code, Finaltheory, Finalpracticaly) VALUES
                                                                                         ('UG001', 'ICT2133', 85, 90),
                                                                                         ('UG002', 'ICT2133', 78, 81),
                                                                                         ('UG003', 'ICT2133', 60, 65),
                                                                                         ('UG004', 'ICT2133', 45, 50),
                                                                                         ('UG005', 'ICT2133', 82, 85),
                                                                                         ('UG006', 'ICT2133', 70, 72),
                                                                                         ('UG007', 'ICT2133', 90, 92),
                                                                                         ('UG008', 'ICT2133', 55, 58),
                                                                                         ('UG009', 'ICT2133', 79, 81),
                                                                                         ('UG010', 'ICT2133', 65, 67),
                                                                                         ('UG011', 'ICT2133', 93, 95),
                                                                                         ('UG012', 'ICT2133', 88, 87),
                                                                                         ('UG013', 'ICT2133', 74, 72),
                                                                                         ('UG014', 'ICT2133', 60, 62),
                                                                                         ('UG015', 'ICT2133', 80, 82),
                                                                                         ('UG016', 'ICT2133', 67, 69),
                                                                                         ('UG017', 'ICT2133', 91, 89),
                                                                                         ('UG018', 'ICT2133', 58, 55),
                                                                                         ('UG019', 'ICT2133', 86, 88),
                                                                                         ('UG020', 'ICT2133', 95, 90);

-- ICT2142 (Practical only)
INSERT INTO finalmarks (undergraduate_id, course_code, Finalpracticaly) VALUES
                                                                            ('UG001', 'ICT2142', 83),
                                                                            ('UG002', 'ICT2142', 75),
                                                                            ('UG003', 'ICT2142', 60),
                                                                            ('UG004', 'ICT2142', 48),
                                                                            ('UG005', 'ICT2142', 88),
                                                                            ('UG006', 'ICT2142', 72),
                                                                            ('UG007', 'ICT2142', 93),
                                                                            ('UG008', 'ICT2142', 50),
                                                                            ('UG009', 'ICT2142', 80),
                                                                            ('UG010', 'ICT2142', 67),
                                                                            ('UG011', 'ICT2142', 95),
                                                                            ('UG012', 'ICT2142', 84),
                                                                            ('UG013', 'ICT2142', 70),
                                                                            ('UG014', 'ICT2142', 58),
                                                                            ('UG015', 'ICT2142', 76),
                                                                            ('UG016', 'ICT2142', 65),
                                                                            ('UG017', 'ICT2142', 90),
                                                                            ('UG018', 'ICT2142', 53),
                                                                            ('UG019', 'ICT2142', 85),
                                                                            ('UG020', 'ICT2142', 62);

-- ICT2152 (Theory only)
INSERT INTO finalmarks (undergraduate_id, course_code, Finaltheory) VALUES
                                                                        ('UG001', 'ICT2152', 70),
                                                                        ('UG002', 'ICT2152', 85),
                                                                        ('UG003', 'ICT2152', 40),
                                                                        ('UG004', 'ICT2152', 95),
                                                                        ('UG005', 'ICT2152', 60),
                                                                        ('UG006', 'ICT2152', 78),
                                                                        ('UG007', 'ICT2152', 90),
                                                                        ('UG008', 'ICT2152', 50),
                                                                        ('UG009', 'ICT2152', 65),
                                                                        ('UG010', 'ICT2152', 88),
                                                                        ('UG011', 'ICT2152', 72),
                                                                        ('UG012', 'ICT2152', 58),
                                                                        ('UG013', 'ICT2152', 95),
                                                                        ('UG014', 'ICT2152', 46),
                                                                        ('UG015', 'ICT2152', 76),
                                                                        ('UG016', 'ICT2152', 67),
                                                                        ('UG017', 'ICT2152', 39),
                                                                        ('UG018', 'ICT2152', 82),
                                                                        ('UG019', 'ICT2152', 75),
                                                                        ('UG020', 'ICT2152', 30);

-- ENG2122 (Theory only)
INSERT INTO finalmarks (undergraduate_id, course_code, Finaltheory) VALUES
                                                                        ('UG001', 'ENG2122', 70),
                                                                        ('UG002', 'ENG2122', 85),
                                                                        ('UG003', 'ENG2122', 40),
                                                                        ('UG004', 'ENG2122', 95),
                                                                        ('UG005', 'ENG2122', 60),
                                                                        ('UG006', 'ENG2122', 78),
                                                                        ('UG007', 'ENG2122', 90),
                                                                        ('UG008', 'ENG2122', 50),
                                                                        ('UG009', 'ENG2122', 65),
                                                                        ('UG010', 'ENG2122', 88),
                                                                        ('UG011', 'ENG2122', 72),
                                                                        ('UG012', 'ENG2122', 58),
                                                                        ('UG013', 'ENG2122', 95),
                                                                        ('UG014', 'ENG2122', 46),
                                                                        ('UG015', 'ENG2122', 76),
                                                                        ('UG016', 'ENG2122', 67),
                                                                        ('UG017', 'ENG2122', 50),
                                                                        ('UG018', 'ENG2122', 82),
                                                                        ('UG019', 'ENG2122', 75),
                                                                        ('UG020', 'ENG2122', 30);
