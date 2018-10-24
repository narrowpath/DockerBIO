package com.mygenomebox.www.common.entity;

import lombok.Data;

/**
 * @author jason.kim
 *
 */
@Data
public class UserLoginVO {
	private String nmuser;				
	private String password;				
	private String email;				
	private String authority;
	private String enabled;
	private String nouser;				
}
