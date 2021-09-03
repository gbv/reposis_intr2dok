package de.vzg.intr2dok.doi;

import com.google.gson.Gson;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
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
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;

import static de.vzg.intr2dok.doi.VZGDOIUtils.getDOIElement;
import static de.vzg.intr2dok.doi.VZGDOIUtils.getRecordIdentifier;

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

            httpPut.setHeader("Authorization", "Bearer " + getToken());

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

    private String getToken() {
        final String blogURL = getBlogURL();
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            final HttpPost httpPost = new HttpPost(new URIBuilder(blogURL + "/wp-json/jwt-auth/v1/token")
                    .build());

            httpPost.setEntity(new StringEntity("{\"username\":\"" + getUsername() + "\", " +
                    "\"password\":\""+getPassword()+"\"}", StandardCharsets.UTF_8));

            httpPost.setHeader("content-type", "application/json");

            try (final CloseableHttpResponse response = httpClient.execute(httpPost)) {
                final int statusCode = response.getStatusLine().getStatusCode();
                if (statusCode != 200) {
                    final String reasonPhrase = response.getStatusLine().getReasonPhrase();
                    throw new MCRException("Something went wrong while getting Token from blog: " + statusCode + "-" + reasonPhrase);
                } else {
                    try(InputStream is = response.getEntity().getContent()){
                        final Gson gson = new Gson();
                        final TokenResponse tokenResponse = gson.fromJson(new InputStreamReader(is, StandardCharsets.UTF_8), TokenResponse.class);
                        LOGGER.info("Token received from Server: " + tokenResponse.toString());
                        return tokenResponse.token;
                    }
                }
            }

        } catch (IOException | URISyntaxException e) {
            throw new MCRException("Error while getting token from Blog!", e);
        }
    }

    private String getUsername() {
        return getProperty(USERNAME_PROPERTY).get();
    }

    private String getPassword() {
        return getProperty(PASSWORD_PROPERTY).get();
    }
}
