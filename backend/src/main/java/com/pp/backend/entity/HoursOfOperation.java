package com.pp.backend.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class HoursOfOperation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String diningHallName;
    private String dayOfWeek;
    private String mealType;
    private String hours;

    public HoursOfOperation() {
    }

    public HoursOfOperation(String diningHallName, String dayOfWeek, String mealType, String hours) {
        this.diningHallName = diningHallName;
        this.dayOfWeek = dayOfWeek;
        this.mealType = mealType;
        this.hours = hours;
    }

    // Getters and setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDiningHallName() {
        return diningHallName;
    }

    public void setDiningHallName(String diningHallName) {
        this.diningHallName = diningHallName;
    }

    public String getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(String dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public String getMealType() {
        return mealType;
    }

    public void setMealType(String mealType) {
        this.mealType = mealType;
    }

    public String getHours() {
        return hours;
    }

    public void setHours(String hours) {
        this.hours = hours;
    }
}
