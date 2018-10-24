package com.mygenomebox.www.helix.web;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mygenomebox.www.common.util.MessageUtil;
import com.mygenomebox.www.exception.RestApiException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@ControllerAdvice
public class ExceptionController {
    private static final Logger logger = Logger.getLogger(ExceptionController.class);
    
    @RequestMapping(value = "/web/error/404", method = RequestMethod.GET)
    public String error404(ModelMap model) {
	return "error/404";
    }

    @RequestMapping(value = "/web/error/403", method = RequestMethod.GET)
    public String error403(ModelMap model) {
	return "error/403";
    }

    @RequestMapping(value = "/web/error/500", method = RequestMethod.GET)
    public String error500(ModelMap model) {
	return "error/500";
    }

    /**
     * @Method Name : restApiHandle
     * @작성일 : 2016. 6. 24.
     * @작성자 : "choi.kangyong"
     * @Method 설명 : REST API Exception(런타임)을 받아서 json으로 응답처리한다.
     * @param e
     * @return
     */
    @ExceptionHandler(RestApiException.class)
    @ResponseBody
    public Map<String, String> restApiHandle(RestApiException e) {
	log.debug("Rest API Exception :: " + e.getMessage());
	Map<String, String> map = new HashMap<>();
	map.put("result", "fail");
	map.put("message", e.getMessage());
	return map;
    }
    
    @ExceptionHandler({SQLException.class})
    @ResponseBody
    public Map<String, String> sqlHandler(SQLException e) throws Exception {
	log.debug("sqlHandler Exception :: " + e.getMessage());
	return restApiHandle(new RestApiException(MessageUtil.getMessage("common.error")));
    }
}
