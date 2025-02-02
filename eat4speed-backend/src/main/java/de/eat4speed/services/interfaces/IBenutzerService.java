package de.eat4speed.services.interfaces;

import de.eat4speed.dto.BenutzerDto;
import de.eat4speed.dto.UserEmailDto;
import de.eat4speed.entities.Benutzer;
import de.eat4speed.entities.Favoritenliste_Restaurants;

import javax.ws.rs.core.Response;
import java.util.List;

public interface IBenutzerService {

    Response addBenutzer(BenutzerDto obj);

    String listAll();

    /**
     * Comapares a given user with existing users in the database
     *
     * @param requestedUser
     * @param type u = user r = restaurant a = admin d = driver
     * @return Benutzer if exists
     */
    Response checkCredentials(Benutzer requestedUser, char type);

    Integer getEmailById(UserEmailDto email);

    List getBenutzerByLogin(String email);

    Response updateBenutzerRestaurant(Benutzer benutzer);

    List getBenutzerKundeEinstellungenByLogin(String email);

    List getKundennummerByBenutzername(String username);

    List getRestaurant_IDByBenutzername(String username);

    String getRoleById(long id);
}