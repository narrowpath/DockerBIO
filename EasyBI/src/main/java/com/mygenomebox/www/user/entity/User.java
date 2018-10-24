package com.mygenomebox.www.user.entity;

import java.io.Serializable;

import com.mygenomebox.www.common.config.spring.HelixUser;
import com.mygenomebox.www.common.util.PasswordUtil;

import lombok.Data;

/**
 * @author jason.kim
 *
 */

@Data
public class User implements Serializable {
    private static final long serialVersionUID = -7446610551895339474L;

    private String noUser;
    private String password;
    private String email;
    private String nmUser;
    private String auth;
    private String ynUse;
    private String dtJoin;
    private String dtOut;
    private String dtLogin;
    
    public User() {
    	super();
    }
    
    public String getPasswordEncrypt() {
    	return PasswordUtil.encode(password);
    }

	public User(HelixUser helixUser) {
		this.noUser = helixUser.getNouser();
		this.nmUser = helixUser.getUsername();
		this.password = "_auto_generate_";
		this.email = "_auto_generate_";
	}

}