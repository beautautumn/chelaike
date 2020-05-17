package com.tianche.core.component;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTagSupport;

/**
 * Created by jf on 15/5/28.
 */
public class TemplateOverrideTag extends BodyTagSupport{

    private String name;

    @Override
    public int doStartTag() throws JspException {
        return isOverrided() ? SKIP_BODY : EVAL_BODY_BUFFERED;
    }

    @Override
    public int doEndTag() throws JspException {
        if (!isOverrided()) {
            BodyContent b = getBodyContent();
            String varName = "__template_block__" + name;
            pageContext.setAttribute(varName, b.getString());
        }
        return EVAL_PAGE;
    }

    private boolean isOverrided() {
        String varName = "__template_block__" + name;
        return pageContext.getAttribute(varName) != null;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
