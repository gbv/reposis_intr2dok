package de.vzg.intr2dok.doi;

import com.google.gson.Gson;
import org.jdom2.Element;
import org.mycore.common.MCRConstants;
import org.mycore.datamodel.metadata.MCRMetaLangText;
import org.mycore.mods.MCRMODSWrapper;
import org.mycore.pi.MCRPIService;
import org.mycore.pi.backend.MCRPI;

import java.util.ArrayList;
import java.util.stream.Collectors;

public class VZGDOIUtils {
    protected static Element getDOIElement(MCRMODSWrapper modsWrapper) {
        return modsWrapper.getElement("mods:identifier[@type='doi']");
    }

    protected static boolean isRegisteredDOIPresent(MCRMODSWrapper modsWrapper) {
        return modsWrapper.getMCRObject().getService().getFlags(MCRPIService.PI_FLAG)
            .stream()
            .map((flag) -> new Gson().fromJson(flag, MCRPI.class))
            .anyMatch(pi -> pi.getType().equals("doi") && pi.getRegistered() != null);
    }

    protected static Element getRecordIdentifier(MCRMODSWrapper wrapper) {
        return wrapper.getElement("mods:recordInfo/mods:recordIdentifier");
    }

    protected static String getIDOfRelatedItem(Element relatedItem) {
        return relatedItem.getAttributeValue("href", MCRConstants.XLINK_NAMESPACE);
    }

    protected static Element getRelatedItem(MCRMODSWrapper wrapper) {
        return wrapper.getElement("mods:relatedItem[@type='host']");
    }
}
