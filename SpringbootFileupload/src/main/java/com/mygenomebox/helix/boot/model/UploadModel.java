package com.mygenomebox.helix.boot.model;

import java.util.Arrays;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class UploadModel {

    private String fileKey;
    private MultipartFile[] files;

    @Override
    public String toString() {
        return "UploadModel{" +
                "fileKey='" + fileKey + '\'' +
                ", files=" + Arrays.toString(files) +
                '}';
    }
}
