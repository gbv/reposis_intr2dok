package de.vzg.intr2dok.doi;

import java.util.Optional;

import org.mycore.common.config.MCRConfiguration2;
import org.mycore.mods.MCRMODSWrapper;

public abstract class VZGDOIPublisher {
    private final String id;

    public VZGDOIPublisher(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    protected Optional<String> getProperty(final String property) {
        return MCRConfiguration2.getString("VZG.VZGDOIPublisher." + getId() + "." + property);
    }

    public abstract void publish(final MCRMODSWrapper wrapper);
    public abstract Boolean isResponsible(final MCRMODSWrapper wrapper);
}
