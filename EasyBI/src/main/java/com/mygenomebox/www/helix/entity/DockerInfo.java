package com.mygenomebox.www.helix.entity;

import java.io.Serializable;

import lombok.Data;

/**
 * @author jason.kim
 *
 */

@Data
public class DockerInfo implements Serializable {
    private static final long serialVersionUID = -9172658979898223696L;
    private String idUser;
    private String idServer;
    private String nmDocker;
}