package de.swendel.pocdb.domain;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.Instant;
import java.util.UUID;

@Data
@Table("BerechnungStatus")
public class BerechnungStatus {

    @Id
    private UUID id;

    private String status;

    @Column("started_at")
    private Instant startedAt;

    public BerechnungStatus() {
    }

    public BerechnungStatus(UUID id, String status, Instant startedAt) {
        this.id = id;
        this.status = status;
        this.startedAt = startedAt;
    }

    public static BerechnungStatus startedNow() {
        return new BerechnungStatus(null, "STARTED", Instant.now());
    }

    public UUID getId() {
        return id;
    }

}
