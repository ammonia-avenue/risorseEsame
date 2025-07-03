package com.example.jwt_prova.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api")
public class JwtController {

    @GetMapping("/hello")
    public String hello(){
        return "Hello";
    }

    @GetMapping("/authenticated")
    public String authenticated(){
        return "authenticated";
    }
}
