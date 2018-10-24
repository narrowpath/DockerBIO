package com.mygenomebox.www.user.web;

import java.io.IOException;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mygenomebox.www.common.config.spring.HelixUser;
import com.mygenomebox.www.common.util.JsonReturn;
import com.mygenomebox.www.common.util.MessageUtil;
import com.mygenomebox.www.user.entity.User;
import com.mygenomebox.www.user.service.UserService;

/**
 * @author jason.kim
 *
 */
@Controller
public class AuthController {
	private static final Logger logger = Logger.getLogger(AuthController.class);

	@Resource(name = "userService")
	private UserService userServices;

	@RequestMapping(value = { "/", "/web/home" }, method = RequestMethod.GET)
	public String home(ModelMap model) {
		logger.debug("path:");
		model.addAttribute("greeting", "Hi, Welcome to mysite. ");
		return "index";
	}

	@RequestMapping(value = "/web/admin", method = RequestMethod.GET)
	public String admin(ModelMap model) {
		return "admin";
	}

	@RequestMapping(value = "/web/manager", method = RequestMethod.GET)
	public String manager(ModelMap model) {
		return "manager";
	}

	@RequestMapping(value = "/web/login/login", method = RequestMethod.GET)
	public String login(ModelMap model) throws Exception {
		try {
			HelixUser helixUser = HelixUser.getUserSession();
			if (!StringUtils.isEmpty(helixUser.getNouser())) {
				logger.debug("noUser:" + helixUser.getNouser());
				return "redirect:/web/helix/";
			}
		} catch (Exception e) {
			// TODO: handle exception
		}

		return "login/login";
	}

	@RequestMapping(value = "/web/loginCheck", method = RequestMethod.POST)
	public @ResponseBody String loginCheck(ModelMap model) throws IOException {
		ObjectMapper mapper = new ObjectMapper();
		HelixUser helixUser = HelixUser.getUserSession();
		if (!StringUtils.isEmpty(helixUser.getNouser())) {
			logger.debug("noUser:" + helixUser.getNouser());
			return mapper.writeValueAsString(helixUser.getUsername());
		} else {
			throw new org.springframework.security.access.AccessDeniedException("403 returned");
		}
	}

	@RequestMapping(value = "/web/login/join", method = RequestMethod.GET)
	public String join() {
		try {
			HelixUser helixUser = HelixUser.getUserSession();
			if (!StringUtils.isEmpty(helixUser.getNouser())) {
				logger.debug("noUser:" + helixUser.getNouser());
				return "redirect:/web/helix/";
			}
		} catch (Exception e) {
			// TODO: handle exception
		}

		logger.debug("common.success:" + MessageUtil.getMessage("common.success"));
		return "login/join";
	}

	@RequestMapping(value = "/web/login/logout", method = RequestMethod.GET)
	public String logout(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			new SecurityContextLogoutHandler().logout(request, response, auth);
		}
		return "redirect:/";
	}

	@RequestMapping(value = "/web/changeLocale")
	public String changeLocale(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(required = false) String locale) {
		HttpSession session = request.getSession();
		Locale lo = null;

		// step. 파라메터에 따라서 로케일 생성, 기본은 KOREAN
		if (locale.matches("en")) {
			lo = Locale.ENGLISH;
		} else {
			lo = Locale.KOREAN;
		}

		// step. Locale을 새로 설정한다.
		// session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME,
		// lo);
		// step. 해당 컨트롤러에게 요청을 보낸 주소로 돌아간다.
		String redirectURL = "redirect:" + request.getHeader("referer");
		return redirectURL;
	}
	
	@RequestMapping(value = "/web/user/insert", method = RequestMethod.POST)
	public ResponseEntity joinProcess(@ModelAttribute("user") User user) {
		logger.debug("joinProcess:{}" + user);
		return JsonReturn.jsonReturn(true, (Object) userService.txInsert(user), MessageUtil.getMessage("user.insertSuccess"));
	}
}