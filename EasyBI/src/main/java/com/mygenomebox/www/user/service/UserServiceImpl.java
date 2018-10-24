package com.mygenomebox.www.user.service;

import java.util.ArrayList;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mygenomebox.www.common.entity.UserLoginVO;
import com.mygenomebox.www.common.util.MessageUtil;
import com.mygenomebox.www.exception.RestApiException;
import com.mygenomebox.www.user.dao.UserMapper;
import com.mygenomebox.www.user.entity.User;

/**
 * @author jason.kim
 *
 */
@Service("userService")
public class UserServiceImpl implements UserService {
	@Autowired
	private UserMapper userMapper;

	@Override
	public UserLoginVO getUserByUsername(String username) {
		return userMapper.getUserByUsername(username);
	}

	@Override
	public String getPassword(String s) {
		return userMapper.getPassword(s);
	}

	@Override
	public User getUserById(String id) {
		return userMapper.selectByPrimaryKey(id);
	}

	@Override
	public String txInsert(User user) {
		if (StringUtils.isEmpty(user.getEmail())) {
			throw new RestApiException(MessageUtil.getMessage("user.emailEmpty"));
		}

		if (StringUtils.isEmpty(user.getPassword())) {
			throw new RestApiException(MessageUtil.getMessage("user.usernameEmpty"));
		}

		if (StringUtils.isEmpty(user.getNmUser())) {
			throw new RestApiException(MessageUtil.getMessage("user.passwordEmpty"));
		}

		if (userMapper.insert(user) != 1) {
			throw new RestApiException(MessageUtil.getMessage("common.error"));
		}
		return MessageUtil.getMessage("user.insertSuccess");
	}

	@Override
	public ArrayList<User> list() {
		return userMapper.list();
	}

	@Override
	public int loginSuccess(String s) {
		return userMapper.loginSuccess(s);
	}

}
