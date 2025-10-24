package de.swendel.pocdb.repo;

import de.swendel.pocdb.domain.BerechnungDetails;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface BerechnungDetailsRepository extends CrudRepository<BerechnungDetails, UUID> {
}
