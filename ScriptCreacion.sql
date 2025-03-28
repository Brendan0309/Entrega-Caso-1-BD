-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema PaymentAsistant
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `PaymentAsistant` ;

-- -----------------------------------------------------
-- Schema PaymentAsistant
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `PaymentAsistant` DEFAULT CHARACTER SET utf8 ;
USE `PaymentAsistant` ;

-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Currencies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Currencies` (
  `currencyid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `acronym` VARCHAR(3) NOT NULL,
  `symbol` CHAR(1) NOT NULL,
  PRIMARY KEY (`currencyid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Countries` (
  `countryid` TINYINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  `currencyid` INT NOT NULL,
  PRIMARY KEY (`countryid`),
  INDEX `fk_Payment_Countries_Payment_Currencies1_idx` (`currencyid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Countries_Payment_Currencies1`
    FOREIGN KEY (`currencyid`)
    REFERENCES `PaymentAsistant`.`Payment_Currencies` (`currencyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_States`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_States` (
  `stateid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NOT NULL,
  `countryid` TINYINT NOT NULL,
  PRIMARY KEY (`stateid`),
  INDEX `fk_Payment_States_Payment_Countries_idx` (`countryid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_States_Payment_Countries`
    FOREIGN KEY (`countryid`)
    REFERENCES `PaymentAsistant`.`Payment_Countries` (`countryid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Cities` (
  `cityid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  `stateid` INT NOT NULL,
  PRIMARY KEY (`cityid`),
  INDEX `fk_Payment_Cities_Payment_States1_idx` (`stateid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Cities_Payment_States1`
    FOREIGN KEY (`stateid`)
    REFERENCES `PaymentAsistant`.`Payment_States` (`stateid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Adresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Adresses` (
  `adressid` INT NOT NULL AUTO_INCREMENT,
  `line1` VARCHAR(200) NOT NULL,
  `line2` VARCHAR(200) NULL,
  `zipcode` VARCHAR(9) NOT NULL,
  `geoposition` POINT NOT NULL,
  `cityid` INT NOT NULL,
  PRIMARY KEY (`adressid`),
  INDEX `fk_Payment_Adresses_Payment_Cities1_idx` (`cityid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Adresses_Payment_Cities1`
    FOREIGN KEY (`cityid`)
    REFERENCES `PaymentAsistant`.`Payment_Cities` (`cityid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Companies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Companies` (
  `companyid` INT NOT NULL AUTO_INCREMENT,
  `companyName` VARCHAR(100) NOT NULL,
  `creationDate` DATE NOT NULL,
  `adressid` INT NOT NULL,
  PRIMARY KEY (`companyid`),
  INDEX `fk_Payment_Companies_Payment_Adresses1_idx` (`adressid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Companies_Payment_Adresses1`
    FOREIGN KEY (`adressid`)
    REFERENCES `PaymentAsistant`.`Payment_Adresses` (`adressid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_CompanyRole`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_CompanyRole` (
  `roleId` INT NOT NULL AUTO_INCREMENT,
  `roleName` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`roleId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_UserCompanies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_UserCompanies` (
  `userCompanyId` INT NOT NULL AUTO_INCREMENT,
  `startDate` DATE NOT NULL,
  `companyid` INT NOT NULL,
  `roleId` INT NOT NULL,
  PRIMARY KEY (`userCompanyId`),
  INDEX `fk_Payment_UserCompanies_Payment_Companies1_idx` (`companyid` ASC) VISIBLE,
  INDEX `fk_Payment_UserCompanies_Payment_CompanyRole1_idx` (`roleId` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_UserCompanies_Payment_Companies1`
    FOREIGN KEY (`companyid`)
    REFERENCES `PaymentAsistant`.`Payment_Companies` (`companyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_UserCompanies_Payment_CompanyRole1`
    FOREIGN KEY (`roleId`)
    REFERENCES `PaymentAsistant`.`Payment_CompanyRole` (`roleId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Personas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Personas` (
  `personID` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(45) NOT NULL,
  `lastName` VARCHAR(60) NOT NULL,
  `birthdate` DATE NOT NULL,
  `consumersId` INT NOT NULL,
  PRIMARY KEY (`personID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Users` (
  `userid` INT NOT NULL AUTO_INCREMENT,
  `password` VARBINARY(250) NOT NULL,
  `enabled` BIT NOT NULL DEFAULT 1,
  `userCompanyId` INT NULL,
  `personID` INT NOT NULL,
  PRIMARY KEY (`userid`),
  INDEX `fk_Payment_Users_Payment_UserCompanies1_idx` (`userCompanyId` ASC) VISIBLE,
  INDEX `fk_Payment_Users_Payment_Personas1_idx` (`personID` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Users_Payment_UserCompanies1`
    FOREIGN KEY (`userCompanyId`)
    REFERENCES `PaymentAsistant`.`Payment_UserCompanies` (`userCompanyId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_Users_Payment_Personas1`
    FOREIGN KEY (`personID`)
    REFERENCES `PaymentAsistant`.`Payment_Personas` (`personID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_UserAdresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_UserAdresses` (
  `enabled` BIT NOT NULL,
  `userid` INT NOT NULL,
  `adressid` INT NOT NULL,
  INDEX `fk_Payment_UserAdresses_Payment_Users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_Payment_UserAdresses_Payment_Adresses1_idx` (`adressid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_UserAdresses_Payment_Users1`
    FOREIGN KEY (`userid`)
    REFERENCES `PaymentAsistant`.`Payment_Users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_UserAdresses_Payment_Adresses1`
    FOREIGN KEY (`adressid`)
    REFERENCES `PaymentAsistant`.`Payment_Adresses` (`adressid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Roles` (
  `roleid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`roleid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_UserRoles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_UserRoles` (
  `lastUpdate` DATETIME NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  `enabled` BIT(1) NOT NULL,
  `deleted` BIT(1) NOT NULL,
  `userid` INT NOT NULL,
  `roleid` INT NOT NULL,
  PRIMARY KEY (`userid`, `roleid`),
  INDEX `fk_Payment_UserRoles_Payment_Roles1_idx` (`roleid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_UserRoles_Payment_Users1`
    FOREIGN KEY (`userid`)
    REFERENCES `PaymentAsistant`.`Payment_Users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_UserRoles_Payment_Roles1`
    FOREIGN KEY (`roleid`)
    REFERENCES `PaymentAsistant`.`Payment_Roles` (`roleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Languages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Languages` (
  `languageid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `culture` VARCHAR(5) NOT NULL,
  `countryid` TINYINT NOT NULL,
  PRIMARY KEY (`languageid`),
  INDEX `fk_Payment_Languages_Payment_Countries1_idx` (`countryid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Languages_Payment_Countries1`
    FOREIGN KEY (`countryid`)
    REFERENCES `PaymentAsistant`.`Payment_Countries` (`countryid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Modules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Modules` (
  `moduleid` TINYINT(8) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NOT NULL,
  `languageid` INT NOT NULL,
  PRIMARY KEY (`moduleid`),
  INDEX `fk_Payment_Modules_Payment_Languages1_idx` (`languageid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Modules_Payment_Languages1`
    FOREIGN KEY (`languageid`)
    REFERENCES `PaymentAsistant`.`Payment_Languages` (`languageid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Permissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Permissions` (
  `permissionid` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(60) NOT NULL,
  `code` VARCHAR(10) NOT NULL,
  `moduleid` TINYINT(8) NOT NULL,
  PRIMARY KEY (`permissionid`),
  INDEX `fk_Payment_Permissions_Payment_Modules1_idx` (`moduleid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Permissions_Payment_Modules1`
    FOREIGN KEY (`moduleid`)
    REFERENCES `PaymentAsistant`.`Payment_Modules` (`moduleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_UserPermissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_UserPermissions` (
  `rolePermissionid` INT NOT NULL AUTO_INCREMENT,
  `enabled` BIT(1) NOT NULL,
  `deleted` BIT(1) NOT NULL,
  `lastUpdate` DATETIME NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  `permissionid` INT NOT NULL,
  `userid` INT NOT NULL,
  PRIMARY KEY (`rolePermissionid`),
  INDEX `fk_Payment_UserPermissions_Payment_Permissions1_idx` (`permissionid` ASC) VISIBLE,
  INDEX `fk_Payment_UserPermissions_Payment_Users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_UserPermissions_Payment_Permissions1`
    FOREIGN KEY (`permissionid`)
    REFERENCES `PaymentAsistant`.`Payment_Permissions` (`permissionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_UserPermissions_Payment_Users1`
    FOREIGN KEY (`userid`)
    REFERENCES `PaymentAsistant`.`Payment_Users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_RolePermissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_RolePermissions` (
  `rolePermissionid` INT NOT NULL AUTO_INCREMENT,
  `enabled` BIT(1) NOT NULL,
  `deleted` BIT(1) NOT NULL,
  `lastUpdate` DATETIME NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `checksum` VARBINARY(250) NOT NULL,
  `roleid` INT NOT NULL,
  `permissionid` INT NOT NULL,
  PRIMARY KEY (`rolePermissionid`),
  INDEX `fk_Payment_RolePermissions_Payment_Roles1_idx` (`roleid` ASC) VISIBLE,
  INDEX `fk_Payment_RolePermissions_Payment_Permissions1_idx` (`permissionid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_RolePermissions_Payment_Roles1`
    FOREIGN KEY (`roleid`)
    REFERENCES `PaymentAsistant`.`Payment_Roles` (`roleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_RolePermissions_Payment_Permissions1`
    FOREIGN KEY (`permissionid`)
    REFERENCES `PaymentAsistant`.`Payment_Permissions` (`permissionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_MediaTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_MediaTypes` (
  `mediaTypeid` TINYINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  `playerImp` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`mediaTypeid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_MediaFiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_MediaFiles` (
  `mediaFileId` INT NOT NULL AUTO_INCREMENT,
  `url` VARCHAR(200) NOT NULL,
  `deleted` BIT NOT NULL,
  `mediaTypeid` TINYINT NOT NULL,
  `reference` VARCHAR(255) NOT NULL,
  `generationDate` DATETIME NOT NULL,
  PRIMARY KEY (`mediaFileId`),
  INDEX `fk_Payment_MediaFiles_Payment_MediaTypes1_idx` (`mediaTypeid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_MediaFiles_Payment_MediaTypes1`
    FOREIGN KEY (`mediaTypeid`)
    REFERENCES `PaymentAsistant`.`Payment_MediaTypes` (`mediaTypeid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Schedules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Schedules` (
  `scheduleid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `recurrencyType` TINYINT NOT NULL,
  `repeat` BIT(1) NOT NULL,
  `endType` TINYINT NOT NULL,
  `repetitions` TINYINT NULL,
  `endDate` DATE NULL,
  PRIMARY KEY (`scheduleid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`payment_MetodosDePago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`payment_MetodosDePago` (
  `metodoId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(17) NOT NULL,
  `apiURL` VARCHAR(60) NOT NULL,
  `secretKey` VARBINARY(128) NOT NULL,
  `key` VARBINARY(128) NOT NULL,
  `logoIconURL` VARCHAR(45) NOT NULL,
  `enabled` BIT NOT NULL,
  `templateJSON` JSON NOT NULL,
  PRIMARY KEY (`metodoId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_MediosDisponibles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_MediosDisponibles` (
  `pagoMedioId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `token` VARBINARY(128) NOT NULL,
  `expTokenDate` DATE NOT NULL,
  `maskAccount` VARCHAR(45) NOT NULL,
  `callbackURLget` VARCHAR(45) NOT NULL,
  `callbackPost` VARCHAR(45) NOT NULL,
  `callbackredirect` VARCHAR(45) NOT NULL,
  `personID` INT NOT NULL,
  `metodoId` INT NOT NULL,
  `configurationJSON` JSON NOT NULL,
  PRIMARY KEY (`pagoMedioId`),
  INDEX `fk_payment_mediosDisponibles_payment_personas1_idx` (`personID` ASC) VISIBLE,
  INDEX `fk_payment_mediosDisponibles_payment_MetodosDePago1_idx` (`metodoId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_mediosDisponibles_payment_personas1`
    FOREIGN KEY (`personID`)
    REFERENCES `PaymentAsistant`.`Payment_Personas` (`personID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_mediosDisponibles_payment_MetodosDePago1`
    FOREIGN KEY (`metodoId`)
    REFERENCES `PaymentAsistant`.`payment_MetodosDePago` (`metodoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_RegisteredPayments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_RegisteredPayments` (
  `registerPaymentid` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(255) NOT NULL,
  `amount` DECIMAL(15,2) NOT NULL,
  `expirationDate` DATE NOT NULL,
  `enabled` BIT(1) NOT NULL,
  `userid` INT NOT NULL,
  `currencyid` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `scheduleid` INT NOT NULL,
  `output_pagoMedioId` INT NOT NULL,
  `input_pagoMedioId` INT NOT NULL,
  `isDynamicPrice` BIT(1) NOT NULL,
  PRIMARY KEY (`registerPaymentid`),
  INDEX `fk_Payment_Pendings_Payment_Users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_Payment_Pendings_Payment_Currencies1_idx` (`currencyid` ASC) VISIBLE,
  INDEX `fk_Payment_RegisteredPayments_Payment_Schedules1_idx` (`scheduleid` ASC) VISIBLE,
  INDEX `fk_Payment_RegisteredPayments_payment_mediosDisponibles2_idx` (`output_pagoMedioId` ASC) VISIBLE,
  INDEX `fk_Payment_RegisteredPayments_payment_mediosDisponibles1_idx` (`input_pagoMedioId` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Pendings_Payment_Users1`
    FOREIGN KEY (`userid`)
    REFERENCES `PaymentAsistant`.`Payment_Users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_Pendings_Payment_Currencies1`
    FOREIGN KEY (`currencyid`)
    REFERENCES `PaymentAsistant`.`Payment_Currencies` (`currencyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_RegisteredPayments_Payment_Schedules1`
    FOREIGN KEY (`scheduleid`)
    REFERENCES `PaymentAsistant`.`Payment_Schedules` (`scheduleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_RegisteredPayments_payment_mediosDisponibles2`
    FOREIGN KEY (`output_pagoMedioId`)
    REFERENCES `PaymentAsistant`.`Payment_MediosDisponibles` (`pagoMedioId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_RegisteredPayments_payment_mediosDisponibles1`
    FOREIGN KEY (`input_pagoMedioId`)
    REFERENCES `PaymentAsistant`.`Payment_MediosDisponibles` (`pagoMedioId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_NotificationStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_NotificationStatus` (
  `notificationStatusid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`notificationStatusid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_NotificationMedia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_NotificationMedia` (
  `notificationMediaid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`notificationMediaid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Notifications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Notifications` (
  `notificationid` INT NOT NULL AUTO_INCREMENT,
  `sentDate` DATETIME NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `description` VARCHAR(200) NULL,
  `notificationStatusid` INT NOT NULL,
  `notificationMediaid` INT NOT NULL,
  `senderUserid` INT NOT NULL,
  `receiverUserid` INT NOT NULL,
  `registerPaymentid` INT NOT NULL,
  PRIMARY KEY (`notificationid`),
  INDEX `fk_Notifications_NotificationStatus1_idx` (`notificationStatusid` ASC) VISIBLE,
  INDEX `fk_Notifications_NotificationMedia1_idx` (`notificationMediaid` ASC) VISIBLE,
  INDEX `fk_Payment_Notifications_Payment_Users2_idx` (`senderUserid` ASC) VISIBLE,
  INDEX `fk_Payment_Notifications_Payment_Users3_idx` (`receiverUserid` ASC) VISIBLE,
  INDEX `fk_Payment_Notifications_Payment_RegisteredPayments1_idx` (`registerPaymentid` ASC) VISIBLE,
  CONSTRAINT `fk_Notifications_NotificationStatus1`
    FOREIGN KEY (`notificationStatusid`)
    REFERENCES `PaymentAsistant`.`Payment_NotificationStatus` (`notificationStatusid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Notifications_NotificationMedia1`
    FOREIGN KEY (`notificationMediaid`)
    REFERENCES `PaymentAsistant`.`Payment_NotificationMedia` (`notificationMediaid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_Notifications_Payment_Users2`
    FOREIGN KEY (`senderUserid`)
    REFERENCES `PaymentAsistant`.`Payment_Users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_Notifications_Payment_Users3`
    FOREIGN KEY (`receiverUserid`)
    REFERENCES `PaymentAsistant`.`Payment_Users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_Notifications_Payment_RegisteredPayments1`
    FOREIGN KEY (`registerPaymentid`)
    REFERENCES `PaymentAsistant`.`Payment_RegisteredPayments` (`registerPaymentid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_APIs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_APIs` (
  `apiid` INT NOT NULL AUTO_INCREMENT,
  `SID` VARCHAR(45) NOT NULL,
  `AUTH_TOKEN` VARBINARY(128) NOT NULL,
  `notificationid` INT NOT NULL,
  `acess_token` VARBINARY(150) NULL,
  `token_type` VARBINARY(128) NULL,
  `app_id` VARCHAR(50) NULL,
  `expirationTime` DATETIME NULL,
  `nonce` VARCHAR(100) NULL,
  `statusCode` VARCHAR(3) NULL,
  PRIMARY KEY (`apiid`),
  INDEX `fk_Payment_APIs_Payment_Notifications2_idx` (`notificationid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_APIs_Payment_Notifications2`
    FOREIGN KEY (`notificationid`)
    REFERENCES `PaymentAsistant`.`Payment_Notifications` (`notificationid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_ContactInfoTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_ContactInfoTypes` (
  `contacInfoTypeId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`contacInfoTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_ContactInfoPerson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_ContactInfoPerson` (
  `value` VARCHAR(100) NOT NULL,
  `enabled` BIT NOT NULL,
  `lastUpdate` DATETIME NOT NULL,
  `contacInfoTypeId` INT NOT NULL,
  `personID` INT NOT NULL,
  `metodoId` INT NOT NULL,
  INDEX `fk_payment_contactInfoPerson_payment_contactInfoTypes1_idx` (`contacInfoTypeId` ASC) VISIBLE,
  INDEX `fk_payment_contactInfoPerson_payment_personas1_idx` (`personID` ASC) VISIBLE,
  INDEX `fk_payment_contactInfoPerson_payment_MetodosDePago1_idx` (`metodoId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_contactInfoPerson_payment_contactInfoTypes1`
    FOREIGN KEY (`contacInfoTypeId`)
    REFERENCES `PaymentAsistant`.`Payment_ContactInfoTypes` (`contacInfoTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_contactInfoPerson_payment_personas1`
    FOREIGN KEY (`personID`)
    REFERENCES `PaymentAsistant`.`Payment_Personas` (`personID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_contactInfoPerson_payment_MetodosDePago1`
    FOREIGN KEY (`metodoId`)
    REFERENCES `PaymentAsistant`.`payment_MetodosDePago` (`metodoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Pagos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Pagos` (
  `pagoId` BIGINT NOT NULL AUTO_INCREMENT,
  `pagoMedioId` INT NOT NULL,
  `metodoId` INT NOT NULL,
  `personID` INT NOT NULL,
  `monto` FLOAT NOT NULL,
  `actualMonto` FLOAT NULL,
  `result` VARBINARY(300) NULL,
  `auth` VARBINARY(300) NULL,
  `chargetoken` VARBINARY(128) NULL,
  `descripcion` VARCHAR(100) NULL,
  `error` VARCHAR(60) NULL,
  `fecha` DATETIME NULL,
  `checksum` VARBINARY(128) NOT NULL,
  `exchangeRate` FLOAT NOT NULL,
  `convertedAmount` FLOAT NOT NULL,
  `currencyid` INT NOT NULL,
  PRIMARY KEY (`pagoId`),
  INDEX `fk_payment_pagos_payment_mediosDisponibles1_idx` (`pagoMedioId` ASC) VISIBLE,
  INDEX `fk_payment_pagos_payment_MetodosDePago1_idx` (`metodoId` ASC) VISIBLE,
  INDEX `fk_payment_pagos_payment_personas1_idx` (`personID` ASC) VISIBLE,
  INDEX `fk_payment_pagos_Payment_Currencies1_idx` (`currencyid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_pagos_payment_mediosDisponibles1`
    FOREIGN KEY (`pagoMedioId`)
    REFERENCES `PaymentAsistant`.`Payment_MediosDisponibles` (`pagoMedioId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_pagos_payment_MetodosDePago1`
    FOREIGN KEY (`metodoId`)
    REFERENCES `PaymentAsistant`.`payment_MetodosDePago` (`metodoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_pagos_payment_personas1`
    FOREIGN KEY (`personID`)
    REFERENCES `PaymentAsistant`.`Payment_Personas` (`personID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_pagos_Payment_Currencies1`
    FOREIGN KEY (`currencyid`)
    REFERENCES `PaymentAsistant`.`Payment_Currencies` (`currencyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_TransTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_TransTypes` (
  `transtypeId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`transtypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Funds`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Funds` (
  `fundId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`fundId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_PersonBalance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_PersonBalance` (
  `personBalanceId` BIGINT NOT NULL AUTO_INCREMENT,
  `personID` INT NOT NULL,
  `balance` FLOAT NOT NULL,
  `lastBalance` FLOAT NOT NULL,
  `lastUpdate` DATETIME NOT NULL,
  `checksum` VARBINARY(128) NOT NULL,
  `freezeAmount` FLOAT NOT NULL,
  `fundId` INT NOT NULL,
  PRIMARY KEY (`personBalanceId`),
  INDEX `fk_payment_personBalance_payment_personas1_idx` (`personID` ASC) VISIBLE,
  INDEX `fk_payment_personBalance_payment_Funds1_idx` (`fundId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_personBalance_payment_personas1`
    FOREIGN KEY (`personID`)
    REFERENCES `PaymentAsistant`.`Payment_Personas` (`personID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_personBalance_payment_Funds1`
    FOREIGN KEY (`fundId`)
    REFERENCES `PaymentAsistant`.`Payment_Funds` (`fundId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Transacciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Transacciones` (
  `transaccionId` BIGINT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(45) NOT NULL,
  `tranDateTime` DATETIME NOT NULL,
  `postTime` DATETIME NOT NULL,
  `pagoId` BIGINT NULL,
  `refNumber` VARCHAR(45) NULL,
  `userid` INT NULL,
  `personID` INT NULL,
  `transtypeId` INT NOT NULL,
  `personBalanceId` BIGINT NOT NULL,
  `fundId` INT NOT NULL,
  PRIMARY KEY (`transaccionId`),
  INDEX `fk_payment_Transacciones_payment_pagos1_idx` (`pagoId` ASC) VISIBLE,
  INDEX `fk_payment_Transacciones_Payment_Users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_payment_Transacciones_payment_personas1_idx` (`personID` ASC) VISIBLE,
  INDEX `fk_payment_Transacciones_payment_transTypes1_idx` (`transtypeId` ASC) VISIBLE,
  INDEX `fk_payment_Transacciones_payment_personBalance1_idx` (`personBalanceId` ASC) VISIBLE,
  INDEX `fk_payment_Transacciones_payment_Funds1_idx` (`fundId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_Transacciones_payment_pagos1`
    FOREIGN KEY (`pagoId`)
    REFERENCES `PaymentAsistant`.`Payment_Pagos` (`pagoId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_Transacciones_Payment_Users1`
    FOREIGN KEY (`userid`)
    REFERENCES `PaymentAsistant`.`Payment_Users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_Transacciones_payment_personas1`
    FOREIGN KEY (`personID`)
    REFERENCES `PaymentAsistant`.`Payment_Personas` (`personID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_Transacciones_payment_transTypes1`
    FOREIGN KEY (`transtypeId`)
    REFERENCES `PaymentAsistant`.`Payment_TransTypes` (`transtypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_Transacciones_payment_personBalance1`
    FOREIGN KEY (`personBalanceId`)
    REFERENCES `PaymentAsistant`.`Payment_PersonBalance` (`personBalanceId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_Transacciones_payment_Funds1`
    FOREIGN KEY (`fundId`)
    REFERENCES `PaymentAsistant`.`Payment_Funds` (`fundId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_CurrencyConversions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_CurrencyConversions` (
  `conversionid` INT NOT NULL AUTO_INCREMENT,
  `startdate` DATE NULL,
  `enddate` DATE NULL,
  `exchangeRate` DECIMAL(10,6) NOT NULL,
  `enabled` BIT(1) NOT NULL,
  `currentExchangeRate` BIT(1) NOT NULL,
  `currencyid_source` INT NOT NULL,
  `currencyid_destiny` INT NOT NULL,
  PRIMARY KEY (`conversionid`),
  INDEX `fk_Payment_CurrencyConversions_Payment_Currencies1_idx` (`currencyid_source` ASC) VISIBLE,
  INDEX `fk_Payment_CurrencyConversions_Payment_Currencies2_idx` (`currencyid_destiny` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_CurrencyConversions_Payment_Currencies1`
    FOREIGN KEY (`currencyid_source`)
    REFERENCES `PaymentAsistant`.`Payment_Currencies` (`currencyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_CurrencyConversions_Payment_Currencies2`
    FOREIGN KEY (`currencyid_destiny`)
    REFERENCES `PaymentAsistant`.`Payment_Currencies` (`currencyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_ScheduleDetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_ScheduleDetails` (
  `scheduleDetails` INT NOT NULL AUTO_INCREMENT,
  `deleted` BIT(1) NOT NULL,
  `baseDate` DATE NOT NULL,
  `datePart` TINYINT NOT NULL,
  `lastExecution` DATETIME NULL,
  `nextExecution` DATETIME NULL,
  `scheduleid` INT NOT NULL,
  PRIMARY KEY (`scheduleDetails`),
  INDEX `fk_Payment_ScheduleDetails_Payment_Schedules1_idx` (`scheduleid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_ScheduleDetails_Payment_Schedules1`
    FOREIGN KEY (`scheduleid`)
    REFERENCES `PaymentAsistant`.`Payment_Schedules` (`scheduleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Subscriptions` (
  `subscriptionid` INT NOT NULL,
  `description` VARCHAR(200) NOT NULL,
  `periodStart` DATE NOT NULL,
  `periodEnd` DATE NULL,
  `enabled` BIT(1) NOT NULL,
  `imgURL` VARCHAR(100) NULL,
  PRIMARY KEY (`subscriptionid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_PlanPrices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_PlanPrices` (
  `planPriceid` INT NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `recurrencyType` TINYINT NOT NULL,
  `postTime` DATETIME NOT NULL,
  `endDate` DATETIME NOT NULL,
  `current` BIT(1) NOT NULL,
  `subscriptionid` INT NOT NULL,
  PRIMARY KEY (`planPriceid`),
  INDEX `fk_Payment_PlanPrices_Payment_Subscriptions1_idx` (`subscriptionid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_PlanPrices_Payment_Subscriptions1`
    FOREIGN KEY (`subscriptionid`)
    REFERENCES `PaymentAsistant`.`Payment_Subscriptions` (`subscriptionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_PlanFeatures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_PlanFeatures` (
  `planFeaturesid` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(45) NOT NULL,
  `enabled` BIT(1) NOT NULL,
  `dataType` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`planFeaturesid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_FeaturesPerPlan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_FeaturesPerPlan` (
  `featuresPerPlanid` INT NOT NULL AUTO_INCREMENT,
  `value` VARCHAR(45) NOT NULL,
  `enabled` BIT(1) NOT NULL,
  `planFeaturesid` INT NOT NULL,
  `subscriptionid` INT NOT NULL,
  PRIMARY KEY (`featuresPerPlanid`, `planFeaturesid`, `subscriptionid`),
  INDEX `fk_Payment_FeaturesPerPlan_Payment_PlanFeatures1_idx` (`planFeaturesid` ASC) VISIBLE,
  INDEX `fk_Payment_FeaturesPerPlan_Payment_Subscriptions1_idx` (`subscriptionid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_FeaturesPerPlan_Payment_PlanFeatures1`
    FOREIGN KEY (`planFeaturesid`)
    REFERENCES `PaymentAsistant`.`Payment_PlanFeatures` (`planFeaturesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_FeaturesPerPlan_Payment_Subscriptions1`
    FOREIGN KEY (`subscriptionid`)
    REFERENCES `PaymentAsistant`.`Payment_Subscriptions` (`subscriptionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_PlanPerEntity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_PlanPerEntity` (
  `planPerPersonid` INT NOT NULL AUTO_INCREMENT,
  `adquisitionDate` DATETIME NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 0,
  `planPriceid` INT NOT NULL,
  `scheduleid` INT NOT NULL,
  `userid` INT NOT NULL,
  `companyid` INT NULL,
  `expirationDate` DATETIME NOT NULL,
  PRIMARY KEY (`planPerPersonid`),
  INDEX `fk_Payment_PlanPerPerson_Payment_PlanPrices1_idx` (`planPriceid` ASC) VISIBLE,
  INDEX `fk_Payment_PlanPerPerson_Payment_Schedules1_idx` (`scheduleid` ASC) VISIBLE,
  INDEX `fk_Payment_PlanPerPerson_Payment_Users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_Payment_PlanPerEntity_Payment_Companies1_idx` (`companyid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_PlanPerPerson_Payment_PlanPrices1`
    FOREIGN KEY (`planPriceid`)
    REFERENCES `PaymentAsistant`.`Payment_PlanPrices` (`planPriceid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_PlanPerPerson_Payment_Schedules1`
    FOREIGN KEY (`scheduleid`)
    REFERENCES `PaymentAsistant`.`Payment_Schedules` (`scheduleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_PlanPerPerson_Payment_Users1`
    FOREIGN KEY (`userid`)
    REFERENCES `PaymentAsistant`.`Payment_Users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_PlanPerEntity_Payment_Companies1`
    FOREIGN KEY (`companyid`)
    REFERENCES `PaymentAsistant`.`Payment_Companies` (`companyid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Paymen_PlanLimits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Paymen_PlanLimits` (
  `planid` INT NOT NULL AUTO_INCREMENT,
  `limit` VARCHAR(10) NOT NULL,
  `planFeaturesid` INT NOT NULL,
  `planPerPersonid` INT NOT NULL,
  `description` VARCHAR(20) NULL,
  PRIMARY KEY (`planid`),
  INDEX `fk_Paymen_PlanLimits_Payment_PlanFeatures1_idx` (`planFeaturesid` ASC) VISIBLE,
  INDEX `fk_Paymen_PlanLimits_Payment_PlanPerPerson1_idx` (`planPerPersonid` ASC) VISIBLE,
  CONSTRAINT `fk_Paymen_PlanLimits_Payment_PlanFeatures1`
    FOREIGN KEY (`planFeaturesid`)
    REFERENCES `PaymentAsistant`.`Payment_PlanFeatures` (`planFeaturesid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Paymen_PlanLimits_Payment_PlanPerPerson1`
    FOREIGN KEY (`planPerPersonid`)
    REFERENCES `PaymentAsistant`.`Payment_PlanPerEntity` (`planPerPersonid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Log` (
  `logid` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(100) NOT NULL,
  `postTime` DATETIME NOT NULL,
  `computer` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `trace` TEXT NULL,
  `referenceid1` BIGINT NULL,
  `referenceid2` BIGINT NULL,
  `value1` BIGINT NULL,
  `value2` BIGINT NULL,
  `checksum` VARBINARY(128) NULL,
  PRIMARY KEY (`logid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_LogTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_LogTypes` (
  `logtypeid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `ref1Desc` VARCHAR(45) NULL,
  `ref2Desc` VARCHAR(45) NULL,
  `val1Desc` VARCHAR(45) NULL,
  `val2Desc` VARCHAR(45) NULL,
  `logid` INT NOT NULL,
  PRIMARY KEY (`logtypeid`),
  INDEX `fk_Payment_LogTypes_Payment_Log1_idx` (`logid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_LogTypes_Payment_Log1`
    FOREIGN KEY (`logid`)
    REFERENCES `PaymentAsistant`.`Payment_Log` (`logid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_LogSources`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_LogSources` (
  `logsourceid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `logid` INT NOT NULL,
  PRIMARY KEY (`logsourceid`),
  INDEX `fk_Payment_LogSources_Payment_Log1_idx` (`logid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_LogSources_Payment_Log1`
    FOREIGN KEY (`logid`)
    REFERENCES `PaymentAsistant`.`Payment_Log` (`logid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_LogSeverity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_LogSeverity` (
  `logseverityid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `logid` INT NOT NULL,
  PRIMARY KEY (`logseverityid`),
  INDEX `fk_Payment_LogSeverity_Payment_Log1_idx` (`logid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_LogSeverity_Payment_Log1`
    FOREIGN KEY (`logid`)
    REFERENCES `PaymentAsistant`.`Payment_Log` (`logid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_Translations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_Translations` (
  `translationid` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(5) NOT NULL,
  `caption` VARCHAR(100) NOT NULL,
  `enabled` BIT(1) NOT NULL DEFAULT 1,
  `languageid` INT NOT NULL,
  PRIMARY KEY (`translationid`),
  INDEX `fk_Payment_Translations_Payment_Languages1_idx` (`languageid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Translations_Payment_Languages1`
    FOREIGN KEY (`languageid`)
    REFERENCES `PaymentAsistant`.`Payment_Languages` (`languageid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_TranslationTask`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_TranslationTask` (
  `transcriptionTaskId` INT NOT NULL AUTO_INCREMENT,
  `apiTaskId` VARCHAR(45) NOT NULL,
  `languageid` INT NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NOT NULL,
  `secretKey` VARBINARY(128) NOT NULL,
  PRIMARY KEY (`transcriptionTaskId`),
  INDEX `fk_payment_TranscripcionTask_Payment_Languages1_idx` (`languageid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_TranscripcionTask_Payment_Languages1`
    FOREIGN KEY (`languageid`)
    REFERENCES `PaymentAsistant`.`Payment_Languages` (`languageid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_TranslationResults`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_TranslationResults` (
  `transcriptionResultsId` INT NOT NULL AUTO_INCREMENT,
  `transcriptionTaskId` INT NOT NULL,
  `transcriptionText` TEXT NOT NULL,
  `summary` TEXT NOT NULL,
  `keywords` VARCHAR(100) NOT NULL,
  `captions` TEXT NOT NULL,
  `errorMessage` TEXT NULL,
  `createdAt` DATETIME NOT NULL,
  PRIMARY KEY (`transcriptionResultsId`),
  INDEX `fk_payment_TranscriptionResults_payment_TranscripcionTask1_idx` (`transcriptionTaskId` ASC) VISIBLE,
  CONSTRAINT `fk_payment_TranscriptionResults_payment_TranscripcionTask1`
    FOREIGN KEY (`transcriptionTaskId`)
    REFERENCES `PaymentAsistant`.`Payment_TranslationTask` (`transcriptionTaskId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_CuePoints`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_CuePoints` (
  `cuePointID` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(255) NOT NULL,
  `startTime` TIMESTAMP NOT NULL,
  `endTime` TIMESTAMP NOT NULL,
  PRIMARY KEY (`cuePointID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_ScreenEvents`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_ScreenEvents` (
  `screenEventid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `enabled` BIT(1) NOT NULL,
  PRIMARY KEY (`screenEventid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_ScreenRecordings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_ScreenRecordings` (
  `screenRecordingsId` INT NOT NULL AUTO_INCREMENT,
  `userid` INT NOT NULL,
  `moduleid` TINYINT(8) NOT NULL,
  `taskDescription` VARCHAR(255) NOT NULL,
  `objectName` VARCHAR(45) NOT NULL,
  `timeline` JSON NOT NULL,
  `tabActions` JSON NOT NULL,
  `cuePointID` INT NOT NULL,
  `applicationid` VARCHAR(30) NOT NULL,
  `value` VARCHAR(80) NULL,
  `screenEventid` INT NOT NULL,
  `uiPath` TEXT NULL,
  PRIMARY KEY (`screenRecordingsId`),
  INDEX `fk_payment_ScreenRecordings_Payment_Users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_payment_ScreenRecordings_Payment_Modules1_idx` (`moduleid` ASC) VISIBLE,
  INDEX `fk_payment_ScreenRecordings_payment_CuePoints1_idx` (`cuePointID` ASC) VISIBLE,
  INDEX `fk_Payment_ScreenRecordings_Payment_EventTypes1_idx` (`screenEventid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_ScreenRecordings_Payment_Users1`
    FOREIGN KEY (`userid`)
    REFERENCES `PaymentAsistant`.`Payment_Users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_ScreenRecordings_Payment_Modules1`
    FOREIGN KEY (`moduleid`)
    REFERENCES `PaymentAsistant`.`Payment_Modules` (`moduleid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_ScreenRecordings_payment_CuePoints1`
    FOREIGN KEY (`cuePointID`)
    REFERENCES `PaymentAsistant`.`Payment_CuePoints` (`cuePointID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_ScreenRecordings_Payment_EventTypes1`
    FOREIGN KEY (`screenEventid`)
    REFERENCES `PaymentAsistant`.`Payment_ScreenEvents` (`screenEventid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_AudioEvent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_AudioEvent` (
  `audioEventid` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `enabled` BIT(1) NOT NULL,
  PRIMARY KEY (`audioEventid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_AudioRecordings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_AudioRecordings` (
  `audioRecordingsID` INT NOT NULL AUTO_INCREMENT,
  `userid` INT NOT NULL,
  `audioId` INT NOT NULL,
  `communicationClusters` JSON NOT NULL,
  `cuePointID` INT NOT NULL,
  `corrections` JSON NOT NULL,
  `audioEventid` INT NOT NULL,
  PRIMARY KEY (`audioRecordingsID`),
  INDEX `fk_payment_audioRecordings_Payment_Users1_idx` (`userid` ASC) VISIBLE,
  INDEX `fk_payment_audioRecordings_payment_CuePoints1_idx` (`cuePointID` ASC) VISIBLE,
  INDEX `fk_Payment_AudioRecordings_Payment_AudioEvent1_idx` (`audioEventid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_audioRecordings_Payment_Users1`
    FOREIGN KEY (`userid`)
    REFERENCES `PaymentAsistant`.`Payment_Users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_audioRecordings_payment_CuePoints1`
    FOREIGN KEY (`cuePointID`)
    REFERENCES `PaymentAsistant`.`Payment_CuePoints` (`cuePointID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_AudioRecordings_Payment_AudioEvent1`
    FOREIGN KEY (`audioEventid`)
    REFERENCES `PaymentAsistant`.`Payment_AudioEvent` (`audioEventid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_UserPreferences`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_UserPreferences` (
  `userPreferenceid` INT NOT NULL AUTO_INCREMENT,
  `userid` INT NOT NULL,
  `jsonConfig` JSON NULL,
  `status` VARCHAR(20) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL,
  PRIMARY KEY (`userPreferenceid`),
  INDEX `fk_payment_configurations_Payment_Users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_payment_configurations_Payment_Users1`
    FOREIGN KEY (`userid`)
    REFERENCES `PaymentAsistant`.`Payment_Users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_AudioTranscripts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_AudioTranscripts` (
  `transcriptionId` INT NOT NULL AUTO_INCREMENT,
  `description` TEXT NOT NULL,
  `createdAt` DATETIME NOT NULL,
  `audioId` INT NOT NULL,
  `audioRecordingsID` INT NOT NULL,
  `accuracy` DECIMAL(5,2) NOT NULL,
  `detectedKeywords` TEXT NULL,
  `value` VARCHAR(80) NULL,
  PRIMARY KEY (`transcriptionId`),
  INDEX `fk_audio_transcriptions_payment_audioRecordings1_idx` (`audioRecordingsID` ASC) VISIBLE,
  CONSTRAINT `fk_audio_transcriptions_payment_audioRecordings1`
    FOREIGN KEY (`audioRecordingsID`)
    REFERENCES `PaymentAsistant`.`Payment_AudioRecordings` (`audioRecordingsID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_ScreenAudioSync`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_ScreenAudioSync` (
  `syncID` INT NOT NULL AUTO_INCREMENT,
  `screenRecordingsId` INT NOT NULL,
  `transcriptionId` INT NOT NULL,
  PRIMARY KEY (`syncID`),
  INDEX `fk_paymentScreenAudioSync_payment_ScreenRecordings1_idx` (`screenRecordingsId` ASC) VISIBLE,
  INDEX `fk_paymentScreenAudioSync_audio_transcriptions1_idx` (`transcriptionId` ASC) VISIBLE,
  CONSTRAINT `fk_paymentScreenAudioSync_payment_ScreenRecordings1`
    FOREIGN KEY (`screenRecordingsId`)
    REFERENCES `PaymentAsistant`.`Payment_ScreenRecordings` (`screenRecordingsId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_paymentScreenAudioSync_audio_transcriptions1`
    FOREIGN KEY (`transcriptionId`)
    REFERENCES `PaymentAsistant`.`Payment_AudioTranscripts` (`transcriptionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_AIProcessingLogs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_AIProcessingLogs` (
  `processingId` INT NOT NULL AUTO_INCREMENT,
  `syncID` INT NOT NULL,
  `utilizedPrompt` TEXT NOT NULL,
  `processingTime` FLOAT NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL,
  `api_key` VARBINARY(128) NOT NULL,
  `iterationNumber` INT NOT NULL,
  `accuracyObtained` DECIMAL(5,2) NOT NULL,
  `generatedResponse` TEXT NOT NULL,
  PRIMARY KEY (`processingId`),
  INDEX `fk_payment_AIProcessingLogs_paymentScreenAudioSync1_idx` (`syncID` ASC) VISIBLE,
  CONSTRAINT `fk_payment_AIProcessingLogs_paymentScreenAudioSync1`
    FOREIGN KEY (`syncID`)
    REFERENCES `PaymentAsistant`.`Payment_ScreenAudioSync` (`syncID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_UserMediaFiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_UserMediaFiles` (
  `userid` INT NOT NULL,
  `mediaFileId` INT NOT NULL,
  `uploadTime` DATETIME NOT NULL,
  PRIMARY KEY (`userid`, `mediaFileId`),
  INDEX `fk_Payment_Users_has_Payment_MediaFiles_Payment_MediaFiles1_idx` (`mediaFileId` ASC) VISIBLE,
  INDEX `fk_Payment_Users_has_Payment_MediaFiles_Payment_Users1_idx` (`userid` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Users_has_Payment_MediaFiles_Payment_Users1`
    FOREIGN KEY (`userid`)
    REFERENCES `PaymentAsistant`.`Payment_Users` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_Users_has_Payment_MediaFiles_Payment_MediaFiles1`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `PaymentAsistant`.`Payment_MediaFiles` (`mediaFileId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_RecordingFiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_RecordingFiles` (
  `cuePointID` INT NOT NULL,
  `mediaFileId` INT NOT NULL,
  PRIMARY KEY (`cuePointID`, `mediaFileId`),
  INDEX `fk_Payment_ScreenRecordingFiles_Payment_MediaFiles1_idx` (`mediaFileId` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_ScreenRecordingFiles_payment_CuePoints1`
    FOREIGN KEY (`cuePointID`)
    REFERENCES `PaymentAsistant`.`Payment_CuePoints` (`cuePointID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_ScreenRecordingFiles_Payment_MediaFiles1`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `PaymentAsistant`.`Payment_MediaFiles` (`mediaFileId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_TranscriptFiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_TranscriptFiles` (
  `transcriptionId` INT NOT NULL,
  `transcriptFileid` VARCHAR(45) NOT NULL,
  `mediaFileId` INT NOT NULL,
  `partNumber` INT NULL,
  `iterationNumber` INT NOT NULL,
  INDEX `fk_Payment_TranscriptFiles_Payment_AudioTranscripts1_idx` (`transcriptionId` ASC) VISIBLE,
  PRIMARY KEY (`transcriptFileid`),
  INDEX `fk_Payment_TranscriptFiles_Payment_MediaFiles1_idx` (`mediaFileId` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_TranscriptFiles_Payment_AudioTranscripts1`
    FOREIGN KEY (`transcriptionId`)
    REFERENCES `PaymentAsistant`.`Payment_AudioTranscripts` (`transcriptionId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_TranscriptFiles_Payment_MediaFiles1`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `PaymentAsistant`.`Payment_MediaFiles` (`mediaFileId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PaymentAsistant`.`Payment_TranslationFiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PaymentAsistant`.`Payment_TranslationFiles` (
  `translationFileid` INT NOT NULL AUTO_INCREMENT,
  `transcriptionTaskId` INT NOT NULL,
  `mediaFileId` INT NOT NULL,
  PRIMARY KEY (`translationFileid`),
  INDEX `fk_Payment_TranslationFiles_Payment_TranslationTask1_idx` (`transcriptionTaskId` ASC) VISIBLE,
  INDEX `fk_Payment_TranslationFiles_Payment_MediaFiles1_idx` (`mediaFileId` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_TranslationFiles_Payment_TranslationTask1`
    FOREIGN KEY (`transcriptionTaskId`)
    REFERENCES `PaymentAsistant`.`Payment_TranslationTask` (`transcriptionTaskId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Payment_TranslationFiles_Payment_MediaFiles1`
    FOREIGN KEY (`mediaFileId`)
    REFERENCES `PaymentAsistant`.`Payment_MediaFiles` (`mediaFileId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
