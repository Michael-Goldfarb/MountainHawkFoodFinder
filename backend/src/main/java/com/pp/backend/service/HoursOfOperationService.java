package com.pp.backend.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import com.pp.backend.entity.HoursOfOperation;

public class HoursOfOperationService {
    private final DataSource dataSource;

    public HoursOfOperationService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<HoursOfOperation> getHoursOfOperation() {
        String sql = "SELECT * FROM hoursOfOperations";
        List<HoursOfOperation> hoursOfOperations = new ArrayList<>();

        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                HoursOfOperation hoursOfOperation = new HoursOfOperation();
                hoursOfOperation.setDiningHallName(resultSet.getString("dining_hall_name"));
                hoursOfOperation.setDayOfWeek(resultSet.getString("day_of_week"));
                hoursOfOperation.setMealType(resultSet.getString("meal_type"));
                hoursOfOperation.setHours(resultSet.getString("hours"));

                hoursOfOperations.add(hoursOfOperation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return hoursOfOperations;
    }
}
