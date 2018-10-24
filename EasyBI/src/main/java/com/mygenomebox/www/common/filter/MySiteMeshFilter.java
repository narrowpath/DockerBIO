package com.mygenomebox.www.common.filter;

import org.sitemesh.SiteMeshContext;
import org.sitemesh.content.ContentProperty;
import org.sitemesh.content.tagrules.TagRuleBundle;
import org.sitemesh.content.tagrules.html.ExportTagToContentRule;
import org.sitemesh.tagprocessor.State;

public class MySiteMeshFilter implements TagRuleBundle {
    public void install(State state, ContentProperty contentProperty, SiteMeshContext siteMeshContext) {
	state.addRule("footerScript", new ExportTagToContentRule(siteMeshContext, contentProperty.getChild("footerScript"), false));
    }

    public void cleanUp(State state, ContentProperty contentProperty, SiteMeshContext siteMeshContext) {

    }
}