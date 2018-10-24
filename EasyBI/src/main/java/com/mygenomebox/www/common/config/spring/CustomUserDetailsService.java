package com.mygenomebox.www.common.config.spring;

import java.util.ArrayList;
import java.util.Collection;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.mygenomebox.www.common.entity.UserLoginVO;
import com.mygenomebox.www.user.service.UserService;

@Service
public class CustomUserDetailsService implements UserDetailsService {
	private static final Logger logger = Logger.getLogger(CustomUserDetailsService.class);

	@Autowired
	private UserService userService;

	@Value("${project['config.adminId']}")
	private String adminId;

	static final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

	/*
	 * userDetailservice login process (non-Javadoc)
	 * 
	 * @see org.springframework.security.core.userdetails.UserDetailsService#
	 * loadUserByUsername(java.lang.String)
	 */
	@Override
	public UserDetails loadUserByUsername(String s) throws UsernameNotFoundException {
		UserLoginVO userLoginVO = userService.getUserByUsername(s);

		if (userLoginVO == null) {
			throw new UsernameNotFoundException("User details not found with this username: " + s);
		}

		String username = userLoginVO.getNmuser();
		String password = userLoginVO.getPassword();
		String nouser = userLoginVO.getNouser();
		String email = userLoginVO.getEmail();

		logger.debug("nouser:" + nouser);

		boolean enabled = true;
		boolean accountNonExpired = true;
		boolean credentialsNonExpired = true;
		boolean accountNonLocked = true;

		logger.debug("userLoginVO {} : " + userLoginVO);
		logger.debug("adminId : " + adminId);

		if (adminId.equals(email)) {
			userLoginVO.setAuthority(userLoginVO.getAuthority()+",ROLE_ADMIN");
		}

		Collection<GrantedAuthority> authList = new ArrayList<>();
		for (String authority : userLoginVO.getAuthority().split(",")) {
			logger.debug("authority:" + authority);
			authList.add(new SimpleGrantedAuthority(authority));
		}

		return new HelixUser(username, password, enabled, accountNonExpired, credentialsNonExpired, accountNonLocked,
				authList, nouser);
	}
}