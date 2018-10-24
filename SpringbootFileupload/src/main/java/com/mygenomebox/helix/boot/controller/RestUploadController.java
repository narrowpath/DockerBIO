package com.mygenomebox.helix.boot.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import com.mygenomebox.helix.boot.model.Response;
import com.mygenomebox.helix.boot.model.UploadModel;
import com.mygenomebox.www.common.util.Aes256Encrypt;
import com.mygenomebox.www.common.util.Constant;
import com.mygenomebox.www.common.util.DateUtility;

@RestController
@PropertySource("config.properties")
public class RestUploadController {

	private final Logger logger = LoggerFactory.getLogger(RestUploadController.class);

	// Save the uploaded file to this folder
	@Value("${user.upload.dir}")
	private String uploadDir;

	@Configuration
	@EnableWebMvc
	public class WebConfig extends WebMvcConfigurerAdapter {

		@Override
		public void addCorsMappings(CorsRegistry registry) {
			registry.addMapping("/**");
		}
	}

	@PostMapping("/api/upload2")
	public @ResponseBody Response<String> upload(HttpServletRequest request) {
		logger.debug("/api/upload2");
		try {
			if (!ServletFileUpload.isMultipartContent(request)) {
				// Inform user about invalid request
				Response<String> responseObject = new Response<String>(false, "Not a multipart request.", "");
				return responseObject;
			}

			String saveTmpFileName = null, saveFileName = null, filename = null, fileKey = null, nouser = null,
					saveDirName = null;

			// configures upload settings
			DiskFileItemFactory factory = new DiskFileItemFactory();
			// sets memory threshold - beyond which files are stored in disk
			// factory.setSizeThreshold(MEMORY_THRESHOLD);
			// sets temporary location to store files
			// factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
			ServletFileUpload upload = new ServletFileUpload(factory);
			List<FileItem> items = upload.parseRequest(request);

			for (FileItem item : items) {
				if (item.isFormField()) {
					logger.debug("form:" + item.getFieldName() + ":" + item.getString());
					if (item.getFieldName().equals("fileKey")) {
						try {
							fileKey = item.getString();
							logger.debug("fileKey:" + fileKey);
							nouser = Aes256Encrypt.aesDecode(fileKey).replace(Constant.hashKey, "");
							logger.debug("fileKeyDec:" + nouser);
						} catch (Exception e) {
							return new Response<String>(false, "File upload error", e.toString());
						}
					}
				} else {
					filename = item.getName();
					InputStream filecontent = item.getInputStream();
					// Process the input stream
					saveTmpFileName = uploadDir + Constant.tempDir + filename;
					
					logger.debug("dir:" + saveTmpFileName);
					File saveTmpFile = new File(saveTmpFileName);
					java.nio.file.Files.copy(filecontent, saveTmpFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

					IOUtils.closeQuietly(filecontent);
					
					item.delete();
				}
			}

			File saveTmpFile = new File(saveTmpFileName);
			saveDirName = uploadDir + Constant.userDir + nouser + Constant.fileSeprator + Constant.userFileDir;
			saveFileName = saveDirName + filename;
			logger.debug("saveFileName:" + saveFileName + ",fileKey:" + fileKey + ",nouser:" + nouser);
			if (StringUtils.isEmpty(saveFileName) || StringUtils.isEmpty(fileKey) || StringUtils.isEmpty(nouser)) {
				saveTmpFile.delete();
				return new Response<String>(false, "File upload error - user info empty", "");
			}
			File saveDir = new File(saveDirName);
			if (!saveDir.exists()) {
				FileUtils.forceMkdir(saveDir);
			}
			if(new File(saveFileName).exists()) {
				int dotPoint = saveFileName.lastIndexOf(".");
				saveFileName = saveFileName.substring(0, dotPoint) + "_" + RandomStringUtils.random(2,true,true) + saveFileName.substring(dotPoint);
			}
			saveTmpFile.renameTo(new File(saveFileName));
		} catch (FileUploadException e) {
			return new Response<String>(false, "File upload error", e.toString());
		} catch (IOException e) {
			return new Response<String>(false, "Internal server IO error", e.toString());
		}

		return new Response<String>(true, "Success", "");
	}

	// Single file upload
	@PostMapping("/api/upload")
	// If not @RestController, uncomment this
	// @ResponseBody
	public ResponseEntity<?> uploadFile(@RequestParam("file") MultipartFile uploadfile) {

		logger.debug("Single file upload!");

		if (uploadfile.isEmpty()) {
			return new ResponseEntity("please select a file!", HttpStatus.OK);
		}

		try {

			saveUploadedFiles(Arrays.asList(uploadfile), uploadDir);

		} catch (IOException e) {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity("Successfully uploaded - " + uploadfile.getOriginalFilename(), new HttpHeaders(),
				HttpStatus.OK);

	}

	// Multiple file upload
	@PostMapping("/api/upload/multi")
	public ResponseEntity<?> uploadFileMulti(@RequestParam("fileKey") String extraField,
			@RequestParam("files") MultipartFile[] uploadfiles) {

		logger.debug("Multiple file upload!");

		String uploadedFileName = Arrays.stream(uploadfiles).map(x -> x.getOriginalFilename())
				.filter(x -> !StringUtils.isEmpty(x)).collect(Collectors.joining(" , "));

		if (StringUtils.isEmpty(uploadedFileName)) {
			return new ResponseEntity("please select a file!", HttpStatus.OK);
		}

		try {

			saveUploadedFiles(Arrays.asList(uploadfiles), uploadDir);

		} catch (IOException e) {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity("Successfully uploaded - " + uploadedFileName, HttpStatus.OK);

	}

	// maps html form to a Model
	@PostMapping("/api/upload/model")
	public ResponseEntity<?> multiUploadFileModel(@ModelAttribute UploadModel model) {

		logger.debug("Multiple file upload! With UploadModel");

		try {
			logger.debug("fileKey:" + model.getFileKey());
			String nouser = Aes256Encrypt.aesDecode(model.getFileKey());
			logger.debug("fileKeyDec:" + nouser);

			String saveFileName = uploadDir + Constant.tempDir + nouser + Constant.fileSeprator
					+ DateUtility.nowExt(DateUtility._YMD + DateUtility._HMS);
			logger.debug("saveFileName:" + saveFileName);

			saveUploadedFiles(Arrays.asList(model.getFiles()), saveFileName);

		} catch (IOException e) {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity("Successfully uploaded!", HttpStatus.OK);

	}

	// save file
	private void saveUploadedFiles(List<MultipartFile> files, String userFilePath) throws IOException {
		for (MultipartFile file : files) {

			if (file.isEmpty()) {
				continue; // next pls
			}

			byte[] bytes = file.getBytes();
			Path path = Paths.get(userFilePath + file.getOriginalFilename());
			logger.debug("saveUploadedFiles:" + path.toString());
			Files.write(path, bytes);

		}

	}
}
