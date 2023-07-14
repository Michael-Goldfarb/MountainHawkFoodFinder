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
    private int upvotes;
    private int downvotes;
    private boolean upvoted;
    private boolean downvoted;

    public Rathbone() {
    }

    public Rathbone(Long id, String mealType, String courseName, String menuItemName, String calorieText,
                    String allergenNames, int upvotes, int downvotes, Boolean upvoted, Boolean downvoted) {
        this.id = id;
        this.mealType = mealType;
        this.courseName = courseName;
        this.menuItemName = menuItemName;
        this.calorieText = calorieText;
        this.allergenNames = allergenNames;
        this.upvotes = upvotes;
        this.downvotes = downvotes;
        this.upvoted = upvoted;
        this.downvoted = downvoted;
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

    public int getUpvotes() {
        return upvotes;
    }

    public void setUpvotes(int upvotes) {
        this.upvotes = upvotes;
    }

    public int getDownvotes() {
        return downvotes;
    }

    public void setDownvotes(int downvotes) {
        this.downvotes = downvotes;
    }

    public Boolean getUpvoted() {
        return upvoted;
    }

    public void setUpvoted(Boolean upvoted) {
        this.upvoted = upvoted;
    }

    public Boolean getDownvoted() {
        return downvoted;
    }

    public void setDownvoted(Boolean downvoted) {
        this.downvoted = downvoted;
    }

    public boolean isUpvoted() {
        return upvoted;
    }

    public boolean isDownvoted() {
        return downvoted;
    }

}
