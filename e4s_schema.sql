-- -----------------------------------------------------
-- Schema eatforspeed
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `eatforspeed` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `eatforspeed` ;

-- -----------------------------------------------------
-- Table `eatforspeed`.`Adressen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Adressen` (
  `Adress_ID` INT NOT NULL AUTO_INCREMENT,
  `Strasse` VARCHAR(50) NOT NULL,
  `Hausnummer` INT NOT NULL,
  `Ort` VARCHAR(50) NOT NULL,
  `Postleitzahl` INT NOT NULL,
  PRIMARY KEY (`Adress_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Allergene`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Allergene` (
  `Name` VARCHAR(20) NOT NULL,
  `Beschreibung` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`Name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Benutzer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Benutzer` (
  `Benutzername` VARCHAR(50) NOT NULL,
  `E_Mail_Addresse` VARCHAR(50) NOT NULL,
  `Passwort` VARCHAR(50) NOT NULL,
  `Rolle` VARCHAR(10) NOT NULL,
  `Paypal_Account` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Benutzername`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Kunde`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Kunde` (
  `Kundennummer` INT NOT NULL AUTO_INCREMENT,
  `Benutzername` VARCHAR(50) NOT NULL,
  `Name` VARCHAR(50) NOT NULL,
  `Vorname` VARCHAR(50) NOT NULL,
  `Anschrift` INT NOT NULL,
  `Bestellhistorie` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`Kundennummer`),
  INDEX `fk_Kunde_Benutzername` (`Benutzername` ASC),
  INDEX `fk_Kunde_Adresse` (`Anschrift` ASC),
  CONSTRAINT `fk_Kunde_Adresse`
    FOREIGN KEY (`Anschrift`)
    REFERENCES `eatforspeed`.`Adressen` (`Adress_ID`),
  CONSTRAINT `fk_Kunde_Benutzername`
    FOREIGN KEY (`Benutzername`)
    REFERENCES `eatforspeed`.`Benutzer` (`Benutzername`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Rechnung`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Rechnung` (
  `Rechnungs_ID` INT NOT NULL AUTO_INCREMENT,
  `Betrag` DOUBLE NOT NULL,
  `Rechnungsdatum` DATETIME NOT NULL,
  `Zahlungseingang` TINYINT(1) NOT NULL,
  `Datum_Zahlungseingang` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`Rechnungs_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Status` (
  `Status_Name` VARCHAR(10) NOT NULL,
  `Rechnungs_ID` INT NOT NULL,
  PRIMARY KEY (`Status_Name`),
  INDEX `fk_Status_Rechnungs_ID` (`Rechnungs_ID` ASC),
  CONSTRAINT `fk_Status_Rechnungs_ID`
    FOREIGN KEY (`Rechnungs_ID`)
    REFERENCES `eatforspeed`.`Rechnung` (`Rechnungs_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Auftrag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Auftrag` (
  `Auftrags_ID` INT NOT NULL AUTO_INCREMENT,
  `Kundennummer` INT NOT NULL,
  `Auftragnehmer` INT NOT NULL,
  `Timestamp` DATETIME NOT NULL,
  `Anschrift` INT NOT NULL,
  `Status` VARCHAR(10) NOT NULL,
  `Lieferdistanz` DOUBLE(50,4) NULL DEFAULT NULL,
  PRIMARY KEY (`Auftrags_ID`),
  INDEX `fk_Auftrag_Kundennummer` (`Kundennummer` ASC),
  INDEX `fk_Auftrag_Status` (`Status` ASC),
  CONSTRAINT `fk_Auftrag_Kundennummer`
    FOREIGN KEY (`Kundennummer`)
    REFERENCES `eatforspeed`.`Kunde` (`Kundennummer`),
  CONSTRAINT `fk_Auftrag_Status`
    FOREIGN KEY (`Status`)
    REFERENCES `eatforspeed`.`Status` (`Status_Name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Fahrzeug`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Fahrzeug` (
  `Fahrzeug_ID` INT NOT NULL AUTO_INCREMENT,
  `Fahrzeugtyp` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`Fahrzeug_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Fahrer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Fahrer` (
  `Fahrernummer` INT NOT NULL AUTO_INCREMENT,
  `Benutzername` VARCHAR(50) NOT NULL,
  `Geleistete_Fahrten` INT NULL DEFAULT NULL,
  `Ist_in_Pause` TINYINT(1) NOT NULL,
  `Fahrzeug` INT NOT NULL,
  PRIMARY KEY (`Fahrernummer`),
  INDEX `fk_Fahrer_Fahrzeug` (`Fahrzeug` ASC),
  INDEX `fk_Fahrer_Benutzer` (`Benutzername` ASC),
  CONSTRAINT `fk_Fahrer_Benutzer`
    FOREIGN KEY (`Benutzername`)
    REFERENCES `eatforspeed`.`Benutzer` (`Benutzername`),
  CONSTRAINT `fk_Fahrer_Fahrzeug`
    FOREIGN KEY (`Fahrzeug`)
    REFERENCES `eatforspeed`.`Fahrzeug` (`Fahrzeug_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Restaurant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Restaurant` (
  `Restaurant_ID` INT NOT NULL AUTO_INCREMENT,
  `Benutzername` VARCHAR(50) NOT NULL,
  `Name_des_Restaurants` VARCHAR(50) NOT NULL,
  `Allgemeine_Beschreibung` VARCHAR(200) NOT NULL,
  `Anschrift` INT NOT NULL,
  PRIMARY KEY (`Restaurant_ID`),
  INDEX `fk_Restaurant_Benutzername` (`Benutzername` ASC),
  INDEX `fk_Restaurant_Anschrift` (`Anschrift` ASC),
  CONSTRAINT `fk_Restaurant_Anschrift`
    FOREIGN KEY (`Anschrift`)
    REFERENCES `eatforspeed`.`Adressen` (`Adress_ID`),
  CONSTRAINT `fk_Restaurant_Benutzername`
    FOREIGN KEY (`Benutzername`)
    REFERENCES `eatforspeed`.`Benutzer` (`Benutzername`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Benachrichtigung_Fahrer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Benachrichtigung_Fahrer` (
  `Benachrichtigungs_ID` INT NOT NULL AUTO_INCREMENT,
  `Fahrernummer` INT NOT NULL,
  `Benachrichtigung` VARCHAR(200) NOT NULL,
  `Restaurant_ID` INT NULL DEFAULT NULL,
  `Timestamp` DATETIME NOT NULL,
  PRIMARY KEY (`Benachrichtigungs_ID`),
  INDEX `fk_Benachrichtigung_Fahrer_Fahrernummer` (`Fahrernummer` ASC),
  INDEX `fk_Benachrichtigung_Fahrer_Restaurant_ID` (`Restaurant_ID` ASC),
  CONSTRAINT `fk_Benachrichtigung_Fahrer_Fahrernummer`
    FOREIGN KEY (`Fahrernummer`)
    REFERENCES `eatforspeed`.`Fahrer` (`Fahrernummer`),
  CONSTRAINT `fk_Benachrichtigung_Fahrer_Restaurant_ID`
    FOREIGN KEY (`Restaurant_ID`)
    REFERENCES `eatforspeed`.`Restaurant` (`Restaurant_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Gericht`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Gericht` (
  `Gericht_ID` INT NOT NULL AUTO_INCREMENT,
  `Restaurant_ID` INT NOT NULL,
  `Name` VARCHAR(50) NOT NULL,
  `Beschreibung` VARCHAR(200) NOT NULL,
  `Abbildung` BLOB NULL DEFAULT NULL,
  `Preis` DOUBLE NOT NULL,
  `Verfuegbar` TINYINT(1) NOT NULL,
  PRIMARY KEY (`Gericht_ID`),
  INDEX `fk_Gericht_Restaurant_ID` (`Restaurant_ID` ASC),
  CONSTRAINT `fk_Gericht_Restaurant_ID`
    FOREIGN KEY (`Restaurant_ID`)
    REFERENCES `eatforspeed`.`Restaurant` (`Restaurant_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Benachrichtigung_Kunde`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Benachrichtigung_Kunde` (
  `Benachrichtigungs_ID` INT NOT NULL AUTO_INCREMENT,
  `Kunde_ID` INT NOT NULL,
  `Benachrichtigung` VARCHAR(200) NOT NULL,
  `Gericht` INT NULL DEFAULT NULL,
  `Timestamp` DATETIME NOT NULL,
  PRIMARY KEY (`Benachrichtigungs_ID`),
  INDEX `fk_Benachrichtigung_Kunde_Kunde_ID` (`Kunde_ID` ASC),
  INDEX `fk_Benachrichtigung_Kunde_Gericht` (`Gericht` ASC),
  CONSTRAINT `fk_Benachrichtigung_Kunde_Gericht`
    FOREIGN KEY (`Gericht`)
    REFERENCES `eatforspeed`.`Gericht` (`Gericht_ID`),
  CONSTRAINT `fk_Benachrichtigung_Kunde_Kunde_ID`
    FOREIGN KEY (`Kunde_ID`)
    REFERENCES `eatforspeed`.`Kunde` (`Kundennummer`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Bestellhistorie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Bestellhistorie` (
  `Bestellhistorien_ID` INT NOT NULL AUTO_INCREMENT,
  `Restaurant` INT NOT NULL,
  PRIMARY KEY (`Bestellhistorien_ID`),
  INDEX `fk_Bestellhistorie_Restaurant` (`Restaurant` ASC),
  CONSTRAINT `fk_Bestellhistorie_Restaurant`
    FOREIGN KEY (`Restaurant`)
    REFERENCES `eatforspeed`.`Restaurant` (`Restaurant_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Bestellung`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Bestellung` (
  `Bestell_ID` INT NOT NULL AUTO_INCREMENT,
  `Bestellhistorien_ID` INT NOT NULL,
  `Auftrags_ID` INT NULL DEFAULT NULL,
  `Timestamp` DATETIME NOT NULL,
  `Rechnung` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Bestell_ID`),
  INDEX `fk_Bestellung_Auftrags_ID` (`Auftrags_ID` ASC),
  CONSTRAINT `fk_Bestellung_Auftrags_ID`
    FOREIGN KEY (`Auftrags_ID`)
    REFERENCES `eatforspeed`.`Auftrag` (`Auftrags_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Bestellzuordnung`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Bestellzuordnung` (
  `Bestell_ID` INT NOT NULL,
  `Gericht_ID` INT NOT NULL,
  PRIMARY KEY (`Bestell_ID`, `Gericht_ID`),
  INDEX `fk_Bestellzuordnung_Gericht_ID` (`Gericht_ID` ASC),
  CONSTRAINT `fk_Bestellzuordnung_Bestell_ID`
    FOREIGN KEY (`Bestell_ID`)
    REFERENCES `eatforspeed`.`Bestellung` (`Bestell_ID`),
  CONSTRAINT `fk_Bestellzuordnung_Gericht_ID`
    FOREIGN KEY (`Gericht_ID`)
    REFERENCES `eatforspeed`.`Gericht` (`Gericht_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Einnahmen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Einnahmen` (
  `Einnahmen_ID` INT NOT NULL AUTO_INCREMENT,
  `Restaurant_ID` INT NOT NULL,
  `Umsatz` DOUBLE(50,4) NOT NULL,
  `Monat` INT NOT NULL,
  `Jahr` INT NOT NULL,
  PRIMARY KEY (`Einnahmen_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Gericht_Allergene`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Gericht_Allergene` (
  `Gericht_ID` INT NOT NULL,
  `Allergen` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Gericht_ID`, `Allergen`),
  INDEX `fk_Allergene_Gericht_Allergene` (`Allergen` ASC),
  CONSTRAINT `fk_Allergene_Gericht_Allergene`
    FOREIGN KEY (`Allergen`)
    REFERENCES `eatforspeed`.`Allergene` (`Name`),
  CONSTRAINT `fk_Gericht_Gericht_Allergene`
    FOREIGN KEY (`Gericht_ID`)
    REFERENCES `eatforspeed`.`Gericht` (`Gericht_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `eatforspeed`.`Kategorie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Kategorie` (
  `Kategorie_ID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(20) NOT NULL,
  `Beschreibung` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`Kategorie_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Gericht_Kategorie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Gericht_Kategorie` (
  `Gericht_ID` INT NOT NULL,
  `Kategorie_ID` INT NOT NULL,
  PRIMARY KEY (`Gericht_ID`, `Kategorie_ID`),
  INDEX `fk_Kategorie_Gericht_Kategorie` (`Kategorie_ID` ASC),
  CONSTRAINT `fk_Gericht_Gericht_Kategorie`
    FOREIGN KEY (`Gericht_ID`)
    REFERENCES `eatforspeed`.`Gericht` (`Gericht_ID`),
  CONSTRAINT `fk_Kategorie_Gericht_Kategorie`
    FOREIGN KEY (`Kategorie_ID`)
    REFERENCES `eatforspeed`.`Kategorie` (`Kategorie_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Oeffnungszeiten`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Oeffnungszeiten` (
  `Oeffnungszeiten_ID` INT NOT NULL AUTO_INCREMENT,
  `Anfang` TIME NOT NULL,
  `Ende` TIME NOT NULL,
  `Wochentag` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Oeffnungszeiten_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Restaurant_Zeiten`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Restaurant_Zeiten` (
  `Restaurant_ID` INT NOT NULL,
  `Oeffnungszeiten_ID` INT NOT NULL,
  PRIMARY KEY (`Restaurant_ID`),
  INDEX `fk_Restaurant_Zeiten_Oeffnungszeiten_ID` (`Oeffnungszeiten_ID` ASC),
  CONSTRAINT `fk_Restaurant_Zeiten_Oeffnungszeiten_ID`
    FOREIGN KEY (`Oeffnungszeiten_ID`)
    REFERENCES `eatforspeed`.`Oeffnungszeiten` (`Oeffnungszeiten_ID`),
  CONSTRAINT `fk_Restaurant_Zeiten_Restaurant_ID`
    FOREIGN KEY (`Restaurant_ID`)
    REFERENCES `eatforspeed`.`Restaurant` (`Restaurant_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `eatforspeed`.`Urlaub`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eatforspeed`.`Urlaub` (
  `Urlaubs_ID` INT NOT NULL AUTO_INCREMENT,
  `Fahrernummer` INT NOT NULL,
  `Anfang` DATE NOT NULL,
  `Ende` DATE NOT NULL,
  PRIMARY KEY (`Urlaubs_ID`),
  INDEX `fk_Urlaub_Fahrernummer` (`Fahrernummer` ASC),
  CONSTRAINT `fk_Urlaub_Fahrernummer`
    FOREIGN KEY (`Fahrernummer`)
    REFERENCES `eatforspeed`.`Fahrer` (`Fahrernummer`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
