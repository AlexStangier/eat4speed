
import org.jboss.resteasy.annotations.jaxrs.PathParam;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;


@Path("/Benutzer")
public class GreetingResource {

    @GET
    @Path("get/{id}")
    @Produces(MediaType.TEXT_PLAIN)
    public String getBenutzer(@PathParam("id") long id) {
        return "hello";
    }
}

