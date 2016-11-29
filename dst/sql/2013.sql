CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('2013-01-01','元日'),
('2013-01-14','成人の日'),
('2013-02-11','建国記念の日'),
('2013-03-20','春分の日'),
('2013-04-29','昭和の日'),
('2013-05-03','憲法記念日'),
('2013-05-04','みどりの日'),
('2013-05-05','こどもの日'),
('2013-05-06','振替休日'),
('2013-07-15','海の日'),
('2013-09-16','敬老の日'),
('2013-09-23','秋分の日'),
('2013-10-14','体育の日'),
('2013-11-03','文化の日'),
('2013-11-04','振替休日'),
('2013-11-23','勤労感謝の日'),
('2013-12-23','天皇誕生日');
