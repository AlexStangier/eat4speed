package de.eat4speed.services.interfaces;

import de.eat4speed.entities.Fahrer;
import de.eat4speed.entities.Fahrzeug;

import javax.ws.rs.PathParam;
import javax.ws.rs.core.Response;
import java.util.List;

public interface IFahrerService {

    Response addFahrer(Fahrer obj);

    Response setPause(int pause, int fahrernummer);

    Object getAmountInPause();

    List getFahrerByID(int id);

    List<String> getAllFahrer();

    List<String> getNotVerifiedFahrer();

    List<String> getVerifiedFahrer();

    Response updateFahrer_Fahrzeug_Id(int id, Fahrzeug fahrzeug);

    Response updateFahrer_Verifiziert(int id);

    Response deleteFahrer(int id);

    Response updateFahrer_anzahl_aktueller_Auftraege(int fahrernummer, int anzahl);

    List get_Fahrer_Fzg_Pos();

    List get_Restaurant_Lng_Lat();

    List get_Kunde_Lng_Lat();
}
