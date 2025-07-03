package com.example.jwt_prova.dto;

import lombok.Data;

@Data
public class LoginRequest {
    private String username;
    private String password;
}
