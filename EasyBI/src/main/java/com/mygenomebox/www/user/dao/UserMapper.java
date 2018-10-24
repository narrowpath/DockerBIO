package com.mygenomebox.www.user.dao;

import java.util.ArrayList;

import com.mygenomebox.www.common.config.ibatis.MyBatisDao;
import com.mygenomebox.www.common.entity.UserLoginVO;
import com.mygenomebox.www.user.entity.User;

/**
 * @author jason.kim
 *
 */
@MyBatisDao
public interface UserMapper {
    /**
     * getUserByUsername
     * 
     * @param username
     * @return
     */
    UserLoginVO getUserByUsername(String username);

	/**
	 * @param s
	 * @return password
	 */
	String getPassword(String s);
	
    /**
     * deleteByPrimaryKey
     * 
     * @param id
     * @return
     */
    int deleteByPrimaryKey(Long id);

    /**
     * insert
     * 
     * @param record
     * @return
     */
    int insert(User record);

    /**
     * insertSelective
     * 
     * @param record
     * @return
     */
    int insertSelective(User record);

    /**
     * selectByPrimaryKey
     * 
     * @param id
     * @return
     */
    User selectByPrimaryKey(String id);

    /**
     * updateByPrimaryKeySelective
     * 
     * @param record
     * @return
     */
    int updateByPrimaryKeySelective(User record);

    /**
     * updateByPrimaryKey
     * 
     * @param record
     * @return
     */
    int updateByPrimaryKey(User record);

    ArrayList<User> list();

    /**
     * @param email
     * @return
     */
    int insertOauth(String email);

	/**
	 * login datetime update
	 * @param s 
	 * @return
	 */
	int loginSuccess(String s);
}