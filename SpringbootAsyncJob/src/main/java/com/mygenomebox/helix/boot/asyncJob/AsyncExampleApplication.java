package com.mygenomebox.helix.boot.asyncJob;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.PropertySource;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import com.mygenomebox.helix.boot.asyncJob.dao.AsyncJobMapper;
import com.mygenomebox.helix.boot.asyncJob.entity.AsyncJobHist;
import com.mygenomebox.helix.boot.asyncJob.jobs.BackgroundJob;

@SpringBootApplication
@EnableAsync
@PropertySource("config.properties")
public class AsyncExampleApplication {
    @Value("${config.corePoolSize}")
    private int corePoolSize;

    @Bean
    public ThreadPoolTaskExecutor taskExecutor() {
	ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
	executor.setCorePoolSize(corePoolSize);
	
	return executor;
    }

    public static void main(String[] args) {
	SpringApplication.run(AsyncExampleApplication.class, args);
    }
}