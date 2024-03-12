package com.sc.sangchu.postgresql.entity;

import jakarta.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class CommDistId implements Serializable {
    private Integer coId;
    private Integer serviceCode;

    public CommDistId() {}

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof CommDistId)) return false;
        CommDistId that = (CommDistId) o;
        return Objects.equals(coId, that.coId) &&
                Objects.equals(serviceCode, that.serviceCode);
    }

    @Override
    public int hashCode() {
        return Objects.hash(coId, serviceCode);
    }
}
