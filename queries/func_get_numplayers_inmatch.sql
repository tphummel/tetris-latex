DELIMITER $$

DROP FUNCTION IF EXISTS get_numplayers_inmatch$$
CREATE FUNCTION get_numplayers_inmatch(in_matchid INT)
	RETURNS INT
BEGIN
	DECLARE i_players INT;
	
	SElECT COUNT(playerid)
	INTO i_players
	FROM playermatch
	WHERE matchid = in_matchid;
	
	RETURN i_players;
END$$

DELIMITER ;
