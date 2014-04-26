package me.yapzap.api.v1.filters;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import me.yapzap.api.admin.MetricServletContextListener;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.codahale.metrics.Timer;

public class MetricsInterceptor extends HandlerInterceptorAdapter {

    final static Map<String, Timer> timers = new HashMap<String, Timer>();
    final static Map<HttpServletRequest, Timer.Context> timerContext = new HashMap<HttpServletRequest, Timer.Context>();
    
    final static Object lock = new Object();
    
    
    private static String getPathKeyFromRequest(HttpServletRequest request){
        String method = request.getMethod();
        String[] pathParts = request.getRequestURI().substring(1).split("/");
        
        String path = "";
        
        switch(pathParts.length){
            case 0:
                return method;
            case 1:
            case 2:
            	if (pathParts[0].equals("a")){
            		return method+"_a";
            	}
                path = pathParts[0];
                break;
            case 3:
                path = pathParts[0] + pathParts[2];
                break;
        }
        
        return method+"_"+path;
    }
    
    
    @Override
    public synchronized boolean  preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        
        //Get timer for Path
        String key = getPathKeyFromRequest(request);
        Timer timer = timers.get(key);
        
        if (timer==null){
            //create the timer
            timer = MetricServletContextListener.METRIC_REGISTRY.timer(key);
            timers.put(key, timer);
        }
        
        timerContext.put(request, timer.time());
        
        return true;
    }
    
    
    @Override
    public synchronized void afterCompletion(
            HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        //Stop the timer
        Timer.Context context = timerContext.get(request);
        context.stop();
        timerContext.remove(request);
    }

}