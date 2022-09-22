CREATE OR REPLACE FUNCTION pg_temp.dump_ad_sysconfig_template()
RETURNS TABLE(line text) AS $$
DECLARE
        rec RECORD;
        sysconfig_c CURSOR FOR
		SELECT Name, Value, description FROM AD_SysConfig
			WHERE IsActive='Y' AND AD_Client_ID=0 AND EntityType='D' 
			AND Name NOT Like 'DICTIONARY_ID_%'
			AND Name NOT LIKE 'PROJECT_ID_%'
			ORDER BY Name;
BEGIN
  FOR sysconfig IN sysconfig_c
  LOOP
	IF sysconfig.description IS NOT NULL THEN
		SELECT '# ' || sysconfig.description || ', default=' || sysconfig.value INTO line;
		RETURN NEXT;
	ELSE
	    SELECT '# default=' || sysconfig.value INTO line;
        RETURN NEXT;
	END IF;
	SELECT sysconfig.name || '=' || sysconfig.value INTO line;
	RETURN NEXT;
  END LOOP;
END; 
$$ LANGUAGE plpgsql;

SELECT * FROM pg_temp.dump_ad_sysconfig_template();
