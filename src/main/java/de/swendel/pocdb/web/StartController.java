package de.swendel.pocdb.web;

import de.swendel.pocdb.domain.BerechnungDetails;
import de.swendel.pocdb.domain.BerechnungStatus;
import de.swendel.pocdb.repo.BerechnungDetailsRepository;
import de.swendel.pocdb.repo.BerechnungStatusRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class StartController {

    private final BerechnungStatusRepository statusRepository;
    private final BerechnungDetailsRepository detailsRepository;

    public StartController(BerechnungStatusRepository statusRepository,
                           BerechnungDetailsRepository detailsRepository) {
        this.statusRepository = statusRepository;
        this.detailsRepository = detailsRepository;
    }

    @PostMapping("/start")
    public ResponseEntity<?> start(@RequestBody(required = false) Map<String, Object> body) {
        // Create status row
        BerechnungStatus savedStatus = statusRepository.save(BerechnungStatus.startedNow());

        // Optional details
        if (body != null && body.containsKey("details") && body.get("details") != null) {
            String details = String.valueOf(body.get("details"));
            detailsRepository.save(BerechnungDetails.of(savedStatus.getId(), details));
        }

        return ResponseEntity.created(URI.create("/api/status/" + savedStatus.getId())).body(savedStatus);
    }
}
