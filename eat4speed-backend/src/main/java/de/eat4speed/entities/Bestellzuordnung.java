package de.eat4speed.entities;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;

import javax.persistence.*;
import java.io.Serializable;

@Entity
public class Bestellzuordnung extends PanacheEntityBase implements Serializable {

    public Bestellzuordnung(){}

    public Bestellzuordnung(int bestell_ID, int gericht_ID, int anzahl) {
        this.bestell_ID = bestell_ID;
        this.gericht_ID = gericht_ID;
        this.anzahl = anzahl;
    }

    @Id
    private int bestell_ID;
    @Id
    private int gericht_ID;

    private int anzahl;

    public int getBestell_ID() {
        return bestell_ID;
    }

    public void setBestell_ID(int bestell_ID) {
        this.bestell_ID = bestell_ID;
    }

    public int getGericht_ID() {
        return gericht_ID;
    }

    public void setGericht_ID(int gericht_ID) {
        this.gericht_ID = gericht_ID;
    }

    public int getAnzahl() {
        return anzahl;
    }

    public void setAnzahl(int anzahl) {
        this.anzahl = anzahl;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Bestellzuordnung that = (Bestellzuordnung) o;

        if (bestell_ID != that.bestell_ID) return false;
        if (gericht_ID != that.gericht_ID) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = bestell_ID;
        result = 31 * result + gericht_ID;
        return result;
    }

    @Override
    public String toString() {
        return "Bestellzuordnung{" +
                "bestell_ID=" + bestell_ID +
                ", gericht_ID=" + gericht_ID +
                '}';
    }
}
