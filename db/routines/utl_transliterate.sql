DELIMITER //

CREATE FUNCTION utl_transliterate(original VARCHAR(512)) RETURNS VARCHAR(512)
  COMMENT 'Transliterate between cyrillic and latin scripts'
  DETERMINISTIC
  NO SQL
BEGIN
  /* Based on https://github.com/igstan/sql-utils/blob/master/transliterate.sql */
  DECLARE is_lower  BIT;
  DECLARE part      CHAR(8);
  DECLARE pos       INTEGER       DEFAULT 1;
  DECLARE result    VARCHAR(512)  DEFAULT '';

  WHILE (pos <= CHAR_LENGTH(original)) DO
    SET part      = SUBSTRING(original, pos, 1);
    SET is_lower  = IF(LOWER(part) COLLATE utf8_bin = part COLLATE utf8_bin, 1, 0);

    /* See https://lex.bg/laws/ldoc/2135623667#i_5 */
    CASE
      WHEN part = 'а' THEN SET part = IF(is_lower, 'a'  , 'A');
      WHEN part = 'б' THEN SET part = IF(is_lower, 'b'  , 'B');
      WHEN part = 'в' THEN SET part = IF(is_lower, 'v'  , 'V');
      WHEN part = 'г' THEN SET part = IF(is_lower, 'g'  , 'G');
      WHEN part = 'д' THEN SET part = IF(is_lower, 'd'  , 'D');
      WHEN part = 'е' THEN SET part = IF(is_lower, 'e'  , 'E');
      WHEN part = 'ж' THEN SET part = IF(is_lower, 'zh' , 'Zh');
      WHEN part = 'з' THEN SET part = IF(is_lower, 'z'  , 'Z');
      WHEN part = 'и' THEN SET part = IF(is_lower, 'i'  , 'I');
      WHEN part = 'й' THEN SET part = IF(is_lower, 'y'  , 'Y');
      WHEN part = 'к' THEN SET part = IF(is_lower, 'k'  , 'K');
      WHEN part = 'л' THEN SET part = IF(is_lower, 'l'  , 'L');
      WHEN part = 'м' THEN SET part = IF(is_lower, 'm'  , 'M');
      WHEN part = 'н' THEN SET part = IF(is_lower, 'n'  , 'N');
      WHEN part = 'о' THEN SET part = IF(is_lower, 'o'  , 'O');
      WHEN part = 'п' THEN SET part = IF(is_lower, 'p'  , 'P');
      WHEN part = 'р' THEN SET part = IF(is_lower, 'r'  , 'R');
      WHEN part = 'с' THEN SET part = IF(is_lower, 's'  , 'S');
      WHEN part = 'т' THEN SET part = IF(is_lower, 't'  , 't');
      WHEN part = 'у' THEN SET part = IF(is_lower, 'u'  , 'U');
      WHEN part = 'ф' THEN SET part = IF(is_lower, 'f'  , 'F');
      WHEN part = 'х' THEN SET part = IF(is_lower, 'h'  , 'H');
      WHEN part = 'ц' THEN SET part = IF(is_lower, 'ts' , 'Ts');
      WHEN part = 'ч' THEN SET part = IF(is_lower, 'ch' , 'Ch');
      WHEN part = 'ш' THEN SET part = IF(is_lower, 'sh' , 'Sh');
      WHEN part = 'щ' THEN SET part = IF(is_lower, 'sht', 'Sht');
      WHEN part = 'ъ' THEN SET part = IF(is_lower, 'a'  , 'A');
      WHEN part = 'ь' THEN SET part = IF(is_lower, 'y'  , 'Y');
      WHEN part = 'ю' THEN SET part = IF(is_lower, 'yu' , 'Yu');
      WHEN part = 'я' THEN SET part = IF(is_lower, 'ya' , 'Ya');
      ELSE
        BEGIN
        END;
    END CASE;

    SET pos   = pos + 1;
    SET result= CONCAT_WS(IF(part = ' ', ' ', ''), result, part);
  END WHILE;

  RETURN result;
END //

DELIMITER ;
