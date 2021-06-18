package de.eat4speed.controllers;

import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

import de.eat4speed.services.interfaces.IRoutingService;

@Path("/route")
public class RoutingController {

    @Inject
    IRoutingService _router;

    @GET
    @Path("/calculate/{email}")
    @Consumes(MediaType.TEXT_PLAIN)
    @Produces(MediaType.APPLICATION_JSON)
    public String get_Sorted_Waypoints_test(@PathParam("email") String email) {

        try {
            return _router.get_best_Route(email).toString();
        } catch (Exception e) {
            System.out.println("Null was returned: " + e.getMessage());
            return null;
        }
    }


    @GET
    @Path("/confirm/{art}")
    @Produces(MediaType.APPLICATION_JSON)
    public String get_Sorted_Waypoints(@PathParam("art") String art, @QueryParam("auftraege") String auftraege, @QueryParam("data") String data, @QueryParam("email") String email) {

        _router.confirm(art, auftraege, data, email);

        return "okay";
    }
}