
# reposis_fdrwiso

## Installation Instructions

* run `mvn clean install`
* copy jar to ~/.mycore/(dev-)mir/lib/

## Features

### Wordpress DOI Transmission

This module contains an EventHandler which is able to transfer new minted DOI of blog entries to a Wordpress-Instance.

The EventHandler works like this:
1. If an Object is updated the EventHandler checks if the object has a fresh registered DOI. 
It does this by reading the old data on the disk and comparing it to the new data it gets from MyCoRe in the event handler process. 
It compares the Registered field in the json in the objects flags in the service part of the MyCoRe-Object.
2. Then it asks all configured `Publishers` if they have a Blog where this Object is assignable. 
They do this by checking if the parent in object is the parent which is configured in the properties.
3. Every publisher which tells the EventHandler it is responsible, then gets called by the EventHandler. 
The EventHandler then transfers the DOI to the Blog.


Some Wordpress Blogs use different plugins to store the DOI there are currently two supported plugins:

#### VZGWordpressDOIMetaBoxPublisher
The MetaBoxPublisher uses basic authentication to send a json object to the RestAPI of the Blog.

The json object looks like this:
```json
{"doi":"the/doi"}
```
It is sent as PUT with the encoded query parameter `meta_box` to `$blog_url/wp-json/wp/v2/posts/$post_id`.

An example Configuration looks like this:
```properties
VZG.VZGDOIPublisher.VoelkerrechtsBlog.Class=de.vzg.intr2dok.doi.VZGWordpressDOIMetaBoxPublisher
VZG.VZGDOIPublisher.VoelkerrechtsBlog.Parent=mycore_blogobject_00000001
VZG.VZGDOIPublisher.VoelkerrechtsBlog.BlogURL=https://myblogurl.org/
VZG.VZGDOIPublisher.VoelkerrechtsBlog.Username=my_secret_username
VZG.VZGDOIPublisher.VoelkerrechtsBlog.Password=my_very_secret_password
```

#### VZGWordpressDOIAdvancedFieldPublisher
The AdvancedFieldPublisher uses basic authentication to send a json object to RestAPI of the Blog.

The json object looks like this:
```json
{"fields":{"doi":"the/doi"}}
```

It is sent as POST with the json object as body to `$blog_url/wp-json/acf/v3/posts/$post_id/doi`.

An example Configuration looks like this:
```properties
VZG.VZGDOIPublisher.GPIL.Class=de.vzg.intr2dok.doi.VZGWordpressDOIAdvancedFieldPublisher
VZG.VZGDOIPublisher.GPIL.Parent=mycore_blogobject_00000002
VZG.VZGDOIPublisher.GPIL.BlogURL=https://myotherblogurl.org/
VZG.VZGDOIPublisher.GPIL.Username=my_secret_username
VZG.VZGDOIPublisher.GPIL.Password=my_other_very_secret_password
```


## Development

You can add these to your ~/.mycore/(dev-)mir/.mycore.properties
``` properties
MCR.Developer.Resource.Override=/path/to/reposis_fdrwiso/src/main/resources
MCR.LayoutService.LastModifiedCheckPeriod=0
MCR.UseXSLTemplateCache=false
MCR.SASS.DeveloperMode=true
```