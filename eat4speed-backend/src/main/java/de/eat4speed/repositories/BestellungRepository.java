package de.eat4speed.repositories;

import de.eat4speed.dto.UserEmailDto;
import de.eat4speed.entities.*;
import io.quarkus.hibernate.orm.panache.PanacheRepository;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.transaction.Transactional;
import java.util.List;

@ApplicationScoped
public class BestellungRepository implements PanacheRepository<Bestellung> {

    @Inject
    EntityManager entityManager;

    @Transactional
    public void addBestellung(Bestellung bestellung) {
        persist(bestellung);
    }

    @Transactional
    public Bestellung getBestellungByID(int id) {
        return find("Bestell_ID", id).firstResult();
    }

    @Transactional
    public Bestellung getBestellungByAuftragsId(int id) {
        return find("Auftrags_ID", id).firstResult();
    }

    @Transactional
    public List<Bestellung> getAllBestellungenByAuftragsId(long id) {
        List<Bestellung> result = find("Auftrags_ID", id).list();
        return result;
    }

    @Transactional
    public List getRestaurantBestellungen(String email) {
        List restaurantBestellungen;

        Query query = entityManager.createNativeQuery(
                "SELECT " +
                        "b.Bestell_ID, " +
                        "k.NAME, " +
                        "b.STATUS, " +
                        "r.Betrag " +
                        "FROM Auftrag a, Bestellung b, Rechnung r, Kunde k " +
                        "WHERE b.restaurant_ID = " +
                        "( SELECT Restaurant_ID FROM Restaurant " +
                        "WHERE Benutzer_ID = " +
                        "( SELECT Benutzer_ID FROM Benutzer " +
                        "WHERE EmailAdresse LIKE ?1 ) ) " +
                        "AND b.STATUS IN ( 'bezahlt', 'bearbeitung', 'abholbereit' ) " +
                        "AND b.Rechnung = r.Rechnungs_ID " +
                        "AND b.Gericht_IDs IS NOT NULL " +
                        "AND b.Auftrags_ID = a.Auftrags_ID " +
                        "AND a.Kundennummer = k.Kundennummer ").setParameter(1, email);
            restaurantBestellungen = query.getResultList();
            return restaurantBestellungen;
    }

    @Transactional
    public void updateBestellungStatus(Bestellung bestellung) {
        update("status = ?1 where bestell_ID = ?2", bestellung.getStatus(), bestellung.getBestell_ID());
    }


}
