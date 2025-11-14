package de.vzg.intr2dok.doi;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.mycore.datamodel.metadata.MCRMetadataManager;
import org.mycore.datamodel.metadata.MCRObject;
import org.mycore.datamodel.metadata.MCRObjectID;
import org.mycore.frontend.cli.annotation.MCRCommand;
import org.mycore.frontend.cli.annotation.MCRCommandGroup;
import org.mycore.mods.MCRMODSWrapper;

@MCRCommandGroup(name = "DOI Publisher Commands")
public class VZGDOIPublisherCommands {

  private static final Logger LOGGER = LogManager.getLogger();

  @MCRCommand(syntax = "publishDoi of objects {0}",
      help = "Publish DOI for object with given ID. It still checks preconditions before publishing.")
  public static void publishDoiForObject(String objectIdStr) {

    MCRObjectID objectID = MCRObjectID.getInstance(objectIdStr);

    if (!MCRMetadataManager.exists(objectID)) {
      throw new IllegalArgumentException("Object with ID " + objectIdStr + " does not exist.");
    }

    MCRObject object = MCRMetadataManager.retrieveMCRObject(objectID);

    MCRMODSWrapper modsWrapper = new MCRMODSWrapper(object);
    if (VZGDOIUtils.isRegisteredDOIPresent(modsWrapper)) {
      VZGPublishDOIEventHandler.getPublisher().stream()
          .filter(publisher -> publisher.isResponsible(modsWrapper)).forEach(publisher -> {
            LOGGER.info("Publishing DOI for object {} using publisher {}", objectIdStr,
                publisher.getClass().getSimpleName());
            publisher.publish(modsWrapper);
          });
    }
  }

}
