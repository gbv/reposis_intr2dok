package de.vzg.intr2dok.doi;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.List;
import java.util.Objects;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.jdom2.Element;
import org.mycore.common.MCRClassTools;
import org.mycore.common.MCRException;
import org.mycore.common.config.MCRConfiguration2;
import org.mycore.common.events.MCREvent;
import org.mycore.common.events.MCREventHandlerBase;
import org.mycore.datamodel.metadata.MCRMetadataManager;
import org.mycore.datamodel.metadata.MCRObject;
import org.mycore.mods.MCRMODSWrapper;

import static de.vzg.intr2dok.doi.VZGDOIUtils.getDOIElement;
import static de.vzg.intr2dok.doi.VZGDOIUtils.isRegisteredDOIPresent;

public class VZGPublishDOIEventHandler extends MCREventHandlerBase {

    private static final String DOI_PUBLISHER_LIST_PROPERTY = "VZG.VZGPublishDOIEventHandler.DOIPublisher";

    private static final List<VZGDOIPublisher> PUBLISHER = getPublisher();

    @Override
    protected void handleObjectUpdated(MCREvent evt, MCRObject obj) {
        final MCRMODSWrapper newObjectWrapper = new MCRMODSWrapper(obj);

        final MCRObject oldObject = MCRMetadataManager.retrieveMCRObject(obj.getId());
        final MCRMODSWrapper oldWrapper = new MCRMODSWrapper(oldObject);


        if (isRegisteredDOIPresent(newObjectWrapper)) {
            if (!isRegisteredDOIPresent(oldWrapper)) {
                PUBLISHER.stream()
                    .filter(publisher -> publisher.isResponsible(newObjectWrapper))
                    .forEach(publisher -> publisher.publish(newObjectWrapper));
            }
        }
    }

    private static List<VZGDOIPublisher> getPublisher() {
        return Stream.of(MCRConfiguration2.getString(DOI_PUBLISHER_LIST_PROPERTY).orElse("").split(","))
            .filter(Objects::nonNull)
            .filter(s -> !s.isEmpty())
            .map(key -> {
                try {
                    String clazzName = MCRConfiguration2.getStringOrThrow("VZG.VZGDOIPublisher." + key + ".Class");
                    final Class<? extends VZGDOIPublisher> clazz = MCRClassTools.forName(clazzName);
                    final Constructor<? extends VZGDOIPublisher> constructor = clazz.getConstructor(String.class);
                    return constructor.newInstance(key);
                } catch (ClassNotFoundException | NoSuchMethodException | InstantiationException
                    | IllegalAccessException | InvocationTargetException e) {
                    throw new MCRException(e);
                }
            }).collect(Collectors.toList());
    }


}
