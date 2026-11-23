-- =============================================================
-- Base de donnees : extra_patient
-- Modele relationnel : un patient + ses informations medicales
-- Moteur : MySQL / MariaDB  (InnoDB pour les cles etrangeres)
-- =============================================================

DROP DATABASE IF EXISTS extra_patient;
CREATE DATABASE extra_patient
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE extra_patient;

-- -------------------------------------------------------------
-- Suppression des tables (enfants d'abord pour respecter les FK)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS VACCINATION;
DROP TABLE IF EXISTS EXAMEN;
DROP TABLE IF EXISTS ORDONNANCE;
DROP TABLE IF EXISTS CONSTANTE;
DROP TABLE IF EXISTS CONSULTATION;
DROP TABLE IF EXISTS HOSPITALISATION;
DROP TABLE IF EXISTS ALLERGIE;
DROP TABLE IF EXISTS ANTICEDENT;
DROP TABLE IF EXISTS DOSSIER_MEDICAL;
DROP TABLE IF EXISTS CONTACT_URGENCE;
DROP TABLE IF EXISTS MEDECIN;
DROP TABLE IF EXISTS PATIENT;

-- =============================================================
-- 1. PATIENT : identite et coordonnees du patient
-- =============================================================
CREATE TABLE PATIENT (
    ID                  INT AUTO_INCREMENT PRIMARY KEY,
    MATRICULE           VARCHAR(20)  NOT NULL UNIQUE,
    NOM                 VARCHAR(100) NOT NULL,
    PRENOM              VARCHAR(100) NOT NULL,
    SEXE                ENUM('M', 'F', 'AUTRE') NOT NULL,
    DATE_DE_NAISSANCE   DATE         NOT NULL,
    LIEU_DE_NAISSANCE   VARCHAR(100),
    TELEPHONE           VARCHAR(20),
    EMAIL               VARCHAR(150),
    ADRESSE             VARCHAR(255),
    VILLE               VARCHAR(100),
    DATE_CREATION       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;

-- =============================================================
-- 2. CONTACT_URGENCE : personne a prevenir en cas d'urgence
--    Relation : 1 patient -> N contacts
-- =============================================================
CREATE TABLE CONTACT_URGENCE (
    ID          INT AUTO_INCREMENT PRIMARY KEY,
    PATIENT_ID  INT          NOT NULL,
    NOM         VARCHAR(100) NOT NULL,
    PRENOM      VARCHAR(100) NOT NULL,
    LIEN        VARCHAR(50)  NOT NULL COMMENT 'ex : mere, pere, conjoint, ami',
    TELEPHONE   VARCHAR(20)  NOT NULL,
    CONSTRAINT FK_CONTACT_PATIENT FOREIGN KEY (PATIENT_ID)
        REFERENCES PATIENT(ID) ON DELETE CASCADE
) ENGINE = InnoDB;

-- =============================================================
-- 3. MEDECIN : praticien qui suit le patient
-- =============================================================
CREATE TABLE MEDECIN (
    ID          INT AUTO_INCREMENT PRIMARY KEY,
    NOM         VARCHAR(100) NOT NULL,
    PRENOM      VARCHAR(100) NOT NULL,
    SPECIALITE  VARCHAR(100) NOT NULL,
    TELEPHONE   VARCHAR(20),
    EMAIL       VARCHAR(150)
) ENGINE = InnoDB;

-- =============================================================
-- 4. DOSSIER_MEDICAL : donnees medicales propres au patient (1-1)
-- =============================================================
CREATE TABLE DOSSIER_MEDICAL (
    ID                  INT AUTO_INCREMENT PRIMARY KEY,
    PATIENT_ID          INT          NOT NULL UNIQUE,
    GROUPE_SANGUIN      ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    TAILLE_CM           DECIMAL(5,2),
    POIDS_KG            DECIMAL(5,2),
    TABAC               BOOLEAN      NOT NULL DEFAULT FALSE,
    ALCOOL              BOOLEAN      NOT NULL DEFAULT FALSE,
    MEDECIN_TRAITANT_ID INT,
    DATE_MAJ            TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT FK_DOSSIER_PATIENT FOREIGN KEY (PATIENT_ID)
        REFERENCES PATIENT(ID) ON DELETE CASCADE,
    CONSTRAINT FK_DOSSIER_MEDECIN FOREIGN KEY (MEDECIN_TRAITANT_ID)
        REFERENCES MEDECIN(ID) ON DELETE SET NULL
) ENGINE = InnoDB;

-- =============================================================
-- 5. ANTICEDENT : maladies / antecedents du patient (1 -> N)
-- =============================================================
CREATE TABLE ANTICEDENT (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    PATIENT_ID      INT          NOT NULL,
    TYPE            VARCHAR(100) NOT NULL COMMENT 'ex : maladie chronique, chirurgie, fracture',
    DESIGNATION     VARCHAR(255) NOT NULL,
    DATE_DEBUT      DATE,
    EN_COURS        BOOLEAN      NOT NULL DEFAULT TRUE,
    COMMENTAIRE     TEXT,
    CONSTRAINT FK_ANT_PATIENT FOREIGN KEY (PATIENT_ID)
        REFERENCES PATIENT(ID) ON DELETE CASCADE
) ENGINE = InnoDB;

-- =============================================================
-- 6. ALLERGIE : allergies du patient (1 -> N)
-- =============================================================
CREATE TABLE ALLERGIE (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    PATIENT_ID      INT          NOT NULL,
    SUBSTANCE       VARCHAR(150) NOT NULL COMMENT 'ex : penicilline, arachide, pollen',
    SEVERITE        ENUM('FAIBLE', 'MODEREE', 'SEVERE') NOT NULL,
    REACTION        VARCHAR(255),
    CONSTRAINT FK_ALL_PATIENT FOREIGN KEY (PATIENT_ID)
        REFERENCES PATIENT(ID) ON DELETE CASCADE
) ENGINE = InnoDB;

-- =============================================================
-- 7. HOSPITALISATION : sejours a l'hopital (1 -> N)
-- =============================================================
CREATE TABLE HOSPITALISATION (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    PATIENT_ID      INT          NOT NULL,
    DATE_ENTREE     DATETIME     NOT NULL,
    DATE_SORTIE     DATETIME,
    SERVICE         VARCHAR(100) NOT NULL,
    MOTIF           VARCHAR(255) NOT NULL,
    CONSTRAINT FK_HOSP_PATIENT FOREIGN KEY (PATIENT_ID)
        REFERENCES PATIENT(ID) ON DELETE CASCADE
) ENGINE = InnoDB;

-- =============================================================
-- 8. CONSULTATION : visites chez le medecin (1 -> N)
-- =============================================================
CREATE TABLE CONSULTATION (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    PATIENT_ID      INT          NOT NULL,
    MEDECIN_ID      INT          NOT NULL,
    DATE_CONSULT    DATETIME     NOT NULL,
    MOTIF           VARCHAR(255) NOT NULL,
    DIAGNOSTIC      TEXT,
    COMMENTAIRE     TEXT,
    CONSTRAINT FK_CONS_PATIENT FOREIGN KEY (PATIENT_ID)
        REFERENCES PATIENT(ID) ON DELETE CASCADE,
    CONSTRAINT FK_CONS_MEDECIN FOREIGN KEY (MEDECIN_ID)
        REFERENCES MEDECIN(ID) ON DELETE RESTRICT
) ENGINE = InnoDB;

-- =============================================================
-- 9. CONSTANTE : mesures prises lors d'une consultation
-- =============================================================
CREATE TABLE CONSTANTE (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    CONSULTATION_ID INT          NOT NULL,
    TAILLE_CM       DECIMAL(5,2),
    POIDS_KG        DECIMAL(5,2),
    TEMPERATURE_C   DECIMAL(4,2),
    TENSION_SYSTOLE INT,
    TENSION_DIASTOLE INT,
    POULS           INT,
    CONSTRAINT FK_CONST_CONS FOREIGN KEY (CONSULTATION_ID)
        REFERENCES CONSULTATION(ID) ON DELETE CASCADE
) ENGINE = InnoDB;

-- =============================================================
-- 10. ORDONNANCE : medicaments prescrits lors d'une consultation
-- =============================================================
CREATE TABLE ORDONNANCE (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    CONSULTATION_ID INT          NOT NULL,
    MEDICAMENT      VARCHAR(150) NOT NULL,
    POSOLOGIE       VARCHAR(150) NOT NULL COMMENT 'ex : 1 comprime 3 fois/jour',
    DUREE_JOURS     INT,
    COMMENTAIRE     TEXT,
    CONSTRAINT FK_ORD_CONS FOREIGN KEY (CONSULTATION_ID)
        REFERENCES CONSULTATION(ID) ON DELETE CASCADE
) ENGINE = InnoDB;

-- =============================================================
-- 11. EXAMEN : analyses / examens realisees (1 -> N)
-- =============================================================
CREATE TABLE EXAMEN (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    CONSULTATION_ID INT,
    PATIENT_ID      INT          NOT NULL,
    TYPE_EXAMEN     VARCHAR(150) NOT NULL COMMENT 'ex : prise de sang, radio, echographie',
    DATE_EXAMEN     DATETIME     NOT NULL,
    RESULTAT        TEXT,
    COMMENTAIRE     TEXT,
    CONSTRAINT FK_EXAM_CONS FOREIGN KEY (CONSULTATION_ID)
        REFERENCES CONSULTATION(ID) ON DELETE SET NULL,
    CONSTRAINT FK_EXAM_PATIENT FOREIGN KEY (PATIENT_ID)
        REFERENCES PATIENT(ID) ON DELETE CASCADE
) ENGINE = InnoDB;

-- =============================================================
-- 12. VACCINATION : carnet de vaccination (1 -> N)
-- =============================================================
CREATE TABLE VACCINATION (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    PATIENT_ID      INT          NOT NULL,
    NOM_VACCIN      VARCHAR(150) NOT NULL,
    DATE_VACCINATION DATE        NOT NULL,
    RAPPEL_PREVU    DATE,
    COMMENTAIRE     TEXT,
    CONSTRAINT FK_VACC_PATIENT FOREIGN KEY (PATIENT_ID)
        REFERENCES PATIENT(ID) ON DELETE CASCADE
) ENGINE = InnoDB;

-- =============================================================
-- DONNEES DE TEST : un patient complet
-- =============================================================

INSERT INTO PATIENT (MATRICULE, NOM, PRENOM, SEXE, DATE_DE_NAISSANCE, TELEPHONE, EMAIL, ADRESSE, VILLE)
VALUES ('PAT-2026-001', 'Rakoto', 'Loyard', 'M', '1990-05-14', '0321234567', 'loyard.rakoto@email.mg', '12 rue des Lilas', 'Antananarivo');

INSERT INTO CONTACT_URGENCE (PATIENT_ID, NOM, PRENOM, LIEN, TELEPHONE)
VALUES (1, 'Rakoto', 'Mama', 'mere', '0339876543');

INSERT INTO MEDECIN (NOM, PRENOM, SPECIALITE, TELEPHONE, EMAIL)
VALUES ('Andriana', 'Hery', 'Medecin generaliste', '0321112233', 'hery.andriana@clinic.mg');

INSERT INTO DOSSIER_MEDICAL (PATIENT_ID, GROUPE_SANGUIN, TAILLE_CM, POIDS_KG, TABAC, ALCOOL, MEDECIN_TRAITANT_ID)
VALUES (1, 'O+', 172.50, 68.00, FALSE, FALSE, 1);

INSERT INTO ANTICEDENT (PATIENT_ID, TYPE, DESIGNATION, DATE_DEBUT, EN_COURS, COMMENTAIRE)
VALUES
    (1, 'Maladie chronique', 'Hypertension arterielle', '2018-03-10', TRUE, 'Traitee par medicaments'),
    (1, 'Chirurgie', 'Appendicectomie', '2005-07-22', FALSE, 'Sans complication');

INSERT INTO ALLERGIE (PATIENT_ID, SUBSTANCE, SEVERITE, REACTION)
VALUES
    (1, 'Penicilline', 'SEVERE', 'Eruption cutanee et gonflement'),
    (1, 'Arachide', 'MODEREE', 'Demangeaisons');

INSERT INTO HOSPITALISATION (PATIENT_ID, DATE_ENTREE, DATE_SORTIE, SERVICE, MOTIF)
VALUES (1, '2024-02-10 08:30:00', '2024-02-13 14:00:00', 'Cardiologie', 'Crise hypertensive');

INSERT INTO CONSULTATION (PATIENT_ID, MEDECIN_ID, DATE_CONSULT, MOTIF, DIAGNOSTIC, COMMENTAIRE)
VALUES (1, 1, '2026-10-12 09:15:00', 'Controle tension', 'Hypertension stable', 'Renouvellement ordonnance');

INSERT INTO CONSTANTE (CONSULTATION_ID, TAILLE_CM, POIDS_KG, TEMPERATURE_C, TENSION_SYSTOLE, TENSION_DIASTOLE, POULS)
VALUES (1, 172.50, 68.20, 36.80, 128, 82, 74);

INSERT INTO ORDONNANCE (CONSULTATION_ID, MEDICAMENT, POSOLOGIE, DUREE_JOURS, COMMENTAIRE)
VALUES
    (1, 'Amlodipine 5 mg', '1 comprime le matin', 30, 'A prendre avec un verre d eau'),
    (1, 'Paracetamol 500 mg', '1 comprime si besoin', 10, 'Pas plus de 3 par jour');

INSERT INTO EXAMEN (CONSULTATION_ID, PATIENT_ID, TYPE_EXAMEN, DATE_EXAMEN, RESULTAT, COMMENTAIRE)
VALUES (1, 1, 'Prise de sang (bilan lipide)', '2026-10-12 10:00:00', 'Cholesterol normal', 'A jeun');

INSERT INTO VACCINATION (PATIENT_ID, NOM_VACCIN, DATE_VACCINATION, RAPPEL_PREVU, COMMENTAIRE)
VALUES
    (1, 'Grippe saisonniere', '2025-10-05', '2026-10-05', 'Rappel annuel'),
    (1, 'Covid-19 (dose de rappel)', '2025-03-18', NULL, 'Troisieme dose');

-- =============================================================
-- FIN DU SCRIPT
-- =============================================================
