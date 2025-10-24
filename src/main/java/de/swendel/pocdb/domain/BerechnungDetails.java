package de.swendel.pocdb.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.util.UUID;

@Table("BerechnungDetails")
public class BerechnungDetails {

    @Id
    private UUID id;

    @Column("status_id")
    private UUID statusId;

    private String details;

    public BerechnungDetails() {
    }

    public BerechnungDetails(UUID id, UUID statusId, String details) {
        this.id = id;
        this.statusId = statusId;
        this.details = details;
    }

    public static BerechnungDetails of(UUID statusId, String details) {
        return new BerechnungDetails(null, statusId, details);
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getStatusId() {
        return statusId;
    }

    public void setStatusId(UUID statusId) {
        this.statusId = statusId;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }
}
