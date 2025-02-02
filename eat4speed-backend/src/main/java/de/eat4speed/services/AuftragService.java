package de.eat4speed.services;

import de.eat4speed.entities.Auftrag;
import de.eat4speed.repositories.AuftragRepository;
import de.eat4speed.repositories.BenutzerRepository;
import de.eat4speed.services.interfaces.IAuftragService;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.transaction.Transactional;
import javax.ws.rs.core.Response;
import java.util.List;

@ApplicationScoped
public class AuftragService implements IAuftragService {

    private AuftragRepository auftragRepository;

    @Inject
    public AuftragService(AuftragRepository auftragRepository) {
        this.auftragRepository = auftragRepository;
    }

    @Override
    public Response addAuftrag(Auftrag auftrag) {

        auftragRepository.addAuftrag(auftrag);

        return Response.status(Response.Status.CREATED).entity(auftrag).build();
    }

    @Override
    public Response deleteAuftag(int id) {
        auftragRepository.deleteAuftag(id);

        return Response.status(Response.Status.OK).build();
    }

    @Override
    public Response updateAuftragStatus(int id, String status)
    {
        auftragRepository.updateAuftragStatus(id, status);

        return Response.status(Response.Status.OK).build();
    }

    @Override
    public Response updateAuftragFahrernummer(int auftrags_ID, int fahrernummer) {
        auftragRepository.updateAuftragFahrernummer(auftrags_ID, fahrernummer);

        return Response.status(Response.Status.OK).build();
    }

    @Override
    public List getAuftragFahrernummerByAuftrags_ID(int auftrags_ID) {
        return auftragRepository.getAuftragFahrernummerByAuftrags_ID(auftrags_ID);
    }

    @Override
    public Response setToErledigt(int id)
    {
        auftragRepository.setToErledigt(id);
        return Response.status(Response.Status.OK).build();
    }

}
