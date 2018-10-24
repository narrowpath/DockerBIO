package com.mygenomebox.helix.boot.asyncJob.Messages;

/**
 * Created by Frenos on 23.08.2016.
 */
public class JobprogressMessage {
    private String processJobName;
    private String state;
    private int progress;

    public JobprogressMessage(String processJobName)
    {
        this.processJobName = processJobName;
    }

    public String getProcessJobName() {
        return processJobName;
    }

    public String getState() {
        return state;
    }

    public int getProgress() {
        return progress;
    }

    public void setState(String state) {
        this.state = state;
    }

    public void setProgress(int progress) {
        this.progress = progress;
    }
}
