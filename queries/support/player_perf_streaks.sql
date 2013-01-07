/*
First TNT streak program
*/

DELIMITER $$

DROP PROCEDURE IF EXISTS player_perf_streaks$$
CREATE PROCEDURE player_perf_streaks(in_players INT)
  READS SQL DATA
BEGIN
  DECLARE c_no_more_records CHAR(1) DEFAULT 'F';
  
  DECLARE d_thisdate DATE;
  DECLARE d_lastdate DATE DEFAULT '0001-01-01';
  DECLARE i_thisseq INT;
  DECLARE i_lastseq INT DEFAULT 0;
  DECLARE i_thisplayerid INT;
  DECLARE i_lastplayerid INT DEFAULT -99;
  DECLARE v_thisplayername VARCHAR(25);
  DECLARE v_lastplayername VARCHAR(25);
  
  DECLARE i_matchid INT;
  DECLARE i_numplayers INT;
  DECLARE i_wrank INT;
  DECLARE i_erank INT;
  DECLARE i_lines INT;
  DECLARE i_time INT;
  
  DECLARE d_begdate DATE;
  DECLARE i_begseq INT;
  DECLARE d_enddate DATE;
  DECLARE i_endseq INT;
  DECLARE i_streak INT DEFAULT 0;
  DECLARE i_plyrdayseq INT;
  DECLARE i_mintoprint INT DEFAULT 2;
  
  DECLARE cur1 CURSOR FOR
    SELECT p.playerid, 
    get_player_name(p.playerid, 'nick') as nm,
    m.matchid, m.matchdate, p.lines, p.time, p.wrank, p.erank
    FROM tntmatch m, playermatch p
    WHERE m.matchid = p.matchid
    -- AND p.playerid = 1
    -- AND extract(year from m.matchdate) = 2004
    AND get_numplayers_inmatch(m.matchid) = in_players
    ORDER BY p.playerid, m.matchdate, m.matchid;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET c_no_more_records='T';
  
  DROP TABLE IF EXISTS tempstreaks;
  CREATE TEMPORARY TABLE tempstreaks (
    playerid INT,
    playername VARCHAR(50),
    startdate DATE, 
    startseq INT,
    enddate DATE,
    endseq INT,
    streak INT);
  
  
  
  OPEN cur1;
  perf_loop:LOOP
    FETCH cur1 INTO i_thisplayerid, v_thisplayername, 
      i_matchid, d_thisdate, i_lines, i_time, i_wrank, i_erank;
    
    IF c_no_more_records = 'T' THEN
      IF i_streak >= i_mintoprint THEN
        INSERT INTO tempstreaks VALUES (
          i_lastplayerid,
          v_lastplayername,
          d_begdate, 
          i_begseq,
          d_enddate,
          i_endseq,
          i_streak);
      END IF;
      LEAVE perf_loop;      
    ELSEIF i_thisplayerid != i_lastplayerid AND i_lastplayerid != -99 THEN
      
      IF i_streak >= i_mintoprint THEN
        INSERT INTO tempstreaks VALUES (
          i_lastplayerid,
          v_lastplayername,
          d_begdate, 
          i_begseq,
          d_enddate,
          i_endseq,
          i_streak);
      END IF;
    ELSE -- same player
      IF d_thisdate = d_lastdate THEN
        SET i_thisseq = i_thisseq+1;
      ELSE
        SET i_thisseq = 1;
      END IF;
        
      IF i_wrank = 1 THEN -- extend streak
        IF i_streak = 0 THEN
          SET d_begdate = d_thisdate;
          SET i_begseq = i_thisseq;
        END IF;
        SET i_streak = i_streak+1;
        SET d_enddate = d_thisdate;
        SET i_endseq = i_thisseq;
        
      ELSEIF i_wrank > 1 THEN -- cut streak
        IF i_streak >= i_mintoprint THEN
          INSERT INTO tempstreaks VALUES (
            i_lastplayerid,
            v_lastplayername,
            d_begdate, 
            i_begseq,
            d_enddate,
            i_endseq,
            i_streak);
        END IF;
        
        SET i_streak = 0;
      END IF;
    END IF;
    
    SET i_lastplayerid = i_thisplayerid;
    SET v_lastplayername = v_thisplayername;
    SET d_lastdate = d_thisdate;
    SET i_lastseq = i_thisseq;
    
  END LOOP perf_loop;
  CLOSE cur1;
  
  SET c_no_more_records='F';
    
  -- results
  SELECT get_player_name(playerid,'nick') as nm,
    streak, 
    DATE_FORMAT(startdate, '%c/%e/%Y') as begdate, startseq,
    DATE_FORMAT(enddate, '%c/%e/%Y') as enddate, endseq
  FROM tempstreaks 
  ORDER BY streak DESC, enddate DESC;
END$$

DELIMITER ;   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
