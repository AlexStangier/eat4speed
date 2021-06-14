package de.eat4speed.services;

import de.eat4speed.dto.OrderDto;
import de.eat4speed.dto.PaymentDto;
import de.eat4speed.entities.*;
import de.eat4speed.repositories.*;
import de.eat4speed.services.interfaces.IBestellungService;
import io.vertx.core.json.Json;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.transaction.Transactional;
import javax.ws.rs.core.Response;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.*;

@ApplicationScoped
public class BestellungService implements IBestellungService {

    private BestellungRepository _bestellungRepository;
    private RechnungRepository _rechnungRepository;
    private AuftragRepository _auftragRepository;
    private StatusRepository _statusRepository;
    private BestellzuordnungRepository _bestellzuordnungRepository;
    private GerichtRepository _gerichtRepository;
    private BenutzerRepository _benutzerRepository;
    private AdressenRepository _adressenRepository;
    private KundeRepository _kundeRepository;
    private RestaurantRepository _restaurantRepository;

    @Inject
    public BestellungService(BestellungRepository bestellungRepository,
                             RechnungRepository rechnungRepository,
                             AuftragRepository auftragRepository,
                             StatusRepository statusRepository,
                             BestellzuordnungRepository bestellzuordnungRepository,
                             GerichtRepository gerichtRepository,
                             BenutzerRepository benutzerRepository,
                             AdressenRepository adressenRepository,
                             KundeRepository kundeRepository,
                             RestaurantRepository restaurantRepository
    ) {
        _bestellungRepository = bestellungRepository;
        _rechnungRepository = rechnungRepository;
        _auftragRepository = auftragRepository;
        _statusRepository = statusRepository;
        _bestellzuordnungRepository = bestellzuordnungRepository;
        _gerichtRepository = gerichtRepository;
        _benutzerRepository = benutzerRepository;
        _adressenRepository = adressenRepository;
        _kundeRepository = kundeRepository;
        _restaurantRepository = restaurantRepository;
    }

    public static float round(float d, int decimalPlace) {
        BigDecimal bd = new BigDecimal(Float.toString(d));
        bd = bd.setScale(decimalPlace, BigDecimal.ROUND_HALF_UP);
        return bd.floatValue();
    }

    @Override
    public Response addBestellung(Bestellung bestellung) {
        _bestellungRepository.addBestellung(bestellung);

        return Response.status(Response.Status.CREATED).entity(bestellung).build();
    }

    /**
     * Creates and persists an order with all attached items
     *
     * @param obj Dto containing a list of items and an customer identifier
     * @return HTTP Response
     */
    @Override
    @Transactional
    public Response createBestellung(OrderDto obj) throws SQLException {
        ArrayList<Gericht> safeItems = new ArrayList<>();
        ArrayList<Integer> gerichtIDs = new ArrayList<>();
        HashSet<Restaurant> restaurants = new HashSet<>();
        Benutzer benutzer = null;
        Kunde kunde = null;
        Date date = new Date();

        try {
            //get items by id¡
            for (int item : obj.items) {
                //make sure items are valid and not tempered
                Gericht gericht = _gerichtRepository.getGerichtByGerichtID(item);
                safeItems.add(gericht);
                gerichtIDs.add(item);
                restaurants.add(_restaurantRepository.findByRestaurantnummer(gericht.getRestaurant_ID()));
            }

            //get customer by id
            benutzer = _benutzerRepository.getBenutzerByID(obj.getCustomerId());
        } catch (Exception e) {
            System.out.println("Failed while creating order:" + e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(e).build();
        }

        kunde = _kundeRepository.getKundeByBenutzerID(benutzer.getBenutzer_ID());

        if (!safeItems.isEmpty() && benutzer != null) {
            //create new rechnung
            Rechnung rechnung = null;
            Adressen adresse = null;
            Auftrag auftrag = null;
            Bestellung bestellung = null;
            HashMap<Integer, List<Gericht>> restaurantOrderMapper = new HashMap<>();

            try {
                auftrag = new Auftrag(safeItems.get(0).getRestaurant_ID(), new Timestamp(date.getTime()), kunde.getAnschrift(), 0.0, kunde.getKundennummer(), "offen", 0);
            } catch (Exception e) {
                System.out.println("Failed while creating auftrag:" + e);
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(e).build();
            }
            _auftragRepository.persist(auftrag);

            if (_auftragRepository.isPersistent(auftrag)) {
                try {
                    for (Restaurant rest : restaurants) {
                        List<Gericht> gerichteForRestaurant = new ArrayList<>();
                        for (Gericht ger : safeItems) {
                            if (ger.getRestaurant_ID() == rest.getRestaurant_ID())
                                gerichteForRestaurant.add(ger);
                        }
                        restaurantOrderMapper.put(rest.getRestaurant_ID(), gerichteForRestaurant);
                        try {
                            float sum = (float) gerichteForRestaurant.stream().mapToDouble(Gericht::getPreis).sum();
                            sum = round(sum, 2);
                            sum *= 1.07;
                            sum += 2;

                            rechnung = new Rechnung(sum, new Timestamp(date.getTime()), (byte) 0);
                        } catch (Exception e) {
                            System.out.println("Failed while creating rechnung:" + e);
                            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(e).build();
                        }
                        _rechnungRepository.persist(rechnung);

                        bestellung = new Bestellung((int) auftrag.getAuftrags_ID(), new Timestamp(date.getTime()), rechnung.getRechnungs_ID());

                        List<Integer> relevantGerichte = new ArrayList<>();
                        for (Gericht ger : restaurantOrderMapper.get(rest.getRestaurant_ID())) {
                            relevantGerichte.add(ger.getGericht_ID());
                        }

                        bestellung.setGericht_IDs(Json.encode(relevantGerichte));
                        _bestellungRepository.persist(bestellung);
                    }
                } catch (Exception e) {
                    System.out.println("Failed while creating bestellung:" + e);
                    return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(e).build();
                }

                if (_bestellungRepository.isPersistent(bestellung)) {

                    for (Restaurant rest : restaurants) {
                        Map<Integer, Integer> amountMap = new HashMap<Integer, Integer>();
                        for (Gericht gericht : restaurantOrderMapper.get(rest.getRestaurant_ID())) {
                            if (amountMap.containsKey(gericht.getGericht_ID())) {
                                int currVal = amountMap.get(gericht.getGericht_ID());
                                amountMap.replace(gericht.getGericht_ID(), currVal + 1);
                            } else amountMap.put(gericht.getGericht_ID(), 1);

                        }
                        for (Map.Entry<Integer, Integer> entry : amountMap.entrySet()) {
                            try {
                                _bestellzuordnungRepository.addBestellzuordnung(new Bestellzuordnung(bestellung.getBestell_ID(), entry.getKey(), entry.getValue()));
                            } catch (Exception e) {
                                System.out.println("Something went wrong persisting bestellzuordnung: " + e);
                            }
                        }
                    }
                }
            }
            return Response.status(Response.Status.CREATED).entity(auftrag).build();
        }
        return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(null).build();
    }

    /**
     * Updates Auftragsstatus to 'bezahlt'
     *
     * @param AuftragsId auftrag to be updated
     * @return success or error
     */
    @Override
    @Transactional
    public PaymentDto payForOrder(Integer AuftragsId) throws SQLException {
        Double total = 0.0;
        Date date = new Date();
        try {
            Auftrag auftrag = _auftragRepository.getAuftragByID(AuftragsId);
            auftrag.setStatus("bezahlt");
            List<Bestellung> bestellungen = _bestellungRepository.getAllBestellungenByAuftragsId(auftrag.getAuftrags_ID());
            _auftragRepository.persist(auftrag);

            for (Bestellung best : bestellungen) {
                Rechnung rechnung = _rechnungRepository.getRechnungByID(best.getRechnung());
                rechnung.setZahlungseingang((byte) 1);
                rechnung.setDatum_Zahlungseingang(new Timestamp(date.getTime()));
                total += rechnung.getBetrag();
                _rechnungRepository.persist(rechnung);
            }
        } catch (Exception e) {
            System.out.println(e);
            return new PaymentDto(total, "error");
        }
        return new PaymentDto(total, "success");
    }

    @Override
    public List getRestaurantBestellungen(String email) {return _bestellungRepository.getRestaurantBestellungen(email);}

    @Override
    public Response updateBestellungStatus(Bestellung bestellung) {
        _bestellungRepository.updateBestellungStatus(bestellung);
        return Response.status(Response.Status.OK).entity(bestellung).build();
    }

    @Override
    public List getProdutAndAnzahl(int id) {return _bestellungRepository.getProdutAndAnzahl(id);}
}
