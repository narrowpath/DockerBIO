package com.mygenomebox.www.helix.web;

import java.io.IOException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mygenomebox.www.helix.entity.RequestDb;
import com.mygenomebox.www.helix.service.HelixService;

/**
 * @author jason.kim
 *
 */
@Component
@Controller
@RequestMapping("/web/adminTools")
public class AdminController {
    private static final Logger logger = Logger.getLogger(AdminController.class);

    @Resource(name = "helixService")
    private HelixService helixService;
    ObjectMapper mapper = new ObjectMapper();

    @Value("${config.upload.dir}")
    private String uploadDir;

    @Value("${config.asyncJob.url}")
    private String asyncJobUrl;

    @Value("${config.asyncJob.addJob}")
    private String addJob;

    /**
     * helix easy bi tool main page
     * Simulate too. When Simulate NoJob was required
     * 
     * @param model
     * @return
     * @throws IOException
     */
    @RequestMapping(value = { "", "/index", "/sim" })
    public String index(ModelMap model) throws IOException {

	return "admin/index";
    }
    
    @RequestMapping(value = "/requestDb")
    public String requestDb(ModelMap model) throws IOException {

	return "admin/requestDb";
    }
    
    @RequestMapping(value = "/api/requestDbList")
    public @ResponseBody String requestDbList(ModelMap model, @ModelAttribute("requestDb") RequestDb requestDb, HttpServletRequest request) throws IOException {
	List<RequestDb> jobList = helixService.requestDbList(requestDb);
	String jsonList = null;
	ObjectMapper mapper = new ObjectMapper();
	try {
	    jsonList = mapper.writeValueAsString(jobList);
	} catch (Exception e) {
	    logger.debug("first() mapper   ::    " + e.getMessage());
	}
	logger.debug("jsonList:"+jsonList);

	return jsonList;
    }
}
