# Projet de test du FrontController

## 1\. Configuration

Place ce projet dans ton projet Jakarta Servlet existant.

Le dossier `src/main/java` contient les contrôleurs et modèles de test.  
Le dossier `src/main/webapp` contient les JSP/formulaires.

## 2\. package-to-scan

Dans `WEB-INF/web.xml`, vérifie que tu as :

```xml
<context-param>
    <param-name>package-to-scan</param-name>
    <param-value>controller</param-value>
</context-param>
```

Le `ControllerScan` cherchera les classes annotées `@Controller` dans le package `controller`.

## 3\. Tests

Après déploiement :

*   `/hello` : test URL simple
*   `/bonjour` : deuxième URL simple
*   `/salut?nom=Loyard` : test `@Param`
*   `/calcul?a=10&b=20` : conversion String -> int
*   `/personne.html` : formulaire POST vers `/personne`
*   `/session` : test `CustomSession`
*   `/admin` : test `@Authentification`

## 4\. Attention

Ton `ControllerScan` actuel utilise l'URL seule comme clé dans `Map<String, Mapping>`.  
Donc tu ne peux pas actuellement déclarer simultanément :

```
GET  /form
POST /form
```

avec deux méthodes différentes.

Le test POST utilise donc `/personne`.

## 5\. Lancer

Avec Tomcat :

1.  Compile/déploie le projet.
2.  Démarre Tomcat.
3.  Ouvre par exemple :  
    `http://localhost:8080/NOM_DU_PROJET/hello`

Adapte `NOM_DU_PROJET` au nom réel de ton application.