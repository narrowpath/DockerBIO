package com.mygenomebox.www.helix.web;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
//import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mygenomebox.www.common.config.spring.HelixUser;
import com.mygenomebox.www.common.util.Aes256Encrypt;
import com.mygenomebox.www.common.util.Constant;
import com.mygenomebox.www.common.util.CurlRequest;
import com.mygenomebox.www.common.util.DateUtility;
import com.mygenomebox.www.common.util.FileSort;
import com.mygenomebox.www.common.util.HttpSend;
import com.mygenomebox.www.common.util.JsonReturn;
import com.mygenomebox.www.common.util.MessageUtil;
import com.mygenomebox.www.exception.RestApiException;
import com.mygenomebox.www.helix.entity.FileInfo;
import com.mygenomebox.www.helix.entity.JobRequestHist;
import com.mygenomebox.www.helix.entity.JobRequestParam;
import com.mygenomebox.www.helix.entity.RequestDb;
import com.mygenomebox.www.helix.entity.SingleJobInfo;
import com.mygenomebox.www.helix.service.HelixService;
import com.sun.org.apache.xml.internal.utils.URI;

/**
 * @author jason.kim
 *
 */
@Component
@Controller
@RequestMapping("/web/helix")
public class HelixController {
	private static final Logger logger = Logger.getLogger(HelixController.class);

	@Resource(name = "helixService")
	private HelixService helixService;
	ObjectMapper mapper = new ObjectMapper();

	@Value("${config.upload.dir}")
	private String uploadDir;

	@Value("${config.asyncJob.url}")
	private String asyncJobUrl;

	@Value("${config.asyncJob.addJob}")
	private String addJob;

	@Value("${config.ext.dbFile}")
	private String dbExt;

	@Value("${config.ext.userFile}")
	private String userFileExt;

	/**
	 * helix easy bi tool main page Simulate too. When Simulate NoJob was
	 * required
	 * 
	 * @param model
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = {"", "/index", "/sim"})
	public String index(ModelMap model, @RequestParam(value = "ynSimulate", defaultValue = Constant.N, required = false) String ynSimulate,
			@RequestParam(value = "noJob", required = false) String noJob) throws IOException {
		HelixUser helixUsers = HelixUser.getUserSession();
		String noUser = helixUser.getNouser();

		logger.debug("/web/helix");
		logger.debug("uploadUrl:" + uploadDir + Constant.userDir + noUser + Constant.fileSeprator + Constant.userFileDir);
		logger.debug("dbDir:" + uploadDir + Constant.dbDir);
		logger.debug("refDbDir:" + uploadDir + Constant.refDbDir);

		File userUploadDir = new File(uploadDir + (ynSimulate.equals(Constant.Y) ? Constant.sampleDir : Constant.userDir + noUser + Constant.fileSeprator + Constant.userFileDir));
		if (!userUploadDir.exists()) {
			FileUtils.forceMkdir(userUploadDir);
		}
		File dbUploadDir = new File(uploadDir + Constant.dbDir);
		if (!dbUploadDir.exists()) {
			FileUtils.forceMkdir(dbUploadDir);
		}
		File refDbUploadDir = new File(uploadDir + Constant.refDbDir);
		if (!refDbUploadDir.exists()) {
			FileUtils.forceMkdir(refDbUploadDir);
		}

		// logger.debug("Getting all files in " +
		// userUploadDir.getCanonicalPath() + "
		// including those in subdirectories");
		String[] userExtensions = userFileExt.substring(1, userFileExt.length()).replaceAll("\\,.", ",").split(Constant.separator);
		logger.debug("userExtensions:"+String.join(",", userExtensions));
		List<File> files = FileSort.fileSort((List<File>) FileUtils.listFiles(userUploadDir, userExtensions, false), true);
		/*
		 * for (File file : files) { logger.debug("file: " +
		 * file.getCanonicalPath() + file.getName()); }
		 */

		// logger.debug("Getting all files in " + dbUploadDir.getCanonicalPath()
		// + "
		// including those in subdirectories");
		String[] dbExtensions = dbExt.substring(1, dbExt.length()).replaceAll("\\,.", ",").split(Constant.separator);
		List<File> dbFiles = FileSort.fileSort((List<File>) FileUtils.listFiles(dbUploadDir, dbExtensions, false), true);
		/*
		 * for (File file : dbFiles) { logger.debug("file: " +
		 * file.getCanonicalPath() + file.getName()); }
		 */

		// logger.debug("Getting all files in " + dbUploadDir.getCanonicalPath()
		// + "
		// including those in subdirectories");
		String[] refDbExtensions = dbExt.substring(1, dbExt.length()).replaceAll("\\,.", ",").split(Constant.separator);
		List<File> refDbFiles = FileSort.fileSort((List<File>) FileUtils.listFiles(refDbUploadDir, refDbExtensions, false), true);		
		List<String> refDbFileNames = new ArrayList<>();
		for(File file : refDbFiles) {
			refDbFileNames.add(file.getName());
		}
		
		File[] refDbSubDirectories = refDbUploadDir.listFiles(new FileFilter() {
			@Override
			public boolean accept(File file) {
				return file.isDirectory();
			}
		});
		for(File file : refDbSubDirectories) {
			refDbFileNames.add(file.getName() + File.separator + "genome");
		}
		
		/*
		 * for (File file : refDbFiles) { logger.debug("file: " +
		 * file.getCanonicalPath() + file.getName()); }
		 */

		model.addAttribute("fileList", files);
		model.addAttribute("dbFileList", dbFiles);
		model.addAttribute("refDbFileNameList", refDbFileNames);
		model.addAttribute("ynSimulate", ynSimulate);
		model.addAttribute("noJob", noJob);

		model.addAttribute("fileKey", Aes256Encrypt.aesEncode(Constant.hashKey + noUser));

		return "helix/index";
	}

	/**
	 * single job list
	 * 
	 * @param model
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "/api/jobList")
	public @ResponseBody String jobList(ModelMap model, @ModelAttribute("singleJobInfo") SingleJobInfo singleJobInfo, HttpServletRequest request) throws IOException {
		HelixUser helixUser = HelixUser.getUserSession();
		String noUser = helixUser.getNouser();
		String referer = new URI(request.getHeader("referer")).getPath();
		logger.debug("referer:" + referer);
		if (referer.matches(".*singleJob") || referer.matches(".*simulate")) {
			singleJobInfo.setNoUser(noUser);
		} else {
			singleJobInfo.setYnPublic(Constant.Y);
		}
		List<SingleJobInfo> jobList = helixService.singleJobList(singleJobInfo);
		String jsonList = null;
		ObjectMapper mapper = new ObjectMapper();
		try {
			jsonList = mapper.writeValueAsString(jobList);
		} catch (Exception e) {
			logger.debug("first() mapper   ::    " + e.getMessage());
		}
		// logger.debug("jsonList:"+jsonList);

		return jsonList;
	}

	/**
	 * job request list
	 * 
	 * @param model
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "/api/jobRequestList")
	public @ResponseBody String jobRequestHistList(ModelMap model, @RequestParam(value = "ynSimulate", defaultValue = Constant.N, required = false) String ynSimulate,
			@RequestParam(value = "noJob", required = false) String noJob) throws IOException {
		HelixUser helixUser = HelixUser.getUserSession();
		String noUser = helixUser.getNouser();
		List<JobRequestHist> jobRequestHistList = helixService.jobRequestHistList(noUser, noJob, ynSimulate);
		String jsonJobRequestHistList = null;
		ObjectMapper mapper = new ObjectMapper();
		try {
			jsonJobRequestHistList = mapper.writeValueAsString(jobRequestHistList);
		} catch (Exception e) {
			logger.debug("first() mapper   ::    " + e.getMessage());
		}
		// logger.debug("jobRequestHistList:"+jsonJobRequestHistList);

		return jsonJobRequestHistList;
	}

	/**
	 * search result file list
	 * 
	 * @param noJob
	 * @param dtJobStart
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "/api/resultFileList")
	public @ResponseBody String resultFileList(@RequestParam(value = "noJob") String noJob, @RequestParam(value = "dtJobStart") String dtJobStart) throws IOException {
		HelixUser helixUser = HelixUser.getUserSession();
		String noUser = helixUser.getNouser();

		File userUploadDir = new File(uploadDir + Constant.userDir + noUser + Constant.fileSeprator + Constant.resultDir + Constant.fileSeprator + dtJobStart);
		logger.debug("Getting all files in " + userUploadDir.getCanonicalPath() + " including those in subdirectories");
		// String[] userExtensions = new String[] { "vcf","fasta", "fq", "txt"
		// };
		List<FileInfo> fileInfoList = new ArrayList<FileInfo>();
		// if directory is not exists
		if (!userUploadDir.exists()) {
			return mapper.writeValueAsString(fileInfoList);
		}
		List<File> files = (List<File>) FileUtils.listFiles(userUploadDir, null, true);
		int n = 1;
		for (File file : files) {
			// logger.debug("file: " + file.getCanonicalPath() +
			// file.getName());
			fileInfoList.add(new FileInfo(n++, dtJobStart, file.getName()));
		}

		String jsonResultFileList = null;
		ObjectMapper mapper = new ObjectMapper();
		try {
			jsonResultFileList = mapper.writeValueAsString(fileInfoList);
		} catch (Exception e) {
			logger.debug("first() mapper   ::    " + e.getMessage());
		}
		// logger.debug("jobRequestHistList:"+jsonResultFileList);

		return jsonResultFileList;
	}

	/**
	 * async job result update
	 * 
	 * @param requestParam
	 * @return
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/api/asyncResultUpdate")
	public ResponseEntity asyncResultUpdate(@ModelAttribute("jobRequestHist") JobRequestHist jobRequestHist) throws IOException {
		logger.debug("jobRequestHist:" + jobRequestHist);
		int nResult = helixService.txUpdateAsyncResult(jobRequestHist);
		if (nResult == 1) {
			return JsonReturn.jsonReturn(true, (Object) nResult, MessageUtil.getMessage("common.success"));
		} else {
			return JsonReturn.jsonReturn(false, (Object) nResult, MessageUtil.getMessage("common.error"));
		}
	}

	/**
	 * result file download
	 * 
	 * @param response
	 * @param dtJobStart
	 * @param nmFile
	 * @throws IOException
	 */
	@RequestMapping(value = "/download/{dtJobStart}/{nmFile:.+}", method = RequestMethod.GET)
	public void downloadFile(HttpServletResponse response, @PathVariable("dtJobStart") String dtJobStart, @PathVariable("nmFile") String nmFile) throws IOException {
		HelixUser helixUser = HelixUser.getUserSession();
		String noUser = helixUser.getNouser();

		logger.debug("nmFile:" + nmFile);
		File file = null;
		String filePath = uploadDir + Constant.userDir + noUser + Constant.fileSeprator + Constant.resultDir + dtJobStart + Constant.fileSeprator + nmFile;
		file = new File(filePath.replaceAll("[.][.]", ""));
		logger.debug("filePath:" + filePath.replaceAll("[.][.]", ""));

		if (!file.exists()) {
			String errorMessage = "Sorry. The file you are looking for does not exist";
			logger.debug(errorMessage);
			OutputStream outputStream = response.getOutputStream();
			outputStream.write(errorMessage.getBytes(Charset.forName("UTF-8")));
			outputStream.close();
			return;
		}

		String mimeType = URLConnection.guessContentTypeFromName(file.getName());
		if (mimeType == null) {
			logger.debug("mimetype is not detectable, will take default");
			mimeType = "application/octet-stream";
		}

		logger.debug("mimetype : " + mimeType);
		response.setContentType(mimeType);

		/*
		 * "Content-Disposition : inline" will show viewable types [like
		 * images/text/pdf/anything viewable by browser] right on browser while
		 * others(zip e.g) will be directly downloaded [may provide save as
		 * popup, based on your browser setting.]
		 */
		response.setHeader("Content-Disposition", String.format("attachment; filename=\"" + file.getName() + "\""));
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Content-Length", String.valueOf(file.length()));

		/*
		 * "Content-Disposition : attachment" will be directly download, may
		 * provide save as popup, based on your browser setting
		 */
		InputStream inputStream = new FileInputStream(file);
		FileCopyUtils.copy(inputStream, response.getOutputStream());
	}

	/**
	 * request docker job
	 * 
	 * @param requestParam
	 * @return
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/insert", method = RequestMethod.POST)
	public ResponseEntity insert(@ModelAttribute("jobRequestParam") JobRequestParam requestParam) throws IOException {
		logger.debug("insert:{}" + requestParam);
		List<SingleJobInfo> jobInfos = helixService.singleJobList(new SingleJobInfo(requestParam.getJobSelect()));
		if (jobInfos == null) {
			return JsonReturn.jsonReturn(false, "", MessageUtil.getMessage("singlejob.job.searchError"));
		}
		SingleJobInfo jobInfo = jobInfos.get(0);

		HelixUser helixUser = HelixUser.getUserSession();
		String noUser = helixUser.getNouser();
		requestParam.setNoUser(noUser);

		String dtJobStart = DateUtility.nowExt(DateUtility._YMD + DateUtility._HMS);

		String processJobName = "job_" + requestParam.getNoJob() + "_" + dtJobStart + RandomStringUtils.randomAlphanumeric(3);

		String userDir = uploadDir + (requestParam.getYnSimulate().equals(Constant.Y) ? Constant.sampleDir : Constant.userDir + noUser + Constant.fileSeprator + Constant.userFileDir);
		String resultDir = uploadDir + Constant.userDir + noUser + Constant.fileSeprator + Constant.resultDir + dtJobStart + Constant.fileSeprator;

		try {
			File fileResultDir = new File(resultDir);
			if (!fileResultDir.exists()) {
				FileUtils.forceMkdir(fileResultDir);
			}
		} catch (Exception e) {
			throw new RestApiException("Server Error Occur. Plz try again.");
		}

		String refDbDir = uploadDir + Constant.refDbDir;
		String dbDir = uploadDir + Constant.dbDir;
		logger.debug("refDbDir:" + refDbDir);
		logger.debug("dbDir:" + dbDir);
		logger.debug("userDir:" + userDir);
		logger.debug("resultDir:" + resultDir);

		String command_docker = Constant.commandDockerInit + requestParam.getArgument();
		logger.debug("docker_command INIT : " + command_docker);
		command_docker = command_docker.replace("[DB_DIR]", dbDir).replace("[REFDB_DIR]", refDbDir).replace("[USER_DIR]", userDir).replace("[RESULT_DIR]", resultDir)
				.replace("[DOCKER_REPO]", jobInfo.getIdDocker() + ":" + requestParam.getlastTag()).replace("[LABEL]", "jobName=" + processJobName);
		logger.debug("docker_command after DIR_INIT : " + command_docker);

		String resultOpt = "";
		if (requestParam.getResultArgument().equals("DIR")) {
			resultOpt = (Constant.fileSeprator + Constant.resultDir + Constant.logDirection + resultDir) + Constant.resultLogFile + " 2>&1";
		} else {
			String fileName = "";
			if ((requestParam.getUserDbSelect() != null && requestParam.getUserDbSelect().length > 0)) {
				//if (requestParam.getYnSimulate().equals(Constant.Y)) {
					// do not change input file name when simulate
					fileName = requestParam.getUserDbSelect()[0].substring(0, requestParam.getUserDbSelect()[0].lastIndexOf(".") + 1);
				//} else {
				//	fileName = requestParam.getUserDbSelect()[0].substring(requestParam.getUserDbSelect()[0].indexOf("_") + 1, requestParam.getUserDbSelect()[0].lastIndexOf(".") + 1);
				//}
			} else {
				fileName = requestParam.getUserDbSelect() + ".";
			}
			fileName += jobInfo.getOutputExt();

			if (jobInfo.getOutputArgument().equals("LOG")) {
				resultOpt = " 1> " + resultDir + fileName + " 2> " + resultDir + "_result_.log" ;
			} else {
				resultOpt = Constant.fileSeprator + Constant.resultDir + fileName + Constant.logDirection + resultDir + "_result_.log 2>&1";
			}
		}
		command_docker = command_docker.replace("[RESULT_OPT]", resultOpt);
		logger.debug("docker_command after result_opt : " + command_docker);

		// command_docker += " & ";

		// refdb option make
		int listIndex = 0;
		String refDbOpt = "";
		if (requestParam.getRefDbSelect() != null) {
			for (String str : requestParam.getRefDbSelect()) {
				if (!requestParam.getRefDbOptions().equals(Constant.separator)) {
					refDbOpt += StringUtils.defaultString(requestParam.getRefDbOption()[listIndex]) + " ";
				} else {
					refDbOpt += " ";
				}
				refDbOpt += "/refDb/" + StringUtils.defaultString(str) + " ";
				listIndex++;
			}
		}
		command_docker = command_docker.replace("[REFDB_OPT]", refDbOpt);
		logger.debug("docker_command after refDb_opt : " + command_docker);

		// db option make
		listIndex = 0;
		String dbOpt = "";
		if (requestParam.getDbSelect() != null) {
			for (String str : requestParam.getDbSelect()) {
				if (!requestParam.getDbOptions().equals(Constant.separator)) {
					dbOpt += StringUtils.defaultString(requestParam.getDbOption()[listIndex]) + " ";
				} else {
					dbOpt += " ";
				}
				dbOpt += "/db/" + StringUtils.defaultString(str) + " ";
				listIndex++;
			}
		}

		command_docker = command_docker.replace("[DB_OPT]", dbOpt);
		logger.debug("docker_command after db_opt : " + command_docker);

		// userdb option make
		listIndex = 0;
		String userDbOpt = "";
		if (requestParam.getUserDbSelect() != null) {
			for (String str : requestParam.getUserDbSelect()) {
				if (!requestParam.getUserDbOptions().equals(Constant.separator)) {
					dbOpt += StringUtils.defaultString(requestParam.getUserDbOption()[listIndex]);
				} else {
					dbOpt += " ";
				}
				userDbOpt += "/data/" + StringUtils.defaultString(str) + " ";
				listIndex++;
			}
		}

		command_docker = command_docker.replace("[USER_OPT]", userDbOpt);
		logger.debug("docker_command after userDb_opt : " + command_docker);

		JobRequestHist requestHist = new JobRequestHist(requestParam, dtJobStart, command_docker);
		int nResult = helixService.txInsert(requestHist);
		logger.debug("helixService.txInsert(requestHist):" + nResult);
		if (nResult == 1) {
			try {
				HashMap<String, String> mapParam = new HashMap<String, String>();
				mapParam.put(Constant.userAgent, Constant.mozilla);
				mapParam.put(Constant.jobRequestURL, System.getenv("HOSTIP") + asyncJobUrl + addJob);
				mapParam.put(Constant.commandDocker, command_docker);
				mapParam.put(Constant.noUserEnc, Aes256Encrypt.aesEncode(noUser));
				mapParam.put(Constant.dtJobStart, dtJobStart);
				mapParam.put(Constant.noJob, requestParam.getNoJob());
				mapParam.put(Constant.processJobName, processJobName);
				HttpSend.setHttpPost(mapParam);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				logger.debug("http send error : " + e.getMessage());
				return JsonReturn.jsonReturn(false, (Object) nResult, MessageUtil.getMessage("common.error"));
			}
			return JsonReturn.jsonReturn(true, (Object) nResult, MessageUtil.getMessage("user.insertSuccess"));
		} else {
			return JsonReturn.jsonReturn(false, (Object) nResult, MessageUtil.getMessage("common.error"));
		}
	}

	/**
	 * Docker Search from Docker Hub
	 * 
	 * @param strSearch
	 * @return
	 * @throws Exception
	 */
	boolean isCurlTest = false;

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/searchDocker", method = RequestMethod.POST)
	public ResponseEntity searchDocker(@RequestParam("q") String q, @RequestParam("page") String page) throws Exception {
		if (isCurlTest) {
			return JsonReturn.jsonReturn(true,
					"{\"count\":25679,\"next\":\"https://search-api.s.us-east-1.aws.dckr.io/v2/search/repositories/?page=2\\u0026query=centos\",\"previous\":\"\",\"results\":[{\"repo_name\":\"centos\",\"short_description\":\"The official build of CentOS.\",\"star_count\":3893,\"pull_count\":111839804,\"repo_owner\":\"\",\"is_automated\":false,\"is_official\":true},{\"repo_name\":\"openshift/base-centos7\",\"short_description\":\"A Centos7 derived base image for Source-To-Image builders\",\"star_count\":13,\"pull_count\":47258418,\"repo_owner\":\"\",\"is_automated\":false,\"is_official\":false},{\"repo_name\":\"pivotaldata/centos-gpdb-dev\",\"short_description\":\"CentOS image for GPDB development. Tag names often have GCC because we make flavors based on that\",\"star_count\":1,\"pull_count\":89743244,\"repo_owner\":\"\",\"is_automated\":false,\"is_official\":false},{\"repo_name\":\"jdeathe/centos-ssh\",\"short_description\":\"CentOS-6 6.9 x86_64 / CentOS-7 7.4.1708 x86_64 - SCL/EPEL/IUS Repos / Supervisor / OpenSSH.\",\"star_count\":90,\"pull_count\":2583700,\"repo_owner\":\"\",\"is_automated\":true,\"is_official\":false},{\"repo_name\":\"pivotaldata/centos\",\"short_description\":\"Base centos, freshened up a little with a Dockerfile action\",\"star_count\":0,\"pull_count\":6622563,\"repo_owner\":\"\",\"is_automated\":false,\"is_official\":false},{\"repo_name\":\"ansible/centos7-ansible\",\"short_description\":\"Ansible on Centos7\",\"star_count\":103,\"pull_count\":445385,\"repo_owner\":\"\",\"is_automated\":true,\"is_official\":false},{\"repo_name\":\"kinogmt/centos-ssh\",\"short_description\":\"CentOS with SSH\",\"star_count\":18,\"pull_count\":1472389,\"repo_owner\":\"\",\"is_automated\":true,\"is_official\":false},{\"repo_name\":\"pivotaldata/centos-mingw\",\"short_description\":\"Using the mingw toolchain to cross-compile to Windows from CentOS\",\"star_count\":1,\"pull_count\":15756680,\"repo_owner\":\"\",\"is_automated\":false,\"is_official\":false},{\"repo_name\":\"smartentry/centos\",\"short_description\":\"centos with smartentry\",\"star_count\":0,\"pull_count\":234689,\"repo_owner\":\"\",\"is_automated\":true,\"is_official\":false},{\"repo_name\":\"tutum/centos\",\"short_description\":\"Simple CentOS docker image with SSH access\",\"star_count\":34,\"pull_count\":4107596,\"repo_owner\":\"\",\"is_automated\":false,\"is_official\":false}]}\n",
					MessageUtil.getMessage("common.success"));
		}

		// String urlParameter = "?page="+URLEncoder.encode(page, "UTF-8") +
		// "&query=" +
		// URLEncoder.encode(q, "UTF-8");
		String urlParameter = "?page=" + page + "&query=" + q;

		/*
		 * if(select.equals("d")) { urlParameter +=
		 * "&isAutomated=0&isOfficial=0&pullCount=1&starCount=0";
		 * 
		 * }else if(select.equals("s")) { urlParameter +=
		 * "&isAutomated=0&isOfficial=0&pullCount=0&starCount=1"; }else
		 * if(select.equals("o")) { urlParameter +=
		 * "&isAutomated=0&isOfficial=1&pullCount=0&starCount=0"; }
		 */

		logger.debug("urlParameter:" + urlParameter);
		String result = CurlRequest.getDockerInfo(true, urlParameter);
		return JsonReturn.jsonReturn(true, result, MessageUtil.getMessage("common.success"));
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/searchDockerTag", method = RequestMethod.POST)
	public ResponseEntity searchDocker(@RequestParam("idDocker") String idDocker) throws Exception {
		String strDockerTags = CurlRequest.getDockerInfo(false, idDocker);
		List<String> dockerTagList = new ArrayList<>();;

		if (!StringUtils.isEmpty(strDockerTags)) {
			try {
				ObjectMapper mapper = new ObjectMapper();
				Map<String, Object> map = new HashMap<String, Object>();

				// convert JSON string to Map
				map = mapper.readValue(strDockerTags, new TypeReference<Map<String, Object>>() {
				});

				int nCount = (int) map.get("count");
				System.out.println(nCount);

				List<HashMap<String, Object>> mapList = (ArrayList) map.get("results");
				for (HashMap tmpMap : mapList) {
					System.out.println(tmpMap.get("name"));
					dockerTagList.add((String) tmpMap.get("name"));
				}

			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return JsonReturn.jsonReturn(true, dockerTagList, MessageUtil.getMessage("common.success"));
	}

	/**
	 * single job form
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/singleJob")
	public String singleJobWrite(ModelMap model) throws Exception {
		logger.debug("/web/helix");

		File dbUploadDir = new File(uploadDir + Constant.dbDir);
		if (!dbUploadDir.exists()) {
			FileUtils.forceMkdir(dbUploadDir);
		}
		File refDbUploadDir = new File(uploadDir + Constant.refDbDir);
		if (!refDbUploadDir.exists()) {
			FileUtils.forceMkdir(refDbUploadDir);
		}

		// logger.debug("Getting all files in " + dbUploadDir.getCanonicalPath()
		// + "
		// including those in subdirectories");
		String[] dbExtensions = dbExt.substring(1, dbExt.length()).replaceAll("\\,.", ",").split(Constant.separator);
		List<File> dbFiles = FileSort.fileSort((List<File>) FileUtils.listFiles(dbUploadDir, dbExtensions, false), true);
		/*
		 * for (File file : dbFiles) { logger.debug("file: " +
		 * file.getCanonicalPath() + file.getName()); }
		 */

		// logger.debug("Getting all files in " + dbUploadDir.getCanonicalPath()
		// + "
		// including those in subdirectories");
		String[] refDbExtensions = dbExt.substring(1, dbExt.length()).replaceAll("\\,.", ",").split(Constant.separator);
		List<File> refDbFiles = FileSort.fileSort((List<File>) FileUtils.listFiles(refDbUploadDir, refDbExtensions, false), true);
		List<String> refDbFileNames = new ArrayList<>();
		for(File file : refDbFiles) {
			refDbFileNames.add(file.getName());
		}
		
		File[] refDbSubDirectories = refDbUploadDir.listFiles(new FileFilter() {
			@Override
			public boolean accept(File file) {
				return file.isDirectory();
			}
		});
		for(File file : refDbSubDirectories) {
			refDbFileNames.add(file.getName() + File.separator + "genome");
		}		
		/*
		 * for (File file : refDbFiles) { logger.debug("file: " +
		 * file.getCanonicalPath() + file.getName()); }
		 */

		model.addAttribute("dbFileList", dbFiles);
		model.addAttribute("refDbFileNameList", refDbFileNames);
		return "helix/singleJob";
	}

	/**
	 * SingleJob Insert
	 * 
	 * @param request
	 * @param singleJobInfo
	 * @param mode
	 * @return
	 * @throws Exception
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/insertSingleJob")
	public ResponseEntity insertSingleJob(HttpServletRequest request, @ModelAttribute("singleJobInfo") SingleJobInfo singleJobInfo, @RequestParam(value = "mode") String mode)
			throws IOException, Exception {
		HelixUser helixUser = HelixUser.getUserSession();
		String noUser = helixUser.getNouser();
		singleJobInfo.setNoUser(noUser);
		if (!request.isUserInRole("ROLE_ADMIN") && !request.isUserInRole("ROLE_MANAGER")) {
			singleJobInfo.setYnPublic("");
		}
		logger.debug("singleJobInfo:" + singleJobInfo);

		// get docker tag info
		String strDockerTags = CurlRequest.getDockerInfo(false, singleJobInfo.getIdDocker());

		if (helixService.txInsertSingleJob(mode, singleJobInfo) == 1)
			return JsonReturn.jsonReturn(true, "", MessageUtil.getMessage("common.success"));
		else
			return JsonReturn.jsonReturn(false, "", MessageUtil.getMessage("common.error"));
	}

	/**
	 * SingleJob simulate after insert/update
	 * 
	 * @param redirectAttributes
	 * @param noJob
	 * @return
	 */
	@RequestMapping(value = "/simulate")
	public String simulate(RedirectAttributes redirectAttributes, @RequestParam(value = "noJob", required = true) String noJob) {
		redirectAttributes.addAttribute("ynSimulate", Constant.Y);
		redirectAttributes.addAttribute("noJob", noJob);
		return "redirect:/web/helix/sim";
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/requestDb")
	public ResponseEntity requestDb(HttpServletRequest request, @ModelAttribute("requestDb") RequestDb requestDb) {
		HelixUser helixUser = HelixUser.getUserSession();
		String noUser = helixUser.getNouser();
		requestDb.setNoUser(noUser);

		if (helixService.txInsertRequestDb(requestDb) == 1)
			return JsonReturn.jsonReturn(true, "", MessageUtil.getMessage("common.success"));
		else
			return JsonReturn.jsonReturn(false, "", MessageUtil.getMessage("common.error"));
	}

	@RequestMapping(value = "/myFile")
	public String myFile(ModelMap model) throws IOException {
		HelixUser helixUser = HelixUser.getUserSession();
		String noUser = helixUser.getNouser();

		logger.debug("/web/helix");
		logger.debug("uploadUrl:" + uploadDir + Constant.userDir + noUser + Constant.fileSeprator + Constant.userFileDir);

		model.addAttribute("fileKey", Aes256Encrypt.aesEncode(Constant.hashKey + noUser));

		return "helix/myFile";
	}

	@RequestMapping(value = "/api/myFileList")
	public @ResponseBody String myFileList() throws IOException {
		HelixUser helixUser = HelixUser.getUserSession();
		String noUser = helixUser.getNouser();
		String dirUser = uploadDir + Constant.userDir + noUser + Constant.fileSeprator;
		File userDir = new File(dirUser);
		if (!userDir.exists()) {
			FileUtils.forceMkdir(userDir);
		}

		File userUploadDir = new File((dirUser + Constant.userFileDir));
		if (!userUploadDir.exists()) {
			FileUtils.forceMkdir(userUploadDir);
		}
		String[] userExtensions = userFileExt.substring(1, userFileExt.length()).replaceAll("\\,.", ",").split(Constant.separator);
		List<File> files = FileSort.fileSort((List<File>) FileUtils.listFiles(userUploadDir, userExtensions, false), true);

		File userUploadTmpDir = new File((dirUser + Constant.userFileDir + Constant.fileSeprator + Constant.tempDir));
		if (!userUploadTmpDir.exists()) {
			FileUtils.forceMkdir(userUploadTmpDir);
		}
		List<File> tmpFiles = FileSort.fileSort((List<File>) FileUtils.listFiles(userUploadTmpDir, userExtensions, false), true);

		HashMap<String, List<String>> map = new HashMap<>();
		List<String> filesNames = new ArrayList<>();
		for (File tmpFile : files) {
			filesNames.add(tmpFile.getName());
		}
		List<String> tmpFilesNames = new ArrayList<>();
		for (File tmpFile : tmpFiles) {
			tmpFilesNames.add(tmpFile.getName());
		}
		map.put("fileList", filesNames);
		map.put("fileTmpList", tmpFilesNames);

		String jsonList = null;
		ObjectMapper mapper = new ObjectMapper();
		try {
			jsonList = mapper.writeValueAsString(map);
		} catch (Exception e) {
			logger.debug("first() mapper   ::    " + e.getMessage());
		}

		logger.debug("jsonList:" + jsonList);
		return jsonList;
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/api/myFileUpdate")
	public ResponseEntity myFileUpdate(@RequestParam(value = "fileActives") String fileActives, @RequestParam(value = "fileTemps") String fileTemps) throws IOException {
		HelixUser helixUser = HelixUser.getUserSession();
		String noUser = helixUser.getNouser();

		if (StringUtils.isEmpty(fileActives) && StringUtils.isEmpty(fileTemps)) {
			return JsonReturn.jsonReturn(false, "", MessageUtil.getMessage("common.error"));
		} else if (fileActives.indexOf("..") > 0 || fileTemps.indexOf("..") > 0) {
			return JsonReturn.jsonReturn(false, "", MessageUtil.getMessage("common.error"));
		}

		String[] arrFileActives = fileActives.split(Constant.separator);
		String[] arrFileTemps = fileTemps.split(Constant.separator);

		// folder check
		File userUploadDir = new File((uploadDir + Constant.userDir + noUser + Constant.fileSeprator + Constant.userFileDir));
		if (!userUploadDir.exists()) {
			FileUtils.forceMkdir(userUploadDir);
		}
		File userUploadTempDir = new File((uploadDir + Constant.userDir + noUser + Constant.fileSeprator + Constant.userFileDir + Constant.tempDir));
		if (!userUploadTempDir.exists()) {
			FileUtils.forceMkdir(userUploadTempDir);
		}
		File userUploadTempDelDir = new File((uploadDir + Constant.userDir + noUser + Constant.fileSeprator + Constant.userFileDir + Constant.tempDelDir));
		if (!userUploadTempDelDir.exists()) {
			FileUtils.forceMkdir(userUploadTempDelDir);
		}

		// file exist check
		for (String fileNm : arrFileActives) {
			if (fileNm.length() > 0 && !(new File(userUploadDir.getAbsolutePath() + File.separator + fileNm.substring(0, fileNm.length() - 3))).exists()) {
				logger.debug(userUploadDir.getAbsolutePath() + File.separator + fileNm.substring(0, fileNm.length() - 3));
				return JsonReturn.jsonReturn(false, "", MessageUtil.getMessage("common.error"));
			}
		}
		for (String fileNm : arrFileTemps) {
			if (fileNm.length() > 0 && !(new File(userUploadDir.getAbsolutePath() + File.separator + Constant.tempDir + fileNm.substring(0, fileNm.length() - 3))).exists()) {
				logger.debug(userUploadDir.getAbsolutePath() + File.separator + Constant.tempDir + fileNm.substring(0, fileNm.length() - 3));
				return JsonReturn.jsonReturn(false, "", MessageUtil.getMessage("common.error"));
			}
		}

		// file is all exist, start work
		for (String fileNm : arrFileActives) {
			if (fileNm.indexOf("[+]") == fileNm.length() - 3) {
				logger.debug("move file to tmp dir");
				logger.debug(userUploadDir.getAbsolutePath() + File.separator + fileNm.substring(0, fileNm.length() - 3));
				FileUtils.moveFile((new File(userUploadDir.getAbsolutePath() + File.separator + fileNm.substring(0, fileNm.length() - 3))),
						(new File(userUploadDir.getAbsolutePath() + File.separator + Constant.tempDir + fileNm.substring(0, fileNm.length() - 3))));
			} else if (fileNm.indexOf("[-]") == fileNm.length() - 3) {
				logger.debug("del file");
				logger.debug(userUploadDir.getAbsolutePath() + File.separator + fileNm.substring(0, fileNm.length() - 3));
				logger.debug(userUploadDir.getAbsolutePath() + File.separator + fileNm.substring(0, fileNm.length() - 3));
				FileUtils.moveFile((new File(userUploadDir.getAbsolutePath() + File.separator + fileNm.substring(0, fileNm.length() - 3))),
						(new File(userUploadDir.getAbsolutePath() + File.separator + Constant.tempDelDir + fileNm.substring(0, fileNm.length() - 3))));
			}
		}
		for (String fileNm : arrFileTemps) {
			if (fileNm.indexOf("[+]") == fileNm.length() - 3) {
				logger.debug("move file to active dir");
				logger.debug(userUploadDir.getAbsolutePath() + File.separator + fileNm.substring(0, fileNm.length() - 3));
				FileUtils.moveFile((new File(userUploadDir.getAbsolutePath() + File.separator + Constant.tempDir + fileNm.substring(0, fileNm.length() - 3))),
						(new File(userUploadDir.getAbsolutePath() + File.separator + fileNm.substring(0, fileNm.length() - 3))));
			} else if (fileNm.indexOf("[-]") == fileNm.length() - 3) {
				logger.debug("move file to tmpDel");
				logger.debug(userUploadDir.getAbsolutePath() + File.separator + fileNm.substring(0, fileNm.length() - 3));
				FileUtils.moveFile((new File(userUploadDir.getAbsolutePath() + File.separator + Constant.tempDir + fileNm.substring(0, fileNm.length() - 3))),
						(new File(userUploadDir.getAbsolutePath() + File.separator + Constant.tempDelDir + fileNm.substring(0, fileNm.length() - 3))));
			}
		}
		// delete tmpDel

		return JsonReturn.jsonReturn(true, "", MessageUtil.getMessage("common.success"));
	}

	@RequestMapping(value = "/manual")
	public String manual() throws IOException {
		return "helix/manual";
	}
}
