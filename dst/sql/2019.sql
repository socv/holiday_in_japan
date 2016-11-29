CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('2019-01-01','元日'),
('2019-01-14','成人の日'),
('2019-02-11','建国記念の日'),
('2019-03-21','春分の日(未確定)'),
('2019-04-29','昭和の日'),
('2019-05-03','憲法記念日'),
('2019-05-04','みどりの日'),
('2019-05-05','こどもの日'),
('2019-05-06','振替休日'),
('2019-07-15','海の日'),
('2019-08-11','山の日'),
('2019-08-12','振替休日'),
('2019-09-16','敬老の日'),
('2019-09-23','秋分の日(未確定)'),
('2019-10-14','体育の日'),
('2019-11-03','文化の日'),
('2019-11-04','振替休日'),
('2019-11-23','勤労感謝の日'),
('2019-12-23','天皇誕生日');
