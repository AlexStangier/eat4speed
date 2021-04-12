package de.eat4speed.entities;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Time;

@Entity
public class Oeffnungszeiten extends PanacheEntityBase implements Serializable {
    @Id
    @GeneratedValue
    private int oeffnungszeiten_ID;
    private Time anfang;
    private Time ende;
    private String wochentag;

    public int getOeffnungszeiten_ID() {
        return oeffnungszeiten_ID;
    }
    public void setOeffnungszeiten_ID(int oeffnungszeitenId) {
        this.oeffnungszeiten_ID = oeffnungszeitenId;
    }


    public Time getAnfang() {
        return anfang;
    }
    public void setAnfang(Time anfang) {
        this.anfang = anfang;
    }

    public Time getEnde() {
        return ende;
    }
    public void setEnde(Time ende) {
        this.ende = ende;
    }

    public String getWochentag() {
        return wochentag;
    }
    public void setWochentag(String wochentag) {
        this.wochentag = wochentag;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Oeffnungszeiten that = (Oeffnungszeiten) o;

        if (oeffnungszeiten_ID != that.oeffnungszeiten_ID) return false;
        if (anfang != null ? !anfang.equals(that.anfang) : that.anfang != null) return false;
        if (ende != null ? !ende.equals(that.ende) : that.ende != null) return false;
        if (wochentag != null ? !wochentag.equals(that.wochentag) : that.wochentag != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = oeffnungszeiten_ID;
        result = 31 * result + (anfang != null ? anfang.hashCode() : 0);
        result = 31 * result + (ende != null ? ende.hashCode() : 0);
        result = 31 * result + (wochentag != null ? wochentag.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "OeffnungszeitenEntity{" +
                "oeffnungszeiten_ID=" + oeffnungszeiten_ID +
                ", anfang=" + anfang +
                ", ende=" + ende +
                ", wochentag='" + wochentag + '\'' +
                '}';
    }
}
