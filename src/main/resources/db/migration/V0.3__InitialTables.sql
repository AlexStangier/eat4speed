-- MySQL Script generated by MySQL Workbench
-- Sat Jan 30 18:54:35 2021
-- Model: New Model    Version: 1.1
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE = 'TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema eatforspeed
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema eatforspeed
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `eatforspeed` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `eatforspeed`;


-- -----------------------------------------------------
-- Table `eatforspeed`.`hibernate_sequence`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `eatforspeed`.`hibernate_sequence`
(
    ORDID INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (ordid)
)
    AUTO_INCREMENT = 1;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Adressen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Adressen`
(
    `Adress_ID`    INT         NOT NULL AUTO_INCREMENT,
    `Strasse`      VARCHAR(50) NOT NULL,
    `Hausnummer`   INT         NOT NULL,
    `Ort`          VARCHAR(50) NOT NULL,
    `Postleitzahl` INT         NOT NULL,
    PRIMARY KEY (`Adress_ID`)
)
    ENGINE = InnoDB
    AUTO_INCREMENT = 4
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Allergene`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Allergene`
(
    `Name`         VARCHAR(20)  NOT NULL,
    `Beschreibung` VARCHAR(200) NULL DEFAULT NULL,
    PRIMARY KEY (`Name`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Benutzer`
-- -----------------------------------------------------
-- DROP TABLE Benutzer;
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Benutzer`
(
    `Benutzer_ID`     INT         NOT NULL AUTO_INCREMENT,
    `Benutzername`    VARCHAR(50) NULL DEFAULT NULL,
    `Vorname`         VARCHAR(50) NOT NULL,
    `Nachname`        VARCHAR(50) NOT NULL,
    `EmailAdresse`    VARCHAR(50) NOT NULL,
    `Passwort`        VARCHAR(50) NOT NULL,
    `Rolle`           INT NOT NULL,
    `Paypal_Account`  VARCHAR(50) NOT NULL,
    `Telefonnummer`   VARCHAR(50) NOT NULL,
    PRIMARY KEY (`Benutzer_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Kunde`
-- -----------------------------------------------------
-- DROP TABLE Kunde;
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Kunde`
(
    `Kundennummer`    INT         NOT NULL AUTO_INCREMENT,
    `Anrede`          VARCHAR(10) NOT NULL,
    `Benutzer_ID`    INT NOT NULL,
    `Name`            VARCHAR(50) NOT NULL,
    `Vorname`         VARCHAR(50) NOT NULL,
    `Anschrift`       INT         NOT NULL,
    `Bestellhistorie` VARCHAR(50) NULL DEFAULT NULL,
    PRIMARY KEY (`Kundennummer`),
    INDEX `fk_Kunde_Benutzername` (`Benutzer_ID` ASC),
    INDEX `fk_Kunde_Adresse` (`Anschrift` ASC),
    CONSTRAINT `fk_Kunde_Adresse`
        FOREIGN KEY (`Anschrift`)
            REFERENCES `eatforspeed`.`Adressen` (`Adress_ID`),
    CONSTRAINT `fk_Kunde_Benutzer_ID`
        FOREIGN KEY (`Benutzer_ID`)
            REFERENCES `eatforspeed`.`Benutzer` (`Benutzer_ID`)
)
    ENGINE = InnoDB
    AUTO_INCREMENT = 6
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Rechnung`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Rechnung`
(
    `Rechnungs_ID`          INT        NOT NULL AUTO_INCREMENT,
    `Betrag`                DOUBLE     NOT NULL,
    `Rechnungsdatum`        DATETIME   NOT NULL,
    `Zahlungseingang`       TINYINT(1) NOT NULL,
    `Datum_Zahlungseingang` DATETIME   NULL DEFAULT NULL,
    PRIMARY KEY (`Rechnungs_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Status`
(
    `Status_Name`  VARCHAR(10) NOT NULL,
    `Rechnungs_ID` INT         ,
    PRIMARY KEY (`Status_Name`),
    INDEX `fk_Status_Rechnungs_ID` (`Rechnungs_ID` ASC),
    CONSTRAINT `fk_Status_Rechnungs_ID`
        FOREIGN KEY (`Rechnungs_ID`)
            REFERENCES `eatforspeed`.`Rechnung` (`Rechnungs_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Auftrag`
-- -----------------------------------------------------
-- DROP TABLE Auftrag;
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Auftrag`
(
    `Auftrags_ID`   INT           NOT NULL AUTO_INCREMENT,
    `Kundennummer`  INT           NOT NULL,
    `Auftragnehmer` INT           NOT NULL,
    `Timestamp`     DATETIME      NOT NULL,
    `Anschrift`     INT           NOT NULL,
    `Status`        VARCHAR(10)   NOT NULL,
    `Lieferdistanz` DOUBLE(50, 4) NULL DEFAULT NULL,
    `Geschaetzte_Fahrtzeit_Restaurant_Ziel` INT,
    `Timestamp_On_Status_Abgeholt` DATETIME,
    PRIMARY KEY (`Auftrags_ID`),
    INDEX `fk_Auftrag_Kundennummer` (`Kundennummer` ASC),
    INDEX `fk_Auftrag_Status` (`Status` ASC),
    CONSTRAINT `fk_Auftrag_Kundennummer`
        FOREIGN KEY (`Kundennummer`)
            REFERENCES `eatforspeed`.`Kunde` (`Kundennummer`),
    CONSTRAINT `fk_Auftrag_Status`
        FOREIGN KEY (`Status`)
            REFERENCES `eatforspeed`.`Status` (`Status_Name`),
    CONSTRAINT `fk_Auftrag_Auftragnehmer`
        FOREIGN KEY (`Auftragnehmer`)
            REFERENCES `eatforspeed`.`Restaurant` (`Restaurant_ID`),
    CONSTRAINT `fk_Auftrag_Anschrift`
        FOREIGN KEY (`Anschrift`)
            REFERENCES `eatforspeed`.`Adressen` (`Adress_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Fahrzeug`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Fahrzeug`
(
    `Fahrzeug_ID` INT         NOT NULL AUTO_INCREMENT,
    `Fahrzeugtyp` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`Fahrzeug_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Fahrer`
-- -----------------------------------------------------
-- DROP TABLE Fahrer;
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Fahrer`
(
    `Fahrernummer`       INT         NOT NULL AUTO_INCREMENT,
    `Benutzer_ID`        INT NOT NULL,
    `Geburtsdatum`       DATETIME   NOT NULL,
    `Fuehrerschein`      VARCHAR(50),
    `Geleistete_Fahrten` INT         NULL DEFAULT NULL,
    `Ist_in_Pause`       TINYINT(1)  NOT NULL,
    `Fahrzeug`           INT,
    `aktueller_Standort` INT,
    `Anzahl_aktuelle_Auftraege` INT NOT NULL,
    `verifiziert`             TINYINT(1) NOT NULL,
    PRIMARY KEY (`Fahrernummer`),
    INDEX `fk_Fahrer_Fahrzeug` (`Fahrzeug` ASC),
    INDEX `fk_Fahrer_Benutzer` (`Benutzer_ID` ASC),
    CONSTRAINT `fk_Fahrer_Benutzer`
        FOREIGN KEY (`Benutzer_ID`)
            REFERENCES `eatforspeed`.`Benutzer` (`Benutzer_ID`),
    CONSTRAINT `fk_Fahrer_Fahrzeug`
        FOREIGN KEY (`Fahrzeug`)
            REFERENCES `eatforspeed`.`Fahrzeug` (`Fahrzeug_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Restaurant`
-- -----------------------------------------------------
-- DROP TABLE Restaurant;
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Restaurant`
(
    `Restaurant_ID`           INT          NOT NULL AUTO_INCREMENT,
    `Benutzer_ID`            INT  NOT NULL,
    `Name_des_Restaurants`    VARCHAR(50)  NOT NULL,
    `Allgemeine_Beschreibung` VARCHAR(200) NOT NULL,
    `Anschrift`               INT          NOT NULL,
    `Mindestbestellwert`         DOUBLE    DEFAULT 0,
    `Bestellradius`         DOUBLE    DEFAULT 0,
    `verifiziert`             TINYINT(1) NOT NULL,
    PRIMARY KEY (`Restaurant_ID`),
    INDEX `fk_Restaurant_Benutzername` (`Benutzer_ID` ASC),
    INDEX `fk_Restaurant_Anschrift` (`Anschrift` ASC),
    CONSTRAINT `fk_Restaurant_Anschrift`
        FOREIGN KEY (`Anschrift`)
            REFERENCES `eatforspeed`.`Adressen` (`Adress_ID`),
    CONSTRAINT `fk_Restaurant_Benutzer_ID`
        FOREIGN KEY (`Benutzer_ID`)
            REFERENCES `eatforspeed`.`Benutzer` (`Benutzer_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Benachrichtigung_Fahrer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Benachrichtigung_Fahrer`
(
    `Benachrichtigungs_ID` INT          NOT NULL AUTO_INCREMENT,
    `Fahrernummer`         INT          NOT NULL,
    `Benachrichtigung`     VARCHAR(200) NOT NULL,
    `Restaurant_ID`        INT          NULL DEFAULT NULL,
    `Timestamp`            DATETIME     NOT NULL,
    PRIMARY KEY (`Benachrichtigungs_ID`),
    INDEX `fk_Benachrichtigung_Fahrer_Fahrernummer` (`Fahrernummer` ASC),
    INDEX `fk_Benachrichtigung_Fahrer_Restaurant_ID` (`Restaurant_ID` ASC),
    CONSTRAINT `fk_Benachrichtigung_Fahrer_Fahrernummer`
        FOREIGN KEY (`Fahrernummer`)
            REFERENCES `eatforspeed`.`Fahrer` (`Fahrernummer`),
    CONSTRAINT `fk_Benachrichtigung_Fahrer_Restaurant_ID`
        FOREIGN KEY (`Restaurant_ID`)
            REFERENCES `eatforspeed`.`Restaurant` (`Restaurant_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Gericht`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Gericht`
(
    `Gericht_ID`    INT          NOT NULL AUTO_INCREMENT,
    `Restaurant_ID` INT          NOT NULL,
    `Name`          VARCHAR(50)  NOT NULL,
    `Beschreibung`  VARCHAR(200) NOT NULL,
    `Abbildung`     BLOB         NULL DEFAULT NULL,
    `Preis`         DOUBLE       NOT NULL,
    `Verfuegbar`    TINYINT(1)   NOT NULL,
    PRIMARY KEY (`Gericht_ID`),
    CONSTRAINT `fk_Gericht_Restaurant_ID`
        FOREIGN KEY (`Restaurant_ID`)
            REFERENCES `eatforspeed`.`Restaurant` (`Restaurant_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Benachrichtigung_Kunde`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Benachrichtigung_Kunde`
(
    `Benachrichtigungs_ID` INT          NOT NULL AUTO_INCREMENT,
    `Kunde_ID`             INT          NOT NULL,
    `Benachrichtigung`     VARCHAR(200) NOT NULL,
    `Gericht`              INT          NULL DEFAULT NULL,
    `Timestamp`            DATETIME     NOT NULL,
    PRIMARY KEY (`Benachrichtigungs_ID`),
    INDEX `fk_Benachrichtigung_Kunde_Kunde_ID` (`Kunde_ID` ASC),
    INDEX `fk_Benachrichtigung_Kunde_Gericht` (`Gericht` ASC),
    CONSTRAINT `fk_Benachrichtigung_Kunde_Gericht`
        FOREIGN KEY (`Gericht`)
            REFERENCES `eatforspeed`.`Gericht` (`Gericht_ID`),
    CONSTRAINT `fk_Benachrichtigung_Kunde_Kunde_ID`
        FOREIGN KEY (`Kunde_ID`)
            REFERENCES `eatforspeed`.`Kunde` (`Kundennummer`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Bestellhistorie`
-- -----------------------------------------------------
-- DROP TABLE Bestellhistorie;
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Bestellhistorie`
(
    `Bestellhistorien_ID` INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`Bestellhistorien_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eatforspeed`.`Restaurant_Bestellhistorie`
-- -----------------------------------------------------
-- DROP TABLE Restaurant_Bestellhistorie;
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Restaurant_Bestellhistorie`
(
    `Bestellhistorien_ID`   INT NOT NULL,
    `Restaurant_ID`           INT NOT NULL,
    PRIMARY KEY (`Bestellhistorien_ID`, `Restaurant_ID`),
    CONSTRAINT `fk_Restaurant_Bestellhistorie_Bestellhistorien_ID`
        FOREIGN KEY (`Bestellhistorien_ID`)
            REFERENCES `eatforspeed`.`Bestellhistorie` (`Bestellhistorien_ID`),
    CONSTRAINT `fk_Restaurant_Bestellhistorie_Restaurant_ID`
        FOREIGN KEY (`Restaurant_ID`)
            REFERENCES `eatforspeed`.`Restaurant` (`Restaurant_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eatforspeed`.`Bestellung`
-- -----------------------------------------------------
-- DROP TABLE Bestellung;
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Bestellung`
(
    `Bestell_ID`          INT      NOT NULL AUTO_INCREMENT,
    `Bestellhistorien_ID` INT      NOT NULL,
    `Auftrags_ID`         INT      NULL DEFAULT NULL,
    `Timestamp`           DATETIME NOT NULL,
    `Rechnung`            INT      NULL DEFAULT NULL,
    PRIMARY KEY (`Bestell_ID`),
    CONSTRAINT `fk_Bestellung_Auftrags_ID`
        FOREIGN KEY (`Auftrags_ID`)
            REFERENCES `eatforspeed`.`Auftrag` (`Auftrags_ID`),
    CONSTRAINT `fk_Bestellung_Bestellhistorien_ID`
        FOREIGN KEY (`Bestellhistorien_ID`)
            REFERENCES `eatforspeed`.`Bestellhistorie` (`Bestellhistorien_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eatforspeed`.`Schicht`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Schicht`
(
    `Schicht_ID`          INT      NOT NULL AUTO_INCREMENT,
    `Fahrernummer`        INT      NOT NULL,
    `Anfang`              DATETIME      NULL DEFAULT NULL,
    `Ende`                DATETIME NOT NULL,
    PRIMARY KEY (`Schicht_ID`),
    CONSTRAINT `fk_Schicht_Fahrernummer`
        FOREIGN KEY (`Fahrernummer`)
            REFERENCES `eatforspeed`.`Fahrer` (`Fahrernummer`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eatforspeed`.`Bewertung`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Bewertung`
(
    `Bewertungs_ID`       INT      NOT NULL AUTO_INCREMENT,
    `Kundennummer`        INT      NOT NULL,
    `Restaurant_ID`       INT      NULL DEFAULT NULL,
    `Sterne`              INT NOT NULL,
    `Text`                VARCHAR(300)   NULL DEFAULT NULL,
    `Datum`               DATETIME      NULL DEFAULT NULL,
    `wurde_gemeldet`      TINYINT(1) NOT NULL,
    PRIMARY KEY (`Bewertungs_ID`),
    CONSTRAINT `fk_Bewertung_Kundennummer`
        FOREIGN KEY (`Kundennummer`)
            REFERENCES `eatforspeed`.`Kunde` (`Kundennummer`),
    CONSTRAINT `fk_Bewertung_Restaurant_ID`
        FOREIGN KEY (`Restaurant_ID`)
            REFERENCES `eatforspeed`.`Restaurant` (`Restaurant_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eatforspeed`.`Bestellzuordnung`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Bestellzuordnung`
(
    `Bestell_ID` INT NOT NULL,
    `Gericht_ID` INT NOT NULL,
    PRIMARY KEY (`Bestell_ID`, `Gericht_ID`),
    INDEX `fk_Bestellzuordnung_Gericht_ID` (`Gericht_ID` ASC),
    CONSTRAINT `fk_Bestellzuordnung_Bestell_ID`
        FOREIGN KEY (`Bestell_ID`)
            REFERENCES `eatforspeed`.`Bestellung` (`Bestell_ID`),
    CONSTRAINT `fk_Bestellzuordnung_Gericht_ID`
        FOREIGN KEY (`Gericht_ID`)
            REFERENCES `eatforspeed`.`Gericht` (`Gericht_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Einnahmen`
-- -----------------------------------------------------
-- DROP TABLE Einnahmen;
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Einnahmen`
(
    `Einnahmen_ID`  INT           NOT NULL AUTO_INCREMENT,
    `Restaurant_ID` INT           NOT NULL,
    `Umsatz`        INT NOT NULL,
    `Monat`         INT           NOT NULL,
    `Jahr`          INT           NOT NULL,
    PRIMARY KEY (`Einnahmen_ID`),
    CONSTRAINT `fk_Einnahmen_Restaurant_ID`
        FOREIGN KEY (`Restaurant_ID`)
            REFERENCES `eatforspeed`.`Restaurant` (`Restaurant_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Gericht_Allergene`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Gericht_Allergene`
(
    `Gericht_ID` INT         NOT NULL,
    `Allergen`   VARCHAR(50) NOT NULL,
    PRIMARY KEY (`Gericht_ID`, `Allergen`),
    INDEX `fk_Allergene_Gericht_Allergene` (`Allergen` ASC),
    CONSTRAINT `fk_Allergene_Gericht_Allergene`
        FOREIGN KEY (`Allergen`)
            REFERENCES `eatforspeed`.`Allergene` (`Name`),
    CONSTRAINT `fk_Gericht_Gericht_Allergene`
        FOREIGN KEY (`Gericht_ID`)
            REFERENCES `eatforspeed`.`Gericht` (`Gericht_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Inhaltsstoffe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Inhaltsstoffe`
(
    `Name`         VARCHAR(20)  NOT NULL,
    `Beschreibung` VARCHAR(200) NULL DEFAULT NULL,
    PRIMARY KEY (`Name`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Gericht_Inhaltsstoffe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Gericht_Inhaltsstoffe`
(
    `Gericht_ID`   INT         NOT NULL,
    `Inhaltsstoff` VARCHAR(50) NOT NULL,
    `Menge`        INT         NULL DEFAULT NULL,
    PRIMARY KEY (`Gericht_ID`, `Inhaltsstoff`),
    INDEX `fk_Inhaltsstoffe_Gericht_Inhaltsstoffe` (`Inhaltsstoff` ASC),
    CONSTRAINT `fk_Gericht_Gericht_Inhaltsstoffe`
        FOREIGN KEY (`Gericht_ID`)
            REFERENCES `eatforspeed`.`Gericht` (`Gericht_ID`),
    CONSTRAINT `fk_Inhaltsstoffe_Gericht_Inhaltsstoffe`
        FOREIGN KEY (`Inhaltsstoff`)
            REFERENCES `eatforspeed`.`Inhaltsstoffe` (`Name`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Kategorie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Kategorie`
(
    `Kategorie_ID` INT          NOT NULL AUTO_INCREMENT,
    `Name`         VARCHAR(20)  NOT NULL,
    `Beschreibung` VARCHAR(200) NULL DEFAULT NULL,
    PRIMARY KEY (`Kategorie_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Gericht_Kategorie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Gericht_Kategorie`
(
    `Gericht_ID`   INT NOT NULL,
    `Kategorie_ID` INT NOT NULL,
    PRIMARY KEY (`Gericht_ID`, `Kategorie_ID`),
    INDEX `fk_Kategorie_Gericht_Kategorie` (`Kategorie_ID` ASC),
    CONSTRAINT `fk_Gericht_Gericht_Kategorie`
        FOREIGN KEY (`Gericht_ID`)
            REFERENCES `eatforspeed`.`Gericht` (`Gericht_ID`),
    CONSTRAINT `fk_Kategorie_Gericht_Kategorie`
        FOREIGN KEY (`Kategorie_ID`)
            REFERENCES `eatforspeed`.`Kategorie` (`Kategorie_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Oeffnungszeiten`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Oeffnungszeiten`
(
    `Oeffnungszeiten_ID` INT         NOT NULL AUTO_INCREMENT,
    `Anfang`             TIME        NOT NULL,
    `Ende`               TIME        NOT NULL,
    `Wochentag`          VARCHAR(10) NOT NULL,
    PRIMARY KEY (`Oeffnungszeiten_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eatforspeed`.`Fahrtenplan`
-- -----------------------------------------------------
-- DROP TABLE `eatforspeed`.`Fahrtenplan`;
CREATE TABLE IF NOT EXISTS  Fahrtenplan
(
    `Fahrtenplan_ID`       INT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Auftrag_ID`           INT       NOT NULL,
    `Fahrernummer`         INT       NOT NULL,
    `Liefer_Abholadresse`  INT       NOT NULL,
    `Vorherige_Station`    INT       NOT NULL,
    `Fahrzeit_A_B`         INT,
    `Distanz_zu_naechster_Station` INT,
    `Geschaetzte_Fahrtzeit` INT,
    CONSTRAINT `fk_Fahrtenplan_Auftrag_ID`
        FOREIGN KEY (`Auftrag_ID`)
            REFERENCES `eatforspeed`.`Auftrag` (`Auftrags_ID`),
    CONSTRAINT `fk_Fahrtenplan_Fahrernummer`
        FOREIGN KEY (`Fahrernummer`)
            REFERENCES `eatforspeed`.`Fahrer` (`Fahrernummer`),
    CONSTRAINT `fk_Fahrtenplan_Vorherige_Station`
        FOREIGN KEY (`Vorherige_Station`)
            REFERENCES `eatforspeed`.`Fahrtenplan` (`Fahrtenplan_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eatforspeed`.`Restaurant_Zeiten`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Restaurant_Zeiten`
(
    `Restaurant_ID`      INT NOT NULL,
    `Oeffnungszeiten_ID` INT NOT NULL,
    PRIMARY KEY (`Restaurant_ID`),
    INDEX `fk_Restaurant_Zeiten_Oeffnungszeiten_ID` (`Oeffnungszeiten_ID` ASC),
    CONSTRAINT `fk_Restaurant_Zeiten_Oeffnungszeiten_ID`
        FOREIGN KEY (`Oeffnungszeiten_ID`)
            REFERENCES `eatforspeed`.`Oeffnungszeiten` (`Oeffnungszeiten_ID`),
    CONSTRAINT `fk_Restaurant_Zeiten_Restaurant_ID`
        FOREIGN KEY (`Restaurant_ID`)
            REFERENCES `eatforspeed`.`Restaurant` (`Restaurant_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Urlaub`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Urlaub`
(
    `Urlaubs_ID`   INT  NOT NULL AUTO_INCREMENT,
    `Fahrernummer` INT  NOT NULL,
    `Anfang`       DATE NOT NULL,
    `Ende`         DATE NOT NULL,
    PRIMARY KEY (`Urlaubs_ID`),
    INDEX `fk_Urlaub_Fahrernummer` (`Fahrernummer` ASC),
    CONSTRAINT `fk_Urlaub_Fahrernummer`
        FOREIGN KEY (`Fahrernummer`)
            REFERENCES `eatforspeed`.`Fahrer` (`Fahrernummer`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Favoritenliste_Restaurant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Favoritenliste_Restaurant`
(
    `Restaurant_ID`         INT  NOT NULL,
    `Kundennummer`          INT  NOT NULL,
    `Hinzufuege_Datum`      DATE NOT NULL,
    `Anzahl_Bestellungen`   INT NOT NULL,
    PRIMARY KEY (`Restaurant_ID`),
    INDEX `fk_Favoritenliste_Restaurant_Restaurant_ID` (`Restaurant_ID` ASC),
    CONSTRAINT `fk_Favoritenliste_Restaurant_Restaurant_ID`
        FOREIGN KEY (`Restaurant_ID`)
            REFERENCES `eatforspeed`.`Restaurant` (`Restaurant_ID`),
    CONSTRAINT `fk_Favoritenliste_Restaurant_Kundennummer`
        FOREIGN KEY (`Kundennummer`)
            REFERENCES `eatforspeed`.`Kunde` (`Kundennummer`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eatforspeed`.`Favoritenliste_Gericht`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Favoritenliste_Gericht`
(
    `Gericht_ID`            INT  NOT NULL,
    `Kundennummer`          INT  NOT NULL,
    `Hinzufuege_Datum`      DATE NOT NULL,
    `Anzahl_Bestellungen`   INT NOT NULL,
    PRIMARY KEY (`Gericht_ID`),
    INDEX `fk_Favoritenliste_Gericht_Gericht_ID` (`Gericht_ID` ASC),
    CONSTRAINT `fk_Favoritenliste_Gericht_Gericht_ID`
        FOREIGN KEY (`Gericht_ID`)
            REFERENCES `eatforspeed`.`Gericht` (`Gericht_ID`),
    CONSTRAINT `fk_Favoritenliste_Gericht_Kundennummer`
        FOREIGN KEY (`Kundennummer`)
            REFERENCES `eatforspeed`.`Kunde` (`Kundennummer`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eatforspeed`.`Blacklist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Blacklist`
(
    `Eintrag_ID`           INT  NOT NULL,
    `EmailAdresse`         VARCHAR(50) NOT NULL,
    `Loeschbegruendung`    VARCHAR(50) NOT NULL,
    PRIMARY KEY (`Eintrag_ID`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;
