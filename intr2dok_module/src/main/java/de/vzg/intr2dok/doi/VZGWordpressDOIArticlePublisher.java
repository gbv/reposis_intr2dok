package de.vzg.intr2dok.doi;

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

import java.io.IOException;
import java.net.URISyntaxException;

import static de.vzg.intr2dok.doi.VZGDOIUtils.getDOIElement;
import static de.vzg.intr2dok.doi.VZGDOIUtils.getRecordIdentifier;

public class VZGWordpressDOIArticlePublisher extends VZGWordpressDOIPublisher {

    public VZGWordpressDOIArticlePublisher(String id) {
        super(id);
        if (!getProperty("Token").isPresent()) {
            throw new MCRConfigurationException(
                    "Token is not set in " + this.getClass().toString() + "(" + this.getId() + ")");
        }
    }

    private static final Logger LOGGER = LogManager.getLogger();

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

}
