CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('2038-01-01','元日'),
('2038-01-11','成人の日'),
('2038-02-11','建国記念の日'),
('2038-04-29','昭和の日'),
('2038-05-03','憲法記念日'),
('2038-05-04','みどりの日'),
('2038-05-05','こどもの日'),
('2038-07-19','海の日'),
('2038-08-11','山の日'),
('2038-09-20','敬老の日'),
('2038-10-11','体育の日'),
('2038-11-03','文化の日'),
('2038-11-23','勤労感謝の日'),
('2038-12-23','天皇誕生日');
