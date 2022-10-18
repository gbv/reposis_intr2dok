package de.vzg.intr2dok.doi;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.Optional;

import com.google.common.base.Predicate;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.params.HttpClientParamConfig;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.params.HttpParams;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jdom2.Element;
import org.mycore.common.MCRConstants;
import org.mycore.common.MCRException;
import org.mycore.common.config.MCRConfigurationException;
import org.mycore.mods.MCRMODSWrapper;
import org.mycore.pi.MCRPIManager;
import org.mycore.pi.MCRPIServiceManager;

import static de.vzg.intr2dok.doi.VZGDOIUtils.getDOIElement;
import static de.vzg.intr2dok.doi.VZGDOIUtils.getIDOfRelatedItem;
import static de.vzg.intr2dok.doi.VZGDOIUtils.getRecordIdentifier;
import static de.vzg.intr2dok.doi.VZGDOIUtils.getRelatedItem;

public abstract class VZGWordpressDOIPublisher extends VZGDOIPublisher {

    private static final Logger LOGGER = LogManager.getLogger();

    public VZGWordpressDOIPublisher(String id) {
        super(id);
        if (!getProperty("BlogURL").isPresent()) {
            throw new MCRConfigurationException(
                "BlogURL is not set in " + this.getClass().toString() + "(" + this.getId() + ")");
        }
        if (!getProperty("Parent").isPresent()) {
            throw new MCRConfigurationException(
                    "Parent is not set in " + this.getClass().toString() + "(" + this.getId() + ")");
        }
    }

    public String getBlogURL() {
        // .get is safe because constructor errors if not set
        return getProperty("BlogURL").get();
    }



    @Override
    public Boolean isResponsible(MCRMODSWrapper wrapper) {
        final Optional<String> parentOptional = getProperty("Parent");
        if (!parentOptional.isPresent()) {
            return false;
        }

        final String parent = parentOptional.get();
        final Element relatedItem = getRelatedItem(wrapper);
        if (relatedItem == null) {
            return false;
        }

        String relatedItemHref = getIDOfRelatedItem(relatedItem);
        if (!parent.equals(relatedItemHref)) {
            return false;
        }
        final Element element = getRecordIdentifier(wrapper);
        if (element == null || element.getTextNormalize().isEmpty()) {
            LOGGER.warn(getClass().toString() + " is not responsible for " + wrapper.getMCRObject().getId()
                + " because recordIdentifier is not set!");
            return false;
        }

        return true;
    }

}
