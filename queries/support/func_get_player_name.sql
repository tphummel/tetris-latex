DELIMITER $$

DROP FUNCTION IF EXISTS get_player_name$$
CREATE FUNCTION get_player_name(in_playerid INT, in_type VARCHAR(10))
  RETURNS VARCHAR(50)
BEGIN
  DECLARE v_name VARCHAR(50);
  IF UPPER(in_type) = 'NICK' THEN
    SElECT username
    INTO v_name
    FROM player
    WHERE playerid = in_playerid;
  ELSE
    SElECT CONCAT(firstname, ' ', lastname)
    INTO v_name
    FROM player
    WHERE playerid = in_playerid;
  END IF;
  RETURN v_name;
END$$

DELIMITER ;
