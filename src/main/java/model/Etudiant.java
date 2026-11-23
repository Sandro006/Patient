package model;

import annotation.DateFormat;
import annotation.FieldAnnotation;
import annotation.Numeric;
import annotation.Range;
import annotation.Required;

public class Etudiant {

    @Required(message = "Le nom est obligatoire")
    private String nom;

    @Numeric(message = "L'age doit etre numerique")
    @Range(
        min = 18,
        max = 100,
        message = "L'age doit etre entre 18 et 100"
    )
    private int age;

    @DateFormat(
        format = "dd/MM/yyyy",
        message = "Date invalide (jj/mm/aaaa attendu)"
    )
    private String dateNaissance;

    @FieldAnnotation(name = "mail")
    @Required(message = "L'email est obligatoire")
    private String email;

    public Etudiant() {
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(String dateNaissance) {
        this.dateNaissance = dateNaissance;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
