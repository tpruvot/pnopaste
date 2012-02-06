SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

-- -----------------------------------------------------
-- Table `settings`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `settings` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `system_url` VARCHAR(200) NOT NULL DEFAULT '__default__' ,
  `system_cleanup` INT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `default_expires` INT(15) UNSIGNED NULL ,
  `default_language` VARCHAR(2) NOT NULL DEFAULT 'en' ,
  `web_style` VARCHAR(20) NOT NULL DEFAULT 'default' ,
  `web_title` VARCHAR(200) NOT NULL DEFAULT 'Perl NoPaste Service' ,
  `web_hashed_ids` INT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `system_url_UNIQUE` ON `settings` (`system_url` ASC) ;


-- -----------------------------------------------------
-- Table `blacklist_ip`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blacklist_ip` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `ip` VARCHAR(50) NOT NULL ,
  `hits` INT UNSIGNED NOT NULL DEFAULT '0' ,
  `settings_id` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_blacklist_ip_settings1`
    FOREIGN KEY (`settings_id` )
    REFERENCES `settings` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `ip` ON `blacklist_ip` (`ip` ASC) ;

CREATE INDEX `fk_blacklist_ip_settings1` ON `blacklist_ip` (`settings_id` ASC) ;


-- -----------------------------------------------------
-- Table `blacklist_word`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blacklist_word` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `word` VARCHAR(150) NOT NULL ,
  `hits` INT UNSIGNED NOT NULL DEFAULT '0' ,
  `settings_id` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_blacklist_word_settings1`
    FOREIGN KEY (`settings_id` )
    REFERENCES `settings` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `word` ON `blacklist_word` (`word` ASC) ;

CREATE INDEX `fk_blacklist_word_settings1` ON `blacklist_word` (`settings_id` ASC) ;


-- -----------------------------------------------------
-- Table `nopaste`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `nopaste` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `code` longtext NOT NULL,
  `md5` varchar(32) NOT NULL DEFAULT '',
  `cached` longtext,
  `language` varchar(100) NOT NULL,
  `time` int(15) NOT NULL DEFAULT '0',
  `ip` varchar(20) CHARACTER SET latin1 NOT NULL,
  `expires` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `time` (`time`),
  KEY `expires` (`expires`)
)
ENGINE = InnoDB
DEFAULT CHARSET=utf8;

CREATE INDEX `date_expires` ON `nopaste` (`date_expires` ASC) ;


-- -----------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `username` VARCHAR(25) NOT NULL ,
  `password` VARCHAR(64) NOT NULL ,
  `session` VARCHAR(45) NULL ,
  `email` VARCHAR(100) NOT NULL ,
  `forname` VARCHAR(45) NULL ,
  `surname` VARCHAR(45) NULL ,
  `o_email_notification` INT(1) UNSIGNED NOT NULL ,
  `superadmin` INT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `username` ON `users` (`username` ASC) ;

CREATE INDEX `session` ON `users` (`session` ASC) ;

CREATE INDEX `o_email_notification` ON `users` (`o_email_notification` ASC) ;


-- -----------------------------------------------------
-- Table `blacklist_country`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blacklist_country` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `country` VARCHAR(2) NOT NULL ,
  `hits` INT UNSIGNED NOT NULL DEFAULT 0 ,
  `settings_id` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_blacklist_country_settings1`
    FOREIGN KEY (`settings_id` )
    REFERENCES `settings` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `country` ON `blacklist_country` (`country` ASC) ;

CREATE INDEX `fk_blacklist_country_settings1` ON `blacklist_country` (`settings_id` ASC) ;


-- -----------------------------------------------------
-- Table `users_has_settings`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `users_has_settings` (
  `users_id` INT UNSIGNED NOT NULL ,
  `settings_id` INT UNSIGNED NOT NULL ,
  `moderator` INT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `admin` INT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`users_id`, `settings_id`) ,
  CONSTRAINT `fk_users_has_settings_users1`
    FOREIGN KEY (`users_id` )
    REFERENCES `users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_settings_settings1`
    FOREIGN KEY (`settings_id` )
    REFERENCES `settings` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_users_has_settings_settings1` ON `users_has_settings` (`settings_id` ASC) ;

CREATE INDEX `fk_users_has_settings_users1` ON `users_has_settings` (`users_id` ASC) ;


-- -----------------------------------------------------
-- Table `version`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `version` (
  `db_version` INT NOT NULL DEFAULT 1 )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
