package com.mygenomebox.www.helix.entity;

import java.io.Serializable;

import lombok.Data;

/**
 * @author jason.kim
 *
 */

@Data
public class FileInfo implements Serializable {
	public FileInfo() {super();}
	public FileInfo(int no, String dtJobStart, String nmFile) {
		this.no=no;
		this.dtJobStart=dtJobStart;
		this.nmFile=nmFile;
	}
	
	private static final long serialVersionUID = -9157970799943708342L;
	private int no;
    private String dtJobStart;
    private String nmFile;
}