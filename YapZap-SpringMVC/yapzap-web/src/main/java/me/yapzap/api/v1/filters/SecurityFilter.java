package me.yapzap.api.v1.filters;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.FilterChain;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import me.yapzap.api.util.Logger;

import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.web.filter.DelegatingFilterProxy;

public class SecurityFilter extends DelegatingFilterProxy {

    private final MessageDigest md;
    private static final String authvalue = "yjhetgdjdfjfghjsagdghjfghjfghdghjerfareyjtuyjnbgcvbnsafdsf";
    private static final String authkey = "authentication";

    @SuppressWarnings("serial")
    private static final List<AuthUser> authorizedUsers = new ArrayList<AuthUser>() {
        {
            add(new SecurityFilter.AuthUser("B64E4F862CC37A8116783A02770E91CC08F08E42", "67989553EDCBD09B03942AB728CEC8FE5C7951F6"));
        }
    };
    

    @SuppressWarnings("serial")
    private static final Set<String> authorizedPaths = new HashSet<String>() {
        {
            add("/");
            add("/ping");
            add("/time");
            add("/app");
            add("/terms");
        }
    };

    private static class AuthUser {

        public final String key;
        public final String secret;

        public AuthUser(String key, String secret) {
            super();
            this.key = key;
            this.secret = secret;
        }
    }

    public SecurityFilter() throws NoSuchAlgorithmException {
        md = MessageDigest.getInstance("SHA-512");
    }

    private String getHash(String secret, String key, String t) {
        md.reset();
        String token = secret + key + t;
        try {
            md.update(token.getBytes("UTF-8"));
        }
        catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        return new String(Hex.encodeHex(md.digest()));
    }

    private boolean passesAuth(HttpServletRequest request) {
        String path = request.getRequestURI();
        if (authorizedPaths.contains(path) || 
                        (path!=null && path.length()>2 && path.substring(0, 3).equals("/a/"))||
                         (path!=null && path.length()>10 && path.substring(0, 11).equals("/resources/"))) {
            return true;
        }
        
        //Check for authed session
        HttpSession session = request.getSession();
        boolean isAuthed = session.getAttribute(authkey)!=null;
        if (isAuthed){
            return true;
        }
        
        //If no session, check tokens
        md.reset();

        String timeIn = request.getParameter("t");
        String key = request.getParameter("key");
        String token = request.getParameter("token");
        
        if (timeIn==null || key==null || token==null){
            return false;
        }
        
        for (AuthUser user : authorizedUsers){
            String hash = getHash(user.secret, user.key, timeIn);

            long t = (new Date()).getTime()/1000l;
            long timeInLong = Long.parseLong(timeIn);
            
            if (timeInLong!=timeInLong){
                return false;
            }

            if (hash.equals(token) && key.equals(user.key) && timeInLong-3e2<t && timeInLong+3e2>t){
                session.setAttribute(authkey, authvalue);
                return true;
            }
        }

        return false;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) {
        
        boolean passesAuth = false;
        
        try {
            passesAuth = passesAuth((HttpServletRequest) request);
        }
        catch(Throwable t){
            passesAuth = false;
        }

        if (passesAuth) {
            try {
                filterChain.doFilter(request, response);
            }
            catch (Exception e) {
                Logger.log(ExceptionUtils.getStackTrace(e));
            }
        }
        else {
            response.setContentType("text/html");
            try {
                response.getWriter().write("Unauthorized");
                response.flushBuffer();
            }
            catch (IOException e) {
                Logger.log(ExceptionUtils.getStackTrace(e));
            }
        }
    }

}
