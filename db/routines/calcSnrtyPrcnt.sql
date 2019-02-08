DELIMITER //

CREATE FUNCTION calcSnrtyPrcnt(yrs INT) RETURNS DECIMAL(3,1)
  NO SQL
  DETERMINISTIC
BEGIN
  /* See https://www.lex.bg/laws/ldoc/2135542406 (article 12),
   *     https://www.mlsp.government.bg/ckfinder/userfiles/files/dokumenti/postanovleniq/POSTANOVLENIE_147_na_MS_ot_29062007_g_za_opredelqne_na_minimalniq_razmer_na_dopylnitelnoto_trudovo_v.rtf
   */
  RETURN yrs * 0.6;
END //

DELIMITER ;
