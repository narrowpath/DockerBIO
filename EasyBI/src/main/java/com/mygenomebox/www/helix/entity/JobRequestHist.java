package com.mygenomebox.www.helix.entity;

import java.io.Serializable;

import lombok.Data;

/**
 * @author jason.kim
 *
 */

@Data
public class JobRequestHist implements Serializable {
	public JobRequestHist() {super();}
	
	/**
	 * JobRequestHist construct with JobRequestParam
	 * @param requestParam
	 * @param dtJobStart
	 * @param command
	 */
	public JobRequestHist(JobRequestParam requestParam, String dtJobStart, String command) {
		this.noUser = requestParam.getNoUser();
		this.noJob = requestParam.getNoJob();
		this.dtJobStart = dtJobStart;
		this.commandDocker = command;
		this.ynSimulate = requestParam.getYnSimulate();
		this.commandTest = requestParam.getCommandTest();
	}
	
	private static final long serialVersionUID = 6914451957319838087L;
	private String noUser;
	private String noJob;
	private String nmJob;
	private String dtJobStart;
	private String dtJobEnd;
	private String cdJobStat;
	private String cdJobEndStat;
	private String successCondition;
	private String msgResult;
	private String fileResult;
	private String commandDocker;
	private String ynSimulate;
	private String commandTest;
	private String tag;
}