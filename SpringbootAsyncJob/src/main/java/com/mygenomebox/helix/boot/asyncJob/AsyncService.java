package com.mygenomebox.helix.boot.asyncJob;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.mygenomebox.helix.boot.asyncJob.dao.AsyncJobMapper;
import com.mygenomebox.helix.boot.asyncJob.entity.AsyncJobHist;
import com.mygenomebox.helix.boot.asyncJob.jobs.BackgroundJob;

@Service
public class AsyncService {
    private static final Logger logger = Logger.getLogger(AsyncService.class);

    @Autowired
    private AsyncJobMapper asyncJobMapper;

    @Async
    public void doWork(Runnable runnable) {
	BackgroundJob job = (BackgroundJob) runnable;
	logger.debug("Got runnable " + runnable);
	logger.debug("job {}" + job);
	asyncJobMapper.insertOrUpdate(new AsyncJobHist(job));
	runnable.run();
    }
}
