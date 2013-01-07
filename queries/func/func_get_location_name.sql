DELIMITER $$

DROP FUNCTION IF EXISTS get_location_name$$
CREATE FUNCTION get_location_name(in_locationid INT, in_type VARCHAR(10))
	RETURNS VARCHAR(50)
BEGIN
	DECLARE v_location VARCHAR(50);
	IF UPPER(in_type) = 'ADDY' THEN
		SElECT CONCAT(locationname, ' (', city, ', ', state,')')
		INTO v_location
		FROM location
		WHERE locationid = in_locationid;
	ELSE
		SElECT locationname
		INTO v_location
		FROM location
		WHERE locationid = in_locationid;
	END IF;
	RETURN v_location;
END$$

DELIMITER ;
