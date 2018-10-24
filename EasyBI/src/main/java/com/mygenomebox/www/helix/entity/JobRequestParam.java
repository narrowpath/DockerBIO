package com.mygenomebox.www.helix.entity;

import java.io.Serializable;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import lombok.Data;

/**
 * @author jason.kim
 *
 */

@Data
public class JobRequestParam implements Serializable {
    private static final Logger logger = Logger.getLogger(JobRequestParam.class);

    private static final long serialVersionUID = 2974739083921008039L;
    private String noUser;
    private String jobSelect;
    private String refDbOptions;
    private String refDbSelects;
    private String dbOptions;
    private String dbSelects;
    private String userDbOptions;
    private String userDbSelects;
    private String argument;
    private String resultArgument;
    private String ynSimulate;
    private String outputExt;
    private String commandTest;
    private String tag;

    public String[] getRefDbOption() {
	logger.debug("refDbOptions size:" + this.refDbOptions.split(",").length + " ,value:" + refDbOptions);
	return this.refDbOptions.split(",");
    }

    public String[] getRefDbSelect() {
	if (this.refDbSelects == null)
	    return null;

	logger.debug("refDbSelects size:" + this.refDbSelects.split(",").length + " ,value:" + refDbSelects);
	return this.refDbSelects.split(",");
    }

    public String[] getDbOption() {
	logger.debug("dbOptions size:" + this.dbOptions.split(",").length + " ,value:" + dbOptions);
	return this.dbOptions.split(",");
    }

    public String[] getDbSelect() {
	if (this.dbSelects == null)
	    return null;

	logger.debug("dbSelects size:" + this.dbSelects.split(",").length + " ,value:" + dbSelects);
	return this.dbSelects.split(",");
    }

    public String[] getUserDbOption() {
	logger.debug("userDbOptions size:" + this.userDbOptions.split(",").length + " ,value:" + userDbOptions);
	return this.userDbOptions.split(",");
    }

    public String[] getUserDbSelect() {
	if (this.userDbSelects == null)
	    return null;

	logger.debug("dbSelects size:" + this.userDbSelects.split(",").length + " ,value:" + userDbSelects);
	return this.userDbSelects.split(",");
    }

    public String getNoJob() {
	return jobSelect;
    }

    public String getlastTag() {
	return (StringUtils.isEmpty(this.tag))?"latest":tag;
    }
}