/*
 * This file is part of the OurFaces distribution of JavaServer Faces custom ui components.
 * Documentation and updates may be found at http://ourfaces.dev.java.net
 *
 * The contents of this file are subject to the Sun Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. A copy of the License is available at
 * http://www.sun.com/
 *
 * The Original Code is OurFaces. The Initial Developer of the
 * Original Code is Matthias Unverzagt. Portions created by Matthias Unverzagt are Copyright
 * (C) 2004. All Rights Reserved.
 *
 * Contributor(s): Matthias Unverzagt.
 */

package ourfaces.code.renderkit;


import java.io.IOException;
import javax.faces.component.UIComponent;
import javax.faces.component.UIOutput;
import javax.faces.context.FacesContext;
import javax.faces.context.ResponseWriter;
import ourfaces.common.renderkit.*;
import ourfaces.code.*;
import java.io.*;
import java.net.*;
import javax.faces.el.ValueBinding;


/**
 * Renders java code using the html2java package
 */
public class CodeRenderer extends BaseRenderer {


    /**
     *
     * @param component
     */    
    public boolean supportsComponentType(UIComponent component) {
        return (component instanceof UIOutput);
    }

    
    /**
     *
     * @param context
     * @param component
     */    
    public void decode(FacesContext context, UIComponent component) {
    }


    /**
     *
     * @param context
     * @param component
     * @throws IOException
     */    
    public void encodeBegin(FacesContext context, UIComponent component)
        throws IOException {
        ;
    }


    /**
     *
     * @param context
     * @param component
     * @throws IOException
     */    
    public void encodeChildren(FacesContext context, UIComponent component)
        throws IOException {
        ;
    }


    /**
     * 
     */
    public void encodeEnd(FacesContext context, UIComponent component)
        throws IOException {
        if ((context == null) || (component == null)) {
            throw new NullPointerException();
        }
        ResponseWriter writer = context.getResponseWriter();
        CodeFormatter codeFormatter = new CodeFormatter();

        ValueBinding vb = component.getValueBinding("code");
        String code = null;
        if (vb != null)
            code = (String) vb.getValue(context);
        if (code == null)
            code =  (String) component.getAttributes().get("code");
        
        vb = component.getValueBinding("style");
        String style = null;
        if (vb != null)
            style = (String) vb.getValue(context);
        if (style == null)
            style =  (String) component.getAttributes().get("style");  
        
        vb = component.getValueBinding("filename");
        String filename = null;
        if (vb != null)
            filename = (String) vb.getValue(context);
        if (filename == null)
            filename =  (String) component.getAttributes().get("filename"); 
        
        vb = component.getValueBinding("output");
        String output = null;
        if (vb != null)
            output = (String) vb.getValue(context);
        if (output == null)
            output =  (String) component.getAttributes().get("output"); 
        
        String html = null;
        if (output == null) {
            if (code != null && code.length() > 0) {
                html = codeFormatter.getHTML(code, style);
            } else if (filename != null) {
                URL url = context.getExternalContext().getResource(filename);
                html = codeFormatter.getHTML(url, style);
            }
            component.getAttributes().put("output", html); 
        } else {
            html = output;
        }
        if (html != null)
            writer.write(html);

    }


}
