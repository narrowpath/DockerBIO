package com.mygenomebox.www.user.service;

import java.util.ArrayList;

import com.mygenomebox.www.common.entity.UserLoginVO;
import com.mygenomebox.www.user.entity.User;

/**
 * @author jason.kim
 *
 */
public interface UserService {
	/**
	 * getUserById
	 * 
	 * @param id
	 * @return User
	 */
	public User getUserById(String id);

	public String txInsert(User user);

	public ArrayList<User> list();

	public String getPassword(String password);

	public UserLoginVO getUserByUsername(String s);
	
	public int loginSuccess(String s);
}
