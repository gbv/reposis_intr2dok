package de.vzg.intr2dok.doi;

import static de.vzg.intr2dok.doi.VZGDOIUtils.getDOIElement;
import static de.vzg.intr2dok.doi.VZGDOIUtils.getRecordIdentifier;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.mycore.common.MCRException;
import org.mycore.common.config.MCRConfigurationException;
import org.mycore.mods.MCRMODSWrapper;

public class VZGWordpressDOIMetaBoxPublisher extends VZGWordpressDOIPublisher {

    private static final String USERNAME_PROPERTY = "Username";

    private static final String PASSWORD_PROPERTY = "Password";

    public VZGWordpressDOIMetaBoxPublisher(String id) {
        super(id);
        if (!getProperty(USERNAME_PROPERTY).isPresent()) {
            throw new MCRConfigurationException(
                "Username is not set in " + this.getClass().toString() + "(" + this.getId() + ")");
        }
        if (!getProperty(PASSWORD_PROPERTY).isPresent()) {
            throw new MCRConfigurationException(
                "Password is not set in " + this.getClass().toString() + "(" + this.getId() + ")");
        }
    }

    private static final Logger LOGGER = LogManager.getLogger();

    @Override
    public void publish(MCRMODSWrapper wrapper) {
        final String doi = getDOIElement(wrapper).getTextNormalize();
        final String blogURL = getBlogURL();
        final String articleID = getRecordIdentifier(wrapper).getTextNormalize();

        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            final HttpPut httpPut = new HttpPut(new URIBuilder(blogURL + "wp-json/wp/v2/posts/" + articleID)
                .addParameter("meta_box", "{\"doi\":\"" + doi + "\"}")
                    .build());

            httpPut.setHeader("Authorization", "Basic " + getEncodedAuth());

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

    private String getEncodedAuth() {
        final byte[] encoded = Base64.getEncoder().encode((getUsername() + ":" + getPassword()).getBytes(StandardCharsets.UTF_8));
        return new String(encoded, StandardCharsets.UTF_8);
    }

    private String getUsername() {
        return getProperty(USERNAME_PROPERTY).get();
    }

    private String getPassword() {
        return getProperty(PASSWORD_PROPERTY).get();
    }
}
