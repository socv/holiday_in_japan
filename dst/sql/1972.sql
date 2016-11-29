CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1972-01-01','元日'),
('1972-01-15','成人の日'),
('1972-02-11','建国記念の日'),
('1972-04-29','天皇誕生日'),
('1972-05-03','憲法記念日'),
('1972-05-05','こどもの日'),
('1972-09-15','敬老の日'),
('1972-10-10','体育の日'),
('1972-11-03','文化の日'),
('1972-11-23','勤労感謝の日');
