package me.yapzap.api.v1.filters;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import me.yapzap.api.util.Logger;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.web.filter.DelegatingFilterProxy;

public class SecurityFilter extends DelegatingFilterProxy {

    public boolean passesAuth(HttpServletRequest request) {
        
        //TODO: copy auth over from node
        
        String path = request.getPathInfo();
        if (path.equals("/ping") || path.equals("/time")){
            return true;
        }
        
        return false;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) {
        
        if (passesAuth((HttpServletRequest) request)) {
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
