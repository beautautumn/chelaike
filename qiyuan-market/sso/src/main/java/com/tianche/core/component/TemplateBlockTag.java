package com.tianche.core.component;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;
import java.io.IOException;

/**
 * Created by jf on 15/5/28.
 */
public class TemplateBlockTag extends BodyTagSupport {

    private String name;


    @Override
    public int doStartTag() throws JspException {
        return getOverriedContent() == null ? EVAL_BODY_INCLUDE : SKIP_BODY;
    }

    @Override
    public int doEndTag() throws JspException {
        String overriedContent = getOverriedContent();
        if (overriedContent != null) {
            try {
                pageContext.getOut().write(overriedContent);
            } catch (IOException e) {
                throw new JspException("write override Content throw IOException,block name:" + name, e);
            }
        }
        return EVAL_PAGE;
    }

    private String getOverriedContent() {
        String varName = "__template_block__" + name;
        return (String) pageContext.getAttribute(varName);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
