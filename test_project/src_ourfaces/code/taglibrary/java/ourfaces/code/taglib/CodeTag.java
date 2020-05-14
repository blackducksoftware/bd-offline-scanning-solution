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

package ourfaces.code.taglib;

import javax.faces.component.UIComponent;
import javax.faces.webapp.UIComponentTag;
import javax.faces.context.FacesContext;
import javax.faces.el.ValueBinding;


/**
 * This class is the tag handler that evaluates the <code>stylesheet</code>
 * custom tag.
 */

public class CodeTag extends UIComponentTag {


    private String fileName = null;
    
    /**
     * Holds value of property code.
     */
    private String code;
    
    /**
     * Holds value of property style.
     */
    private String style;
    
    /**
     * Holds value of property output.
     */
    private String output;
    
    /**
     *
     * @param fileName
     */    
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }


    /**
     *
     */    
    public String getComponentType() {
        return ("javax.faces.Output");
    }


    /**
     *
     */    
    public String getRendererType() {
        return "Code";
    }


    /**
     *
     * @param component
     */    
    protected void setProperties(UIComponent component) {

        super.setProperties(component);


        if (fileName != null) {
            if (isValueReference(fileName)) {
                ValueBinding vb = FacesContext.getCurrentInstance().getApplication().createValueBinding(fileName);
                component.setValueBinding("filename", vb);
            } else {
                component.getAttributes().put("filename", code);
            }
        }

        if (code != null) {
            if (isValueReference(code)) {
                ValueBinding vb = FacesContext.getCurrentInstance().getApplication().createValueBinding(code);
                component.setValueBinding("code", vb);
            } else {
                component.getAttributes().put("code", code);
            }
        }
        
        if (output != null) {
            if (isValueReference(output)) {
                ValueBinding vb = FacesContext.getCurrentInstance().getApplication().createValueBinding(output);
                component.setValueBinding("output", vb);
            } else {
                component.getAttributes().put("output", output);
            }
        }

        if (style != null) {
            if (isValueReference(style)) {
                ValueBinding vb = FacesContext.getCurrentInstance().getApplication().createValueBinding(style);
                component.setValueBinding("style", vb);
            } else {
                component.getAttributes().put("style", code);
            }
        }        

    }

    /**
     * Getter for property code.
     * @return Value of property code.
     */
    public String getCode() {
        return this.code;
    }    

    /**
     * Setter for property code.
     * @param code New value of property code.
     */
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * Getter for property style.
     * @return Value of property style.
     */
    public String getStyle() {
        return this.style;
    }
    
    /**
     * Setter for property style.
     * @param style New value of property style.
     */
    public void setStyle(String style) {
        this.style = style;
    }
    
    /**
     * Getter for property output.
     * @return Value of property output.
     */
    public String getOutput() {
        return this.output;
    }
    
    /**
     * Setter for property output.
     * @param output New value of property output.
     */
    public void setOutput(String output) {
        this.output = output;
    }
    
}
