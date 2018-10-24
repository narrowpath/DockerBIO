package com.mygenomebox.www.helix.entity;

import java.io.Serializable;

import lombok.Data;

/**
 * @author jason.kim
 *
 */

@Data
public class RequestDb implements Serializable {
    private static final long serialVersionUID = -5724658660363902236L;

    public RequestDb() {
	super();
    }

    private String noUser;
    private String email;
    private String dbType;
    private String dbUrl;
    private String desc;
    private String dtRequest;
    private String ynAccept;
    private String descAccept;
    private String dtAccept;
    private String noUserAccept;
}