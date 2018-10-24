package com.mygenomebox.test;

import org.apache.commons.lang3.RandomStringUtils;

public class Test {
	public static void main(String args[]) {
		String saveFileName = "test.stest.estst.com";
		System.out.println("saveFileName:"+saveFileName);
		int dotPoint = saveFileName.lastIndexOf(".");
		saveFileName = saveFileName.substring(0, dotPoint) + RandomStringUtils.random(2,true,true) + saveFileName.substring(dotPoint);
		System.out.println("saveFileName:"+saveFileName);
	}
}
