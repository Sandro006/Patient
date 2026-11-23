
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
