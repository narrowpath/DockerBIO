package com.mygenomebox.www.common.config.spring;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.mygenomebox.www.user.service.UserService;

public class CustomPasswordEncoder implements PasswordEncoder {
	private static final Logger logger = Logger.getLogger(CustomUserDetailsService.class);
	
	@Autowired
	private UserService userService;

	@Override
	public String encode(CharSequence rawPassword) {
		logger.debug("pass:"+rawPassword.toString());
		logger.debug("pass hash:"+userService.getPassword(rawPassword.toString()));
		return userService.getPassword(rawPassword.toString());
	}

	@Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
		logger.debug("pass:"+rawPassword.toString());
		logger.debug("encodedPassword:"+encodedPassword);
        return StringUtils.equals(userService.getPassword(rawPassword.toString()), encodedPassword);
    }
}