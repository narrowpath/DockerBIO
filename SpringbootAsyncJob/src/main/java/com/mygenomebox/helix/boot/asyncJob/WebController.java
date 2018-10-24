package com.mygenomebox.helix.boot.asyncJob;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.PropertySource;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SubscribeMapping;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mygenomebox.helix.boot.asyncJob.dao.AsyncJobMapper;
import com.mygenomebox.helix.boot.asyncJob.entity.AsyncJobHist;
import com.mygenomebox.helix.boot.asyncJob.jobs.BackgroundJob;
import com.mygenomebox.www.common.util.Aes256Encrypt;

/**
 * Created by Frenos on 18.08.2016.
 */
@Controller
@PropertySource("config.properties")
public class WebController {
	private static final Logger logger = Logger.getLogger(WebController.class);
	private final AsyncService myService;

	@Autowired
	WebController(AsyncService myService) {
		this.myService = myService;
	}

	@Qualifier("taskExecutor")
	@Autowired
	private ThreadPoolTaskExecutor myExecutor;

	@Autowired
	private SimpMessagingTemplate template;

	@Autowired
	private AsyncJobMapper asyncJobMapper;

	private ArrayList<BackgroundJob> myJobList = new ArrayList<>(5);

	@PostConstruct
	public void init() {
		List<AsyncJobHist> jobHist = asyncJobMapper.asyncJobHistList();
		for (AsyncJobHist asyncJobHist : jobHist) {
			BackgroundJob newJob = null;
			try {
				newJob = new BackgroundJob(asyncJobHist, template, true);
				// logger.debug("newjob:[]" + newJob);
				this.myJobList.add(newJob);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	@PostMapping("/addJob")
	@ResponseBody
	public void addJob(@ModelAttribute("jobHist") AsyncJobHist jobHist) throws Exception {
		if (StringUtils.isEmpty(jobHist.getCommandDocker())) {
			logger.debug("command is null");
			return;
		}
		logger.debug("jobHist info {}" + jobHist);
		logger.debug(this + "START startWork");
		jobHist.setNoUser(Aes256Encrypt.aesDecode(jobHist.getNoUserEnc()));

		BackgroundJob newJob = new BackgroundJob(jobHist, template, true);
		logger.debug("newJob info {}" + newJob);

		this.myJobList.add(newJob);
		myService.doWork(newJob);
		logger.debug(this + "END startWork");
	}

	@RequestMapping(value = "/status")
	@ResponseBody
	@SubscribeMapping("initial")
	ArrayList<BackgroundJob> fetchStatus() {
		logger.debug("status");
		return this.myJobList;
	}

	@RequestMapping(value = "/poolsize/{newSize}")
	@ResponseBody
	public void setNewPoolsize(@PathVariable("newSize") int id) {
		logger.debug("poolsize");
		myExecutor.setCorePoolSize(id);
	}

	@MessageMapping("/topic/statusUpdate")
	@RequestMapping(value = "/updateStatus")
	@ResponseBody
	public void update(@ModelAttribute("jobHist") AsyncJobHist jobHist) {
		logger.info("update");
		logger.info(jobHist);
		asyncJobMapper.insertOrUpdate(jobHist);
	}
}
