package com.mygenomebox.helix.boot.asyncJob.jobs;

import java.util.concurrent.atomic.AtomicInteger;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;

/**
 * Created by Frenos on 18.08.2016.
 */
interface DetailedJob extends Runnable {
    int getProgress();

    String getState();

    String getProcessJobName();
}
