package com.mygenomebox.www.helix.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.mygenomebox.www.common.config.ibatis.MyBatisDao;
import com.mygenomebox.www.helix.entity.DockerInfo;
import com.mygenomebox.www.helix.entity.DockerTagInfo;
import com.mygenomebox.www.helix.entity.JobRequestHist;
import com.mygenomebox.www.helix.entity.RequestDb;
import com.mygenomebox.www.helix.entity.SingleJobInfo;

/**
 * @author jason.kim
 *
 */
@MyBatisDao
public interface HelixMapper {
    /**
     * dockerinfo list
     * @param map
     * @return
     */
    List<DockerInfo> dockerInfos(Map<String, Object> map);
    int dockerInfoCount(HashMap<String, Object> map);
	List<SingleJobInfo> singleJobList(SingleJobInfo singleJobInfo);
	List<JobRequestHist> jobRequestHistList(HashMap<String, String> map);
	int insertJobRequestHist(JobRequestHist requestHist);
	int updateAsyncResult(JobRequestHist jobRequestHist);
	int InsertSingleJob(SingleJobInfo singleJobInfo);
	int updateSingleJob(SingleJobInfo singleJobInfo);
	int deleteSingleJob(SingleJobInfo singleJobInfo);
	int InsertRequestDb(RequestDb requestDb);
	boolean isDockerTagExists(String idDocker);
	void deleteDockerTagInfo(String idDocker);
	int insertDockerTagInfo(List<DockerTagInfo> dockerTagInfos);
	List<RequestDb> requestDbList(RequestDb requestDb);
}