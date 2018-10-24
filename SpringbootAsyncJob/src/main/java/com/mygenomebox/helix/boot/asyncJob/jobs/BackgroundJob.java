package com.mygenomebox.helix.boot.asyncJob.jobs;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.mygenomebox.helix.boot.asyncJob.Messages.JobprogressMessage;
import com.mygenomebox.helix.boot.asyncJob.entity.AsyncJobHist;
import com.mygenomebox.www.common.util.Constant;
import com.mygenomebox.www.common.util.HttpSend;
import com.mygenomebox.www.common.util.PropertiesUtils;
import com.mygenomebox.www.common.util.RegExUtil;
import com.mygenomebox.www.common.util.ShellUtil;

public class BackgroundJob implements DetailedJob {
	private static final Logger logger = Logger.getLogger(BackgroundJob.class);

	private SimpMessagingTemplate template;
	private AtomicInteger progress = new AtomicInteger();
	private String state = Constant.JOB_STAT_NEW;
	private String processJobName = "";

	private String commandDocker = "";
	private String noUser = "";
	private String noJob = "";
	private String dtJobStart = "";

	@JsonIgnore
	private String platformUrl = "";
	@JsonIgnore
	private String uploadDir = "";
	@JsonIgnore
	private String runMode = "";
	@JsonIgnore
	private HashMap<String, String> mapParam = new HashMap();

	public BackgroundJob() {
		super();
	}

	public BackgroundJob(AsyncJobHist jobHist, SimpMessagingTemplate template, boolean isInit) throws Exception {
		this.processJobName = jobHist.getProcessJobName();
		this.template = template;
		this.commandDocker = jobHist.getCommandDocker();
		this.noUser = jobHist.getNoUser();
		this.noJob = jobHist.getNoJob();
		this.dtJobStart = jobHist.getDtJobStart();
		this.platformUrl = System.getenv("HOSTIP") + PropertiesUtils.getProperties("config", "config.platform.url");
		this.uploadDir = PropertiesUtils.getProperties("config", "user.upload.dir");
		this.runMode = PropertiesUtils.getProperties("config", "config.run.mode");

		// logger.debug("BackgroundJob {}:"+this);

		if (template != null) {
			sendProgress(isInit);
		} else {
			this.state = Constant.cdJobStat_READY.equals(jobHist.getCdJobStat()) ? Constant.JOB_STAT_NEW
					: Constant.cdJobStat_START.equals(jobHist.getCdJobStat()) ? Constant.JOB_STAT_RUN
							: Constant.JOB_STAT_DONE;
		}
	}

	@Override
	public void run() {
		progress.set(0);
		state = "NEW";
		sendProgress(false);
		mapParam.put(Constant.jobRequestURL, platformUrl);
		mapParam.put(Constant.userAgent, Constant.mozilla);
		mapParam.put("noUser", noUser);
		mapParam.put("dtJobStart", dtJobStart);
		mapParam.put("cdJobStat", Constant.cdJobStat_START);
		try {
			logger.debug("job start mapParam:" + mapParam);
			HttpSend.setHttpPost(mapParam);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			logger.error("job start mapParam:" + mapParam);
			e1.printStackTrace();
		}

		try {
			logger.debug(processJobName + " is started..");
			logger.debug("runMode:" + runMode);
			logger.debug("commandDocker:" + commandDocker);
			state = Constant.JOB_STAT_RUN;
			progress.set(1);
			sendProgress(false);
			String result = ("TEST".equals(runMode)) ? "TEST MODE EXECUTE" : ShellUtil.shellCmd(Constant.getDocker(), commandDocker);
			mapParam.put("cdJobStat", Constant.cdJobStat_COMPLETE);
			mapParam.put("cdJobEndStat", Constant.cdJobEndStat_SUCCESS);

			if ("TEST".equals(runMode)) {
				Thread.sleep(30000);
			}
			progress.set(100);
			state = Constant.JOB_STAT_DONE;
			sendProgress(false);
		} catch (Exception e) {
			progress.set(100);
			state = Constant.JOB_STAT_ERR;
			sendProgress(false);

			mapParam.put("cdJobStat", Constant.cdJobStat_COMPLETE);
			mapParam.put("cdJobEndStat", Constant.cdJobEndStat_FAIL);
			e.printStackTrace();
		}

		try {
			String resultDir = uploadDir + Constant.userDir + noUser + Constant.fileSeprator + Constant.resultDir
					+ dtJobStart + Constant.fileSeprator;
			File logFile = new File(resultDir + "_result_.log");
			File dirResult = new File(resultDir);

			if ("TEST".equals(runMode)) {
				// TEST 모드에서는 일정시간 이후 완료로 처리
				FileUtils.writeStringToFile(logFile, "TEST MODE END", true);
				Thread.sleep(10000);
				mapParam.put("msgResult", "Requested action completed.");
				mapParam.put("cdJobEndStat", Constant.cdJobEndStat_SUCCESS);
			} else {
				logger.debug("1");
				// 실제 운영 모드
				if (logFile.exists()) {
					mapParam.put("msgResult",
							org.apache.commons.io.FileUtils.readFileToString(logFile).replaceAll("\\n.*", ""));
				}

				logger.debug("2");
				if (dirResult.listFiles().length == 0 || (dirResult.listFiles().length == 1
						&& (dirResult.listFiles()[0].getName().equals(Constant.resultLogFile)
								|| (!dirResult.listFiles()[0].getName().equals(Constant.resultLogFile)
										&& dirResult.listFiles()[0].length() == 0)))) {
					logger.debug("3");
					logger.debug("no Result");
					if (dirResult.listFiles().length == 0)
						logger.debug("dirResult.listFiles().length:" + dirResult.listFiles().length);
					if (dirResult.listFiles().length != 0)
						logger.debug("dirResult.listFiles()[0].getName():" + dirResult.listFiles()[0].getName()
								+ ",dirResult.listFiles()[0].length():");

					if (logFile.exists()) {
						// mapParam.put("msgResult", "Requested processing failure. See _result_.log
						// file");
					} else {
						mapParam.put("msgResult", org.apache.commons.io.FileUtils
								.readFileToString(dirResult.listFiles()[0]).replaceAll("\\n.*", ""));
					}
					mapParam.put("cdJobEndStat", Constant.cdJobEndStat_FAIL);
				} else if (dirResult.listFiles().length == 1 && dirResult.listFiles()[0].length() < 10000
						&& RegExUtil.fileMultiLine(
								org.apache.commons.io.FileUtils.readFileToString(dirResult.listFiles()[0]),
								Constant.error_fileContentMatcher)) {
					logger.debug("4");
					// mapParam.put("msgResult", "Requested processing failure. See result file");
					mapParam.put("msgResult", org.apache.commons.io.FileUtils.readFileToString(dirResult.listFiles()[0])
							.replaceAll("\\n.*", ""));
					mapParam.put("cdJobEndStat", Constant.cdJobEndStat_FAIL);
				} else {
					logger.debug("5");
					mapParam.put("msgResult", "Requested action completed.");
					mapParam.put("cdJobEndStat", Constant.cdJobEndStat_SUCCESS);
				}

				logger.debug("6");
				if (dirResult.listFiles().length == 1 && dirResult.listFiles()[0].length() < 100000) {
					logger.debug("error match:" + RegExUtil.fileMultiLine(
							org.apache.commons.io.FileUtils.readFileToString(dirResult.listFiles()[0]),
							Constant.error_fileContentMatcher));
					logger.debug("RESULT:" + org.apache.commons.io.FileUtils.readFileToString(dirResult.listFiles()[0])
							.replaceAll("\\r\\n.*", ""));
				}
				logger.debug("7");
			}

			logger.debug("mapParam:" + mapParam);
			for (Map.Entry<String, String> elem : mapParam.entrySet()) {
				if (elem == null || elem.getKey() == null || elem.getValue() == null) {
					logger.error("elem null");
				} else {
					logger.debug(String.format("키 : %s, 값 : %s", elem.getKey(), elem.getValue()));
				}
			}

			HttpSend.setHttpPost(mapParam);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error("error:" + e);
			logger.error("job end mapParam:" + mapParam);
			e.printStackTrace();
		}
	}

	public void sendProgress(boolean isInit) {
		JobprogressMessage temp = new JobprogressMessage(processJobName);
		temp.setProgress(progress.get());
		temp.setState(state);

		template.convertAndSend("/topic/status", temp);
		// template.convertAndSend("/topic/statusUpdate", new AsyncJobHist(this));

		if (!isInit) {
			try {
				HashMap<String, String> mapStatusParam = new HashMap<String, String>();
				mapStatusParam.put(Constant.jobRequestURL, "http://localhost:"
						+ PropertiesUtils.getProperties("application", "server.port") + "/updateStatus");
				mapStatusParam.put(Constant.userAgent, Constant.mozilla);
				mapStatusParam.put(Constant.processJobName, processJobName);
				mapStatusParam.put(Constant.noUser, noUser);
				mapStatusParam.put(Constant.noJob, noJob);
				mapStatusParam.put("dtJobStart", dtJobStart);
				mapStatusParam.put("cdJobStat", mapParam.get("cdJobStat"));
				mapStatusParam.put("cdJobEndStat", mapParam.get("cdJobEndStat"));
				HttpSend.setHttpPost(mapStatusParam);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public int getProgress() {
		return this.progress.get();
	}

	public String getState() {
		return state;
	}

	public String getProcessJobName() {
		return processJobName;
	}

	public String getCommandDocker() {
		return commandDocker;
	}

	public void setCommandDocker(String commandDocker) {
		this.commandDocker = commandDocker;
	}

	public String getNoUser() {
		return noUser;
	}

	public void setNoUser(String noUser) {
		this.noUser = noUser;
	}

	public String getNoJob() {
		return noJob;
	}

	public void setNoJob(String noJob) {
		this.noJob = noJob;
	}

	public String getDtJobStart() {
		return dtJobStart;
	}

	public void setDtJobStart(String dtJobStart) {
		this.dtJobStart = dtJobStart;
	}
}
