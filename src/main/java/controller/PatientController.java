package controller;

import annotation.Controller;
import annotation.RestApi;
import annotation.Url;
import model.Patient;
import service.PatientService;
import util.ModelAndView;

import java.util.ArrayList;
import java.util.List;

@Controller
public class PatientController {

    private final PatientService patientService = new PatientService();

    /**
     * Page HTML : elle ne contient pas de donnees, le tableau est rempli
     * cote client par un appel AJAX vers /api-patients.
     * URL : /patients
     */
    @Url(url = "/patients")
    public ModelAndView afficher() {
        return new ModelAndView("/patients.jsp");
    }

    @RestApi
    @Url(url = "/api-patients")
    public ModelAndView getAll() {
        ModelAndView mv = new ModelAndView("ignored.jsp");
        try {
            List<Patient> patients = patientService.getAll();
            mv.setAttribute("patients", patients);
            mv.setAttribute("total", patients.size());
        } catch (Exception e) {
            e.printStackTrace();
            mv.setAttribute("erreur", "Impossible de charger les patients : " + e.getMessage());
            mv.setAttribute("patients", new ArrayList<Patient>());
            mv.setAttribute("total", 0);
        }
        return mv;
    }
}
