package me.yapzap.api.v1.filters;

import javax.servlet.FilterChain;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.springframework.web.filter.DelegatingFilterProxy;

public class SecurityFilter extends DelegatingFilterProxy {
	
	
	@Override
	 public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain)
	{		
		
	}

}
