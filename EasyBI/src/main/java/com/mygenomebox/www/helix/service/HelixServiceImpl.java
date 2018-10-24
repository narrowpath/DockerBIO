package com.mygenomebox.www.helix.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.mygenomebox.www.helix.dao.HelixMapper;
import com.mygenomebox.www.helix.entity.DockerInfo;
import com.mygenomebox.www.helix.entity.DockerTagInfo;
import com.mygenomebox.www.helix.entity.JobRequestHist;
import com.mygenomebox.www.helix.entity.RequestDb;
import com.mygenomebox.www.helix.entity.SingleJobInfo;

/**
 * @author jason.kim
 *
 */
@Service("helixService")
public class HelixServiceImpl implements HelixService {
    @Autowired
    private HelixMapper helixMapper;

    // 게시판 리스트
    @Override
    public List<DockerInfo> dockerInfos(Map<String, Object> map) {
	return helixMapper.dockerInfos(map);
    }

    @Override
    public int dockerInfoCount(HashMap<String, Object> map) {
	return helixMapper.dockerInfoCount(map);
    }

    @Override
    public List<SingleJobInfo> singleJobList(SingleJobInfo singleJobInfo) {
	return helixMapper.singleJobList(singleJobInfo);
    }

    @Override
    public List<JobRequestHist> jobRequestHistList(String noUser, String noJob, String ynSimulate) {
	HashMap<String, String> map = new HashMap<>();
	map.put("noUser", noUser);
	map.put("noJob", noJob);
	map.put("ynSimulate", ynSimulate);
	return helixMapper.jobRequestHistList(map);
    }

    @Override
    public int txInsert(JobRequestHist requestHist) {
	return helixMapper.insertJobRequestHist(requestHist);
    }

    @Override
    @Async
    public boolean asyncCommandExecute(JobRequestHist jobRequestHist) {
	// TODO Auto-generated method stub
	return false;
    }

    @Override
    public int txUpdateAsyncResult(JobRequestHist jobRequestHist) {
	return helixMapper.updateAsyncResult(jobRequestHist);
    }

    @Override
    public int txInsertSingleJob(String mode, SingleJobInfo singleJobInfo) {
	// TODO Auto-generated method stub
	if (mode.equals("create")) {
	    return helixMapper.InsertSingleJob(singleJobInfo);
	} else if (mode.equals("update")) {
	    return helixMapper.updateSingleJob(singleJobInfo);
	}
	else {
	    return helixMapper.deleteSingleJob(singleJobInfo);
	}
    }

    private int txInsertDockerTagInfo(String idDocker, List<DockerTagInfo> dockerTagInfos) {
	if(helixMapper.isDockerTagExists(idDocker)) {
	    helixMapper.deleteDockerTagInfo(idDocker);
	}
	return helixMapper.insertDockerTagInfo(dockerTagInfos);
    }

    @Override
    public int txInsertRequestDb(RequestDb requestDb) {
	return helixMapper.InsertRequestDb(requestDb);
    }

    @Override
    public List<RequestDb> requestDbList(RequestDb requestDb) {
	return helixMapper.requestDbList(requestDb);
    }
}
