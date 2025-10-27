package de.swendel.pocdb.domain;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.util.UUID;

@Data
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

}
