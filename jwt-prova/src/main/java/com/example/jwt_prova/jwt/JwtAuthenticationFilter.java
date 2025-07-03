package com.example.jwt_prova.jwt;

import com.example.jwt_prova.services.CustomUserDetailsService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final CustomUserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain)
            throws ServletException, IOException {
        final String authHeader = request.getHeader("Authorization");

        if(authHeader == null || !authHeader.startsWith("Bearer ")){
            chain.doFilter(request, response);
            return;
        }
        final String jwt = authHeader.substring(7);
        final String username = jwtService.extractUsername(jwt);

        //se lo username esiste ed è valido e nessun utente è autenticato
        if(username != null && SecurityContextHolder.getContext().getAuthentication() == null){
            var userDetails = userDetailsService.loadUserByUsername(username);
            if(jwtService.isValid(jwt, userDetails)){
                //istanza: rappresenta utente autenticato
                var auth = new UsernamePasswordAuthenticationToken(username, null, userDetails.getAuthorities());
                //aggiunti altri dettagli (es. indirizzo ip)
                auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                //imposta l'autenticazione nel contesto di spring security
                SecurityContextHolder.getContext().setAuthentication(auth);
            }
            chain.doFilter(request, response);

        }
    }
}
