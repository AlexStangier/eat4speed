package de.eat4speed.controllers;


import de.eat4speed.repositories.FahrerRepository;
import de.eat4speed.repositories.FahrzeugRepository;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/Fahrer")
public class FahrerController {


    @Inject
    FahrerRepository fahrerRepository;

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String get(){
        return fahrerRepository.listAll().toString();
    }

}
