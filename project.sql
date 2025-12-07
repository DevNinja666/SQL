CREATE TABLE Faculties (
    faculty_id      INT PRIMARY KEY AUTO_INCREMENT,
    faculty_name    VARCHAR(120) NOT NULL,
    dean            VARCHAR(120)
);

CREATE TABLE Groups (
    group_id        INT PRIMARY KEY AUTO_INCREMENT,
    group_name      VARCHAR(50) NOT NULL,
    faculty_id      INT,
    curator         VARCHAR(120),

    FOREIGN KEY (faculty_id) REFERENCES Faculties(faculty_id)
);

CREATE TABLE Students (
    student_id          INT PRIMARY KEY AUTO_INCREMENT,
    full_name           VARCHAR(150) NOT NULL,
    birth_year          INT,
    phone               VARCHAR(30),
    email               VARCHAR(120),
    group_id            INT,
    scholarship_status  VARCHAR(40),

    FOREIGN KEY (group_id) REFERENCES Groups(group_id)
);

CREATE TABLE Teachers (
    teacher_id      INT PRIMARY KEY AUTO_INCREMENT,
    full_name       VARCHAR(150) NOT NULL,
    faculty_id      INT,
    position        VARCHAR(60),

    FOREIGN KEY (faculty_id) REFERENCES Faculties(faculty_id)
);

CREATE TABLE Courses (
    course_id       INT PRIMARY KEY AUTO_INCREMENT,
    course_name     VARCHAR(150) NOT NULL,
    credits         INT NOT NULL
);

CREATE TABLE CourseTeachers (
    id              INT PRIMARY KEY AUTO_INCREMENT,
    course_id       INT,
    teacher_id      INT,
    semester        VARCHAR(20),

    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);

CREATE TABLE StudentCourses (
    id              INT PRIMARY KEY AUTO_INCREMENT,
    student_id      INT,
    course_id       INT,
    semester        VARCHAR(20),
    UNIQUE (student_id, course_id, semester),

    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Grades (
    id              INT PRIMARY KEY AUTO_INCREMENT,
    student_id      INT,
    course_id       INT,
    semester        VARCHAR(20),
    grade           INT CHECK (grade BETWEEN 0 AND 100),
    grade_type      VARCHAR(30),

    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Attendance (
    id              INT PRIMARY KEY AUTO_INCREMENT,
    student_id      INT,
    course_id       INT,
    lesson_date     DATE,
    status          VARCHAR(20),

    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Rooms (
    room_id         INT PRIMARY KEY AUTO_INCREMENT,
    room_number     VARCHAR(20),
    capacity        INT,
    building        VARCHAR(50)
);

CREATE TABLE Schedule (
    schedule_id     INT PRIMARY KEY AUTO_INCREMENT,
    course_id       INT,
    group_id        INT,
    teacher_id      INT,
    room_id         INT,
    lesson_time     DATETIME,

    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (group_id) REFERENCES Groups(group_id),
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

CREATE TABLE Penalties (
    id              INT PRIMARY KEY AUTO_INCREMENT,
    student_id      INT,
    reason          VARCHAR(200),
    amount          DECIMAL(10,2),
    date_issued     DATE,

    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

CREATE TABLE AdminStaff (
    staff_id        INT PRIMARY KEY AUTO_INCREMENT,
    full_name       VARCHAR(150),
    role            VARCHAR(60),
    faculty_id      INT,

    FOREIGN KEY (faculty_id) REFERENCES Faculties(faculty_id)
);
