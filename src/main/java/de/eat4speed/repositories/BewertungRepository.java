package de.eat4speed.repositories;

import de.eat4speed.entities.Bewertung;
import io.quarkus.hibernate.orm.panache.PanacheRepository;

import javax.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class BewertungRepository implements PanacheRepository<Bewertung> {

}
