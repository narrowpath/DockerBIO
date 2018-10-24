package com.mygenomebox.helix.boot.asyncJob.jobs;

import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import com.mygenomebox.helix.boot.asyncJob.Messages.JobprogressMessage;

/**
 * Created by Frenos on 18.08.2016.
 */
public class ExampleJob implements DetailedJob {

    private SimpMessagingTemplate template;


    private int loops = 20;
    private AtomicInteger progress = new AtomicInteger();
    private String state = "NEW";
    private Random myRandom = new Random();

    private String processJobName = "";

    public ExampleJob(String processJobName, SimpMessagingTemplate template) {
        this.processJobName = processJobName;
        this.template = template;
        sendProgress();
    }


    ExampleJob(int loops) {
        this.loops = loops;
    }

    @Override
    public void run() {
        state = "RUNNING";
        sendProgress();
        for (double i = 0.0; i <= loops; i++) {
            try {
                Thread.sleep(1000);
                Thread.sleep(myRandom.nextInt(5000));
                progress.set((int) ((i / loops) * 100));
                sendProgress();

            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        state = "DONE";
        sendProgress();
    }

    public void sendProgress() {
        JobprogressMessage temp = new JobprogressMessage(processJobName);
        temp.setProgress(progress.get());
        temp.setState(state);

        template.convertAndSend("/topic/status", temp);
    }

    public int getProgress() {
        return progress.get();
    }

    public String getState() {
        return state;
    }

    public String getProcessJobName() {
        return processJobName;
    }
}
