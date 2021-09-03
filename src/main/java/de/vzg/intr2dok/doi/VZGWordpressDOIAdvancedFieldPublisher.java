package de.vzg.intr2dok.doi;

import org.apache.http.HttpHeaders;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.mycore.common.MCRException;
import org.mycore.common.config.MCRConfigurationException;
import org.mycore.mods.MCRMODSWrapper;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import static de.vzg.intr2dok.doi.VZGDOIUtils.getDOIElement;
import static de.vzg.intr2dok.doi.VZGDOIUtils.getRecordIdentifier;

public class VZGWordpressDOIAdvancedFieldPublisher extends VZGWordpressDOIPublisher {

    private static final Logger LOGGER = LogManager.getLogger();

    public VZGWordpressDOIAdvancedFieldPublisher(String id) {
        super(id);
        if (!getProperty("BlogURL").isPresent()) {
            throw new MCRConfigurationException(
                "BlogURL is not set in " + this.getClass().toString() + "(" + this.getId() + ")");
        }
        if (!getProperty("Username").isPresent()) {
            throw new MCRConfigurationException(
                "Username is not set in " + this.getClass().toString() + "(" + this.getId() + ")");
        }
        if (!getProperty("Password").isPresent()) {
            throw new MCRConfigurationException(
                    "Password is not set in " + this.getClass().toString() + "(" + this.getId() + ")");
        }
    }

    @Override
    public void publish(MCRMODSWrapper wrapper) {
        final String doi = getDOIElement(wrapper).getTextNormalize();
        final String blogURL = getBlogURL();
        final String articleID = getRecordIdentifier(wrapper).getTextNormalize();

        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            final HttpPost httpPost = new HttpPost(
                new URIBuilder(blogURL + "wp-json/acf/v3/posts/" + articleID + "/doi")
                    .build());
            final String encodedAuth = getEncodedAuth();
            httpPost.setEntity(new StringEntity("{\"fields\":{\"doi\":\"" + doi + "\"}}"));
            httpPost.setHeader(HttpHeaders.AUTHORIZATION,"Basic "+ encodedAuth);
            httpPost.setHeader("Content-Type", "application/json");

            try (final CloseableHttpResponse response = httpClient.execute(httpPost)) {
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

    private String getPassword() {
        return getProperty("Password").get();
    }

    private String getUsername() {
        return getProperty("Username").get();
    }


}
