DELIMITER $$

DROP FUNCTION IF EXISTS get_player_name$$
CREATE FUNCTION get_player_name(in_playerid INT, in_type VARCHAR(10), in_guest BOOLEAN)
  RETURNS VARCHAR(50)
BEGIN
  DECLARE v_name VARCHAR(50);
  
  IF in_guest = '' THEN SET in_guest = true; END IF;
  
  IF UPPER(in_type) = 'FULL' THEN
    SELECT IF(in_guest, IF(username IN ('Tom','JD','Jeran','Dan','Spirk'), CONCAT(firstname, ' ', lastname), 'Guest'), CONCAT(firstname, ' ', lastname))
    INTO v_name
    FROM player
    WHERE playerid = in_playerid;
  ELSE
    SELECT IF(in_guest, IF(username IN ('Tom','JD','Jeran','Dan','Spirk'), username, 'Guest'), username)
    INTO v_name
    FROM player
    WHERE playerid = in_playerid;
  END IF;
  RETURN v_name;
END$$

DELIMITER ;
