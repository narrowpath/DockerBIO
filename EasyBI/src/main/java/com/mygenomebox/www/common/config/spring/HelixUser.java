package com.mygenomebox.www.common.config.spring;

import java.util.Collection;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;

import lombok.Data;

@Data
public class HelixUser extends org.springframework.security.core.userdetails.User {
    private static final long serialVersionUID = -486190850656565515L;
    // Declare all custom attributes here
    private String nouser;
 
    public HelixUser(String username, String password, boolean enabled, boolean accountNonExpired,
                      boolean credentialsNonExpired, boolean accountNonLocked,
                      Collection<GrantedAuthority> authorities, String nouser) {
        super(username, password, enabled, accountNonExpired, credentialsNonExpired,
                accountNonLocked, authorities);
 
        // Initialize all the custom attributes here like the following.
        this.nouser = nouser;
    }
    
    public static HelixUser getUserSession() {
    	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		HelixUser helixUser = (HelixUser) auth.getPrincipal();
		return helixUser;
    }
}