package de.swendel.pocdb.repo;

import de.swendel.pocdb.domain.BerechnungStatus;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface BerechnungStatusRepository extends CrudRepository<BerechnungStatus, UUID> {
}
