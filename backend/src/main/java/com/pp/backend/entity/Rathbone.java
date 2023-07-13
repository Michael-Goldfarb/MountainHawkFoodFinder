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

    public Rathbone() {
    }

    public Rathbone(String mealType, String courseName, String menuItemName, String calorieText, String allergenNames) {
        this.mealType = mealType;
        this.courseName = courseName;
        this.menuItemName = menuItemName;
        this.calorieText = calorieText;
        this.allergenNames = allergenNames;
    }

    public Long getId() {
        return id;
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
}
