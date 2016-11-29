CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('2014-01-01','元日'),
('2014-01-13','成人の日'),
('2014-02-11','建国記念の日'),
('2014-03-21','春分の日'),
('2014-04-29','昭和の日'),
('2014-05-03','憲法記念日'),
('2014-05-04','みどりの日'),
('2014-05-05','こどもの日'),
('2014-05-06','振替休日'),
('2014-07-21','海の日'),
('2014-09-15','敬老の日'),
('2014-09-23','秋分の日'),
('2014-10-13','体育の日'),
('2014-11-03','文化の日'),
('2014-11-23','勤労感謝の日'),
('2014-11-24','振替休日'),
('2014-12-23','天皇誕生日');
