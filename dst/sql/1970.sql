CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1970-01-01','元日'),
('1970-01-15','成人の日'),
('1970-02-11','建国記念の日'),
('1970-04-29','天皇誕生日'),
('1970-05-03','憲法記念日'),
('1970-05-05','こどもの日'),
('1970-09-15','敬老の日'),
('1970-10-10','体育の日'),
('1970-11-03','文化の日'),
('1970-11-23','勤労感謝の日');
