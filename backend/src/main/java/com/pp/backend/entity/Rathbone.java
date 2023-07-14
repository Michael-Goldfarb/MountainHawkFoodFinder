package com.pp.backend.entity;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Rathbone {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String mealType;
    private String courseName;
    private String menuItemName;
    private String calorieText;
    private String allergenNames;
    private int givenStars;
    private int totalGivenStars;
    private int totalMaxStars;
    private double averageStars;

    public Rathbone() {
    }

    public Rathbone(Long id, String mealType, String courseName, String menuItemName, String calorieText,
                    String allergenNames, int givenStars, int totalGivenStars, int totalMaxStars, double averageStars) {
        this.id = id;
        this.mealType = mealType;
        this.courseName = courseName;
        this.menuItemName = menuItemName;
        this.calorieText = calorieText;
        this.allergenNames = allergenNames;
        this.givenStars = givenStars;
        this.totalGivenStars = totalGivenStars;
        this.totalMaxStars = totalMaxStars;
        this.averageStars = averageStars;
    }

    // Getters and setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMealType() {
        return mealType;
    }

    public void setMealType(String mealType) {
        this.mealType = mealType;
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