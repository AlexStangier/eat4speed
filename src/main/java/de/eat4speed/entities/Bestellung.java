package de.eat4speed.entities;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Objects;

@Entity
public class Bestellung extends PanacheEntityBase implements Serializable {

    public Bestellung(){}

    public Bestellung(int auftrags_ID, Timestamp timestamp, int rechnung) {
        this.auftrags_ID = auftrags_ID;
        this.timestamp = timestamp;
        this.rechnung = rechnung;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int bestell_ID;
    private int auftrags_ID;
    private Timestamp timestamp;
    private int rechnung;
    private String  Gericht_IDs;

    public int getBestell_ID() {
        return bestell_ID;
    }

    public void setBestell_ID(int bestellId) {
        this.bestell_ID = bestellId;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }


    public Integer getRechnung() {
        return rechnung;
    }

    public void setRechnung(Integer rechnung) {
        this.rechnung = rechnung;
    }

    public int getAuftrags_ID() {
        return auftrags_ID;
    }

    public void setAuftrags_ID(int auftrags_ID) {
        this.auftrags_ID = auftrags_ID;
    }

    public void setRechnung(int rechnung) {
        this.rechnung = rechnung;
    }

    public String getGericht_IDs() { return Gericht_IDs; }

    public void setGericht_IDs(String gericht_IDs) { Gericht_IDs = gericht_IDs; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Bestellung that = (Bestellung) o;
        return bestell_ID == that.bestell_ID && auftrags_ID == that.auftrags_ID && rechnung == that.rechnung && Objects.equals(timestamp, that.timestamp);
    }

    @Override
    public int hashCode() {
        return Objects.hash(bestell_ID, auftrags_ID, timestamp, rechnung);
    }

    @Override
    public String toString() {
        return "Bestellung{" +
                "bestell_ID=" + bestell_ID +
                ", auftrags_ID=" + auftrags_ID +
                ", timestamp=" + timestamp +
                ", rechnung=" + rechnung +
                '}';
    }
}
