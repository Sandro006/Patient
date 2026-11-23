package model;

import annotation.Required;
import annotation.Numeric;
import annotation.Range;

public class Personne {

    @Required(message = "Le nom est obligatoire")
    private String nom;

    @Range(
        min = 18,
        max = 100,
        message = "L'âge doit être entre 18 et 100"
    )
    private int age;

    @Required(message = "L'email est obligatoire")
    private String email;

    public Personne() {
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
