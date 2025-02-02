package de.eat4speed.controllers;

import de.eat4speed.entities.Benutzer;
import de.eat4speed.services.interfaces.IBenutzerService;

import javax.annotation.security.PermitAll;
import javax.inject.Inject;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("/Login")
public class LoginController {

    @Inject
    IBenutzerService _benutzer;

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Path("admin")
    public Response checkAdminCredentials(Benutzer requestedUser) {
        return _benutzer.checkCredentials(requestedUser, 'a');
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Path("user")
    public Response checkCustomerCredentials(Benutzer requestedUser) {
        return _benutzer.checkCredentials(requestedUser, 'u');
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Path("restaurant")
    public Response checkRestaurantCredentials(Benutzer requestedUser) {
        return _benutzer.checkCredentials(requestedUser, 'r');
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Path("driver")
    public Response checkDriverCredentials(Benutzer requestedUser) {
        return _benutzer.checkCredentials(requestedUser, 'd');
    }
}
