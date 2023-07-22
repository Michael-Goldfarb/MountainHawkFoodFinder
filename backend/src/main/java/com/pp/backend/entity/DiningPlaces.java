package com.pp.backend.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class DiningPlaces {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String placeName;
    private String diningNames;
    private String courseName;
    private String menuItemName;
    private String calorieText;
    private String allergenNames;
    private String userEmail;
    private int givenStars;
    private int totalGivenStars;
    private int totalMaxStars;
    private double averageStars;
    private String price;
    private String moreInformation;
    

    public DiningPlaces() {
    }

    public DiningPlaces(String placeName, String diningNames, String courseName, String menuItemName, String calorieText,
                    String allergenNames, String userEmail, int givenStars, int totalGivenStars, int totalMaxStars, double averageStars, String price, String moreInformation) {
        this.placeName = placeName;
        this.diningNames = diningNames;
        this.courseName = courseName;
        this.menuItemName = menuItemName;
        this.calorieText = calorieText;
        this.allergenNames = allergenNames;
        this.userEmail = userEmail;
        this.givenStars = givenStars;
        this.totalGivenStars = totalGivenStars;
        this.totalMaxStars = totalMaxStars;
        this.averageStars = averageStars;
        this.price = price;
        this.moreInformation = moreInformation;
    }

    // Getters and setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPlaceName() {
        return placeName;
    }
    
    public void setPlaceName(String placeName) {
        this.placeName = placeName;
    }

    public String getDiningNames() {
        return diningNames;
    }

    public void setDiningNames(String diningNames) {
        this.diningNames = diningNames;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getMenuItemName() {
        return menuItemName;
    }

    public void setMenuItemName(String menuItemName) {
        this.menuItemName = menuItemName;
    }

    public String getCalorieText() {
        return calorieText;
    }

    public void setCalorieText(String calorieText) {
        this.calorieText = calorieText;
    }

    public String getAllergenNames() {
        return allergenNames;
    }

    public void setAllergenNames(String allergenNames) {
        this.allergenNames = allergenNames;
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

    public String getPrice() {
        return price;
    }
    
    public void setPrice(String price) {
        this.price = price;
    }

    public String getMoreInformation() {
        return moreInformation;
    }

    public void setMoreInformation(String moreInformation) {
        this.moreInformation = moreInformation;
    }
}
