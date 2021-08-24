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

public class VZGWordpressDOIPublisher extends VZGDOIPublisher {

    private static final Logger LOGGER = LogManager.getLogger();

    public VZGWordpressDOIPublisher(String id) {
        super(id);
        if (!getProperty("BlogURL").isPresent()) {
            throw new MCRConfigurationException(
                "BlogURL is not set in " + this.getClass().toString() + "(" + this.getId() + ")");
        }
        if (!getProperty("Token").isPresent()) {
            throw new MCRConfigurationException(
                "Token is not set in " + this.getClass().toString() + "(" + this.getId() + ")");
        }
    }

    public String getBlogURL() {
        // .get is safe because constructor errors if not set
        return getProperty("BlogURL").get();
    }

    @Override
    public void publish(MCRMODSWrapper wrapper) {
        final String doi = getDOIElement(wrapper).getTextNormalize();
        final String blogURL = getBlogURL();
        final String articleID = getRecordIdentifier(wrapper).getTextNormalize();

        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            final HttpPut httpPut = new HttpPut(new URIBuilder(blogURL + "wp-json/wp/v2/articles/" + articleID)
                .addParameter("meta_box", "{\"doi_json\":\"" + doi + "\"}")
                .build());

            httpPut.setHeader("Authorization", "Bearer " + getProperty("Token").get());

            try (final CloseableHttpResponse response = httpClient.execute(httpPut)) {
                final int statusCode = response.getStatusLine().getStatusCode();
                if (statusCode != 200) {
                    final String reasonPhrase = response.getStatusLine().getReasonPhrase();
                    throw new MCRException("Something went wrong when sending DOI to the blog: " + statusCode + "-" + reasonPhrase);
                } else {
                    LOGGER.info("DOI: " + doi + " successfully sent to " + blogURL);
                }
            }

        } catch (IOException | URISyntaxException e) {
            throw new MCRException("Error while sending DOI to Blog!", e);
        }
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

        if (!getIDOfRelatedItem(relatedItem).equals(parent)) {
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
