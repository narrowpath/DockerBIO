package com.mygenomebox.www.helix.entity;

import java.io.Serializable;

import lombok.Data;

/**
 * @author jason.kim
 *
 */

@Data
public class SingleJobInfo implements Serializable {
	public SingleJobInfo() {
	    super();
	}
	
	public SingleJobInfo(String noJob2) {
	    super();
	    this.noJob = noJob2;
	}
	
	private static final long serialVersionUID = 1848247174825528448L;
	private String noJob;
	private String noUser;
	private String dtReg;
	private String nmJob;
	private String idDocker;
	private int countDbArgument;
	private String argument;
	private String outputArgument;
	private String outputExt;
	private int countUserFileArgument;
	private String successCondition;
	private String ynRefDb;
	private String ynDb;
	private String argumentRefDb;
	private String argumentDb;
	private String argumentUserDb;
	private String refDb;
	private String db;
	private String ynPublic;
	private String tag;
}