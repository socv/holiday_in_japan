CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1975-01-01','元日'),
('1975-01-15','成人の日'),
('1975-02-11','建国記念の日'),
('1975-04-29','天皇誕生日'),
('1975-05-03','憲法記念日'),
('1975-05-05','こどもの日'),
('1975-09-15','敬老の日'),
('1975-10-10','体育の日'),
('1975-11-03','文化の日'),
('1975-11-23','勤労感謝の日'),
('1975-11-24','振替休日');
