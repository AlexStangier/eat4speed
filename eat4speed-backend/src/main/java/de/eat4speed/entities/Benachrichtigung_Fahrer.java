package de.eat4speed.entities;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Objects;

@Entity
public class Benachrichtigung_Fahrer extends PanacheEntityBase implements Serializable {

    public Benachrichtigung_Fahrer(){}

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int benachrichtigungs_ID;
    private int fahrernummer;
    private String benachrichtigung;
    private int restaurant_ID;
    private Timestamp timestamp;
    private byte gelesen;

    public int getBenachrichtigungs_ID() {
        return benachrichtigungs_ID;
    }

    public void setBenachrichtigungs_ID(int benachrichtigungs_ID) {
        this.benachrichtigungs_ID = benachrichtigungs_ID;
    }

    public int getFahrernummer() {
        return fahrernummer;
    }

    public void setFahrernummer(int fahrernummer) {
        this.fahrernummer = fahrernummer;
    }

    public String getBenachrichtigung() {
        return benachrichtigung;
    }

    public void setBenachrichtigung(String benachrichtigung) {
        this.benachrichtigung = benachrichtigung;
    }

    public int getRestaurant_ID() {
        return restaurant_ID;
    }

    public void setRestaurant_ID(int restaurant_ID) {
        this.restaurant_ID = restaurant_ID;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public byte getGelesen() {
        return gelesen;
    }

    public void setGelesen(byte gelesen) {
        this.gelesen = gelesen;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Benachrichtigung_Fahrer that = (Benachrichtigung_Fahrer) o;
        return benachrichtigungs_ID == that.benachrichtigungs_ID && fahrernummer == that.fahrernummer && restaurant_ID == that.restaurant_ID && gelesen == that.gelesen && Objects.equals(benachrichtigung, that.benachrichtigung) && Objects.equals(timestamp, that.timestamp);
    }

    @Override
    public int hashCode() {
        return Objects.hash(benachrichtigungs_ID, fahrernummer, benachrichtigung, restaurant_ID, timestamp, gelesen);
    }

    @Override
    public String toString() {
        return "Benachrichtigung_Fahrer{" +
                "benachrichtigungs_ID=" + benachrichtigungs_ID +
                ", fahrernummer=" + fahrernummer +
                ", benachrichtigung='" + benachrichtigung + '\'' +
                ", restaurant_ID=" + restaurant_ID +
                ", timestamp=" + timestamp +
                ", gelesen=" + gelesen +
                '}';
    }
}
