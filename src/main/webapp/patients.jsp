<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste des patients</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; color: #222; }
        h1 { color: #0b6e4f; }
        table { border-collapse: collapse; width: 100%; max-width: 1100px; }
        th, td { border: 1px solid #ccc; padding: 8px 10px; text-align: left; }
        th { background: #0b6e4f; color: #fff; }
        tr:nth-child(even) { background: #f4f8f6; }
        .erreur { color: #b00020; font-weight: bold; }
        .statut { color: #555; margin: 12px 0; }
        .vide { color: #666; font-style: italic; }
        a { color: #0b6e4f; }
        button {
            background: #0b6e4f; color: #fff; border: 0; padding: 8px 14px;
            cursor: pointer; border-radius: 4px;
        }
        button:hover { background: #09543d; }
    </style>
</head>
<body>

<h1>Liste des patients</h1>

<p><a href="index.jsp">&larr; Retour aux tests</a></p>

<button type="button" id="recharger">Recharger</button>
<p class="statut" id="statut">Chargement en cours...</p>

<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Matricule</th>
        <th>Nom</th>
        <th>Prenom</th>
        <th>Sexe</th>
        <th>Date de naissance</th>
        <th>Telephone</th>
        <th>Email</th>
        <th>Ville</th>
    </tr>
    </thead>
    <tbody id="corps-tableau">
    </tbody>
</table>

<script>
    const API_URL = 'http://localhost:8080/patient/api-patients';
    const statut = document.getElementById('statut');
    const corps = document.getElementById('corps-tableau');

    document.addEventListener('DOMContentLoaded', chargerPatients);
    document.getElementById('recharger').addEventListener('click', chargerPatients);

    function cellule(ligne, valeur) {
        const td = document.createElement('td');
        td.textContent = (valeur === null || valeur === undefined) ? '' : valeur;
        ligne.appendChild(td);
    }

    async function chargerPatients() {
        statut.className = 'statut';
        statut.textContent = 'Chargement en cours...';
        corps.innerHTML = '';

        try {
            const reponse = await fetch(API_URL, { headers: { 'Accept': 'application/json' } });
            if (!reponse.ok) {
                throw new Error('Erreur HTTP ' + reponse.status);
            }

            const donnees = await reponse.json();
            if (donnees.erreur) {
                throw new Error(donnees.erreur);
            }

            const patients = donnees.patients || [];

            if (patients.length === 0) {
                const ligne = document.createElement('tr');
                const td = document.createElement('td');
                td.colSpan = 9;
                td.className = 'vide';
                td.textContent = 'Aucun patient a afficher.';
                ligne.appendChild(td);
                corps.appendChild(ligne);
            } else {
                patients.forEach(function(p) {
                    const ligne = document.createElement('tr');
                    // JsonUtil ecrit les dates au format "yyyy-MM-dd'T'HH:mm:ss"
                    const dateNaissance = p.dateDeNaissance
                        ? String(p.dateDeNaissance).split('T')[0] : '';
                    cellule(ligne, p.id);
                    cellule(ligne, p.matricule);
                    cellule(ligne, p.nom);
                    cellule(ligne, p.prenom);
                    cellule(ligne, p.sexe);
                    cellule(ligne, dateNaissance);
                    cellule(ligne, p.telephone);
                    cellule(ligne, p.email);
                    cellule(ligne, p.ville);
                    corps.appendChild(ligne);
                });
            }

            statut.textContent = (donnees.total !== undefined ? donnees.total : patients.length)
                + ' patient(s) trouve(s).';
        } catch (e) {
            statut.className = 'erreur';
            statut.textContent = 'Erreur : ' + e.message;
        }
    }
</script>

</body>
</html>
