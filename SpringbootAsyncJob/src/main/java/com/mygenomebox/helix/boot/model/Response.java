package com.mygenomebox.helix.boot.model;

import lombok.Data;

@Data
public class Response<T> {
    /** Boolean indicating if request succeeded **/
    private boolean status;

    /** Message indicating error if any **/
    private String message;

    /** Additional data that is part of this response **/
    private T data;

    public Response(boolean status, String message, T data) {
        this.status = status;
        this.message = message;
        this.data = data;
    }
}