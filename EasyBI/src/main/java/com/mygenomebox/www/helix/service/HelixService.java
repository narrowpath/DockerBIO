package com.mygenomebox.www.helix.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.mygenomebox.www.helix.entity.DockerInfo;
import com.mygenomebox.www.helix.entity.JobRequestHist;
import com.mygenomebox.www.helix.entity.RequestDb;
import com.mygenomebox.www.helix.entity.SingleJobInfo;

/**
 * @author jason.kim
 *
 */
public interface HelixService {
    public List<DockerInfo> dockerInfos(Map<String, Object> map);

    public int dockerInfoCount(HashMap<String, Object> hashMap);

	public List<SingleJobInfo> singleJobList(SingleJobInfo singleJobInfo);

	public List<JobRequestHist> jobRequestHistList(String noUser, String noJob, String ynSimulate);

	public int txInsert(JobRequestHist requestHist);
	
	public boolean asyncCommandExecute(JobRequestHist jobRequestHist);

	public int txUpdateAsyncResult(JobRequestHist jobRequestHist);

	public int txInsertSingleJob(String mode, SingleJobInfo singleJobInfo);

	public int txInsertRequestDb(RequestDb requestDb);

	public List<RequestDb> requestDbList(RequestDb requestDb);
}
