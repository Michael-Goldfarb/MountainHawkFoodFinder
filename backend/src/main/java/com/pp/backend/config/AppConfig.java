package com.pp.backend.config;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.web.client.RestTemplate;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pp.backend.service.UserService;
import com.pp.backend.service.RathboneService;
import com.pp.backend.service.HoursOfOperationService;
import com.pp.backend.service.DiningPlacesService;

@Configuration
public class AppConfig {

    @Value("${spring.datasource.driver-class-name}")
    private String driverClassName;

    @Value("${spring.datasource.url}")
    private String url;

    @Value("${spring.datasource.username}")
    private String username;

    @Value("${spring.datasource.password}")
    private String password;

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName(driverClassName);
        dataSource.setUrl(url);
        dataSource.setUsername(username);
        dataSource.setPassword(password);
        return dataSource;
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    @Bean
    public ObjectMapper objectMapper() {
        return new ObjectMapper();
    }

    @Bean
    public UserService userService(DataSource dataSource) {
        return new UserService(dataSource);
    }

    @Bean
    public DiningPlacesService diningPlacesService(DataSource dataSource) {
        return new DiningPlacesService(dataSource);
    }

    @Bean
    public RathboneService rathboneService(DataSource dataSource) {
        return new RathboneService(dataSource);
    }

    @Bean
    public HoursOfOperationService hoursOfOperationService(DataSource dataSource) {
        return new HoursOfOperationService(dataSource);
    }
}
