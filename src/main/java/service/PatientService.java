package service;

import model.Patient;
import util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Couche service : contient toute la logique d'acces a la table PATIENT.
 * Le controleur ne connait que cette classe, pas le JDBC.
 */
public class PatientService {

    private static final String SQL_GET_ALL =
            "SELECT ID, MATRICULE, NOM, PRENOM, SEXE, DATE_DE_NAISSANCE, "
            + "TELEPHONE, EMAIL, ADRESSE, VILLE "
            + "FROM PATIENT ORDER BY NOM, PRENOM";

    /** @return tous les patients, ou une liste vide si la table est vide */
    public List<Patient> getAll() throws Exception {
        List<Patient> patients = new ArrayList<>();

        try (Connection connexion = DBUtil.getConnection();
             PreparedStatement statement = connexion.prepareStatement(SQL_GET_ALL);
             ResultSet resultat = statement.executeQuery()) {

            while (resultat.next()) {
                patients.add(map(resultat));
            }
        }
        return patients;
    }

    private Patient map(ResultSet resultat) throws Exception {
        Patient patient = new Patient();
        patient.setId(resultat.getInt("ID"));
        patient.setMatricule(resultat.getString("MATRICULE"));
        patient.setNom(resultat.getString("NOM"));
        patient.setPrenom(resultat.getString("PRENOM"));
        patient.setSexe(resultat.getString("SEXE"));
        patient.setDateDeNaissance(resultat.getDate("DATE_DE_NAISSANCE"));
        patient.setTelephone(resultat.getString("TELEPHONE"));
        patient.setEmail(resultat.getString("EMAIL"));
        patient.setAdresse(resultat.getString("ADRESSE"));
        patient.setVille(resultat.getString("VILLE"));
        return patient;
    }
}
