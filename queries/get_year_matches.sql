/*
Very basic match summary listings. 
Definitely can be done with query but just getting comfy.

*/

DELIMITER $$

DROP PROCEDURE IF EXISTS select_year_match_listing$$
CREATE PROCEDURE select_year_match_listing(in_year INT)
	READS SQL DATA
BEGIN
	DECLARE c_no_more_records CHAR(1) DEFAULT 'F';
	
	DECLARE d_matchdate DATE;
	DECLARE i_matchid INT DEFAULT 0;
	DECLARE v_locationname VARCHAR(50);
	DECLARE i_numplayers INT;
	DECLARE i_totallines INT;
	DECLARE i_totaltime INT;
	DECLARE n_totalratio NUMERIC (8,3);
	
	DECLARE cur1 CURSOR FOR
		SELECT m.matchid, m.matchdate, l.locationname
		FROM tntmatch m, location l
		WHERE EXTRACT(year from m.matchdate) = in_year
		AND m.location = l.locationid
		ORDER BY m.matchdate, m.matchid;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET c_no_more_records='T';
	
	DROP TABLE IF EXISTS tempmatches;
	CREATE TEMPORARY TABLE tempmatches (
		matchid INT,
		matchdate DATE, 
		locationname VARCHAR(50),
		numplayers INT,
		totallines INT,
		totaltime INT,
		totalratio NUMERIC (8,2));
	
		
	
	OPEN cur1;
	match_loop:LOOP
		FETCH cur1 INTO i_matchid, d_matchdate, v_locationname;
		
		SELECT COUNT(p.playerid), SUM(p.lines), SUM(p.time), SUM(p.lines)/SUM(p.time)
		INTO i_numplayers, i_totallines, i_totaltime, n_totalratio
		FROM playermatch p
		WHERE matchid = i_matchid;
		
		INSERT INTO tempmatches VALUES (i_matchid, d_matchdate, v_locationname, i_numplayers, i_totallines, i_totaltime, n_totalratio);
		
		IF c_no_more_records = 'T' THEN
			LEAVE match_loop;
		END IF;
	END LOOP match_loop;
	CLOSE cur1;
	SET c_no_more_records='F';
	
	SELECT DATE_FORMAT(matchdate, '%a, %b %D, %Y') as mdate, locationname as location, 
	numplayers as plyrs, totallines as totlines, totaltime as tottime, totalratio as lps
	FROM tempmatches 
	ORDER BY matchdate, matchid;
END$$

DELIMITER ;
