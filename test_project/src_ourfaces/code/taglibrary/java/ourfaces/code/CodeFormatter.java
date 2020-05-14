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

package ourfaces.code;

import de.java2html.javasource.*;
import de.java2html.converter.JavaSource2HTMLConverter;
import de.java2html.options.*;
import java.io.*;
import java.net.*;

/**
 *
 * @author  Matthias Unverzagt
 */
public class CodeFormatter {
    
    /** Creates a new instance of CodeFormatter */
    public CodeFormatter() {
    }
    
    /**
     *
     * @param file
     * @param style
     */    
    public String getHTML(File file, String style) {
        //Parse the raw text to a JavaSource object
        JavaSource source = null; 
        try {
            source = new JavaSourceParser().parse(file); 
        } catch (IOException e) {
            e.printStackTrace();
        }
        return getHTML(source, style);
    }
        
    /**
     *
     * @param url
     * @param style
     */    
    public String getHTML(URL url, String style) {
        //Parse the raw text to a JavaSource object
        JavaSource source = null; 
        try {
            source = new JavaSourceParser().parse(url); 
        } catch (IOException e) {
            e.printStackTrace();
        }
        return getHTML(source, style); 
    }
    
    /**
     *
     * @param code
     * @param style
     */    
    public String getHTML(String code, String style) {
        //Parse the raw text to a JavaSource object
        JavaSource source = new JavaSourceParser().parse(code); 
        return getHTML(source, style);
    }
    
    
    private String getHTML(JavaSource source, String style) {
        Java2HtmlConversionOptions option = Java2HtmlConversionOptions.getDefault();
        if (style != null) {
            JavaSourceStyleTable t = JavaSourceStyleTable.getPredefinedTable(style);
            option.setStyleTable(t);
        }
        JavaSource2HTMLConverter converter = new JavaSource2HTMLConverter(source); 
        converter.setConversionOptions(option);
        StringWriter writer = new StringWriter();
        try {
            converter.convert(writer);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return writer.toString();
    }
    
    
}
