package com.practice.javascript.JavascriptAjaxREST;

import java.sql.SQLException;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.practice.model.Sitemap;
import com.practice.operation.Operation;



@RestController
public class RESTFul {
	
	
    @RequestMapping("/")
    public String index() {
        return "Greetings from Spring Boot!";
    }
    
    @RequestMapping(value="/getAll", method = RequestMethod.GET)
    public Map<Integer,String> get() throws SQLException{
        Map<Integer,String> details=Operation.getAll();
    	return details;
    }
    
    @RequestMapping(value = "/postData/user", method = RequestMethod.POST)
    public ResponseEntity <String> postUser(@RequestBody Sitemap sitemap) throws SQLException{	
    	int result;   	
    	result=Operation.createSitemap(sitemap);
    	if(result==0){
    		return ResponseEntity.status(HttpStatus.I_AM_A_TEAPOT).build();
    	}
    	else{
    		return ResponseEntity.status(HttpStatus.CREATED).build();
    	}
    }
}

