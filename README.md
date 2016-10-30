# CND Language / [Jahia][1] Framework support for [IntelliJ IDEA][3]

definitions.cnd files syntax highlighting, code completion, and other amazing stuff.


## Features


### CND Language

 * Syntax highlighting
 * Syntax checking and error highlighting
 * Code completion
 * Code formatting
 * Find usages (ctrl-click/cmd-click) - for namespaces, nodetypes and nodetypes properties declarations (**not getting namespaces and nodetypes usages in .properties files for the moment though**)
 * Go to declaration (ctrl-click/cmd-click) - for namespaces and nodetypes usages throughout the file
 * Refactoring 
    * Rename (shift+f6) - for namespaces, nodetypes and nodetypes properties declarations (**not renaming namespaces and nodetypes usages in .properties files for the moment though**)
 * File icon ![CND file icon](src/fr/tolc/jahia/intellij/plugin/cnd/icons/cnd.png) 
 * Line markers for namespaces ![namespace](src/fr/tolc/jahia/intellij/plugin/cnd/icons/namespace.png) and nodetypes ![nodetype](src/fr/tolc/jahia/intellij/plugin/cnd/icons/nodeType.png) / mixins ![mixin](src/fr/tolc/jahia/intellij/plugin/cnd/icons/mixin.png)
 * Brace matching - closing brackets and parenthesis are automatically inserted when authorized by the syntax
 * Commenter (ctrl+/) - to comment lines of code



### Jahia Framework
![Jahia][2]

##### Compatible with Jahia versions **6.6.x** & **7.x**

 * CND files features:
     * Helpers/Quickfixes (alt+enter on nodetype name)
        * Create nodetype and nodetype properties translations - only appears if no translation is found
        * Create new view - opens a popup that lets you choose the new view parameters, creates view and cache properties files, and also creates the folders if they don't already exist. **If the view is a JSP, the new view also contains code to access all the node properties and sub nodes.**
     * View files grouping (creates a virtual folder ![view folder](src/fr/tolc/jahia/intellij/plugin/cnd/icons/viewBig.png) - or ![hidden view folder](src/fr/tolc/jahia/intellij/plugin/cnd/icons/viewBigHidden.png) if hidden view - in the Project View)
 * Other files/languages features:
     * JSP
        * Nodetypes usages highlighting & line markers ![nodetype](src/fr/tolc/jahia/intellij/plugin/cnd/icons/nodeType.png)/![mixin](src/fr/tolc/jahia/intellij/plugin/cnd/icons/mixin.png)
        * Nodetypes completion
        * Go to nodetype declaration (ctrl-click/cmd-click)
        * Unknown nodetype error highlighting
        * Create nodetype quickfix (alt+enter on nodetype name) - if known namespace but unknown nodetype
     * Java
        * Nodetypes usages highlighting & line markers ![nodetype](src/fr/tolc/jahia/intellij/plugin/cnd/icons/nodeType.png)/![mixin](src/fr/tolc/jahia/intellij/plugin/cnd/icons/mixin.png)
        * Go to nodetype declaration (ctrl-click/cmd-click)
        * Unknown nodetype error highlighting
        * Create nodetype quickfix (alt+enter on nodetype name) - if known namespace but unknown nodetype
     * XML
        * Nodetypes usages highlighting & line markers ![nodetype](src/fr/tolc/jahia/intellij/plugin/cnd/icons/nodeType.png)/![mixin](src/fr/tolc/jahia/intellij/plugin/cnd/icons/mixin.png)
        * Go to nodetype declaration (ctrl-click/cmd-click)
        * Unknown nodetype error highlighting
        * Create nodetype quickfix (alt+enter on nodetype name) - if known namespace but unknown nodetype
     * Properties (resource bundles)
        * Translations keys syntax highlighting & line markers for namespaces ![namespace](src/fr/tolc/jahia/intellij/plugin/cnd/icons/namespace.png), nodetypes ![nodetype](src/fr/tolc/jahia/intellij/plugin/cnd/icons/nodeType.png)/![mixin](src/fr/tolc/jahia/intellij/plugin/cnd/icons/mixin.png) and properties ![property](src/fr/tolc/jahia/intellij/plugin/cnd/icons/property.png)
        * Go to namespace, nodetype or property declaration from translations keys (ctrl-click/cmd-click)
        * Error message if adding translations for a choicelist on a non-choicelist property
        * **Note:** at the moment the translations keys for the nodetypes and properties are still marked as 'unused'

    <!--* Replace explicit string library calls like `string.len("foo")` with `("foo"):len()`-->


## Roadmap

##### This is just the beginning.

 * Embed Jahia base and main modules .cnd files to be able to provide features on `nt:`, `mix:`, `jnt:` and `jmix:` nodetypes usages
 * Improved JSP support:
    * Properties and property type completion in `${currentNode.properties.propertyName}`, `${currentNode.properties['propertyName']}` and `jcr:property`
    * Views completion in `template:include` and `template:module`
 * Improved Properties support:
    * Resource bundles .properties extension to be able to find namespaces and nodetypes usages in it, and also removed the 'unused' annotations
    * View cache .properties custom language
 * Plugin settings
 * Make helpers/quickfixes accessible through Actions in menus
 * Groovy support

##### Don't hesitate to request features / suggest enhancements by opening an Issue.

--

 [1]: https://www.jahia.com/
 [2]: https://www.jahia.com/files/live/sites/jahiacom/files/logo-jahia-2016.png
 [3]: https://www.jetbrains.com/idea/