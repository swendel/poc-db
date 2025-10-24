package de.swendel.pocdb.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("BerechnungDetails")
public class BerechnungDetails {

    @Id
    private Long id;

    @Column("status_id")
    private Long statusId;

    private String details;

    public BerechnungDetails() {
    }

    public BerechnungDetails(Long id, Long statusId, String details) {
        this.id = id;
        this.statusId = statusId;
        this.details = details;
    }

    public static BerechnungDetails of(Long statusId, String details) {
        return new BerechnungDetails(null, statusId, details);
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getStatusId() {
        return statusId;
    }

    public void setStatusId(Long statusId) {
        this.statusId = statusId;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }
}
