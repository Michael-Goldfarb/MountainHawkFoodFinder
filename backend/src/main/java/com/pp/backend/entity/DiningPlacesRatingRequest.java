package com.pp.backend.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class DiningPlacesRatingRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String userEmail;
    private int givenStars;
    private int totalGivenStars;
    private int totalMaxStars;
    private double averageStars;

    public DiningPlacesRatingRequest() {
    }

    public DiningPlacesRatingRequest(String userEmail, int givenStars, int totalGivenStars, int totalMaxStars, double averageStars) {
        this.userEmail = userEmail;
        this.givenStars = givenStars;
        this.totalGivenStars = totalGivenStars;
        this.totalMaxStars = totalMaxStars;
        this.averageStars = averageStars;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public int getGivenStars() {
        return givenStars;
    }

    public void setGivenStars(int givenStars) {
        this.givenStars = givenStars;
    }

    public int getTotalGivenStars() {
        return totalGivenStars;
    }

    public void setTotalGivenStars(int totalGivenStars) {
        this.totalGivenStars = totalGivenStars;
    }

    public int getTotalMaxStars() {
        return totalMaxStars;
    }

    public void setTotalMaxStars(int totalMaxStars) {
        this.totalMaxStars = totalMaxStars;
    }

    public double getAverageStars() {
        return averageStars;
    }

    public void setAverageStars(double averageStars) {
        this.averageStars = averageStars;
    }
}
