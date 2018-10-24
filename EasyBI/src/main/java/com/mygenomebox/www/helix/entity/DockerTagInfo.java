package com.mygenomebox.www.helix.entity;

import java.io.Serializable;

import com.mygenomebox.www.common.util.Constant;

import lombok.Data;

/**
 * @author jason.kim
 *
 */

@Data
public class DockerTagInfo implements Serializable {
    public DockerTagInfo() {
	super();
    }
    
    public DockerTagInfo(String idDocker, String noUser, String tag) {
	this.idDocker = idDocker;
	this.noUser = noUser;
	this.tag = tag;
	this.ynLast = Constant.LATEST.equals(tag)?Constant.Y:Constant.N;
	
    }
    
    private static final long serialVersionUID = 7186429444307676549L;
    private String idDocker;
    private String noUser;
    private String tag;
    private String dtReg;
    private String tagStat;
    private String ynLast;
    
    
}