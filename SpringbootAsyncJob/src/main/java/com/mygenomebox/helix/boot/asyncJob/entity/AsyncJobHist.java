package com.mygenomebox.helix.boot.asyncJob.entity;

import java.io.Serializable;

import com.mygenomebox.helix.boot.asyncJob.jobs.BackgroundJob;

import lombok.Data;

/**
 * @author jason.kim
 *
 */

@Data
public class AsyncJobHist implements Serializable {
    public AsyncJobHist() {
	super();
    }

    public AsyncJobHist(BackgroundJob job) {
	this.noUser = job.getNoUser();
	this.noJob = job.getNoJob();
	this.dtJobStart = job.getDtJobStart();
	this.commandDocker = job.getCommandDocker();
	this.processJobName = job.getProcessJobName();
    }

    private static final long serialVersionUID = 6914451957319838087L;
    private String noUserEnc;
    private String processJobName;
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
    private String desc;
}