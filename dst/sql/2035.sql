CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '2035-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('2035-01-01','元日'),
('2035-01-08','成人の日'),
('2035-02-11','建国記念の日'),
('2035-02-12','振替休日'),
('2035-02-23','天皇誕生日'),
('2035-04-29','昭和の日'),
('2035-04-30','振替休日'),
('2035-05-03','憲法記念日'),
('2035-05-04','みどりの日'),
('2035-05-05','こどもの日'),
('2035-07-16','海の日'),
('2035-08-11','山の日'),
('2035-09-17','敬老の日'),
('2035-09-24','振替休日'),
('2035-10-08','スポーツの日'),
('2035-11-03','文化の日'),
('2035-11-23','勤労感謝の日'),
('2035-12-24','振替休日');
COMMIT;
