package com.pp.backend.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.sql.DataSource;
import com.pp.backend.entity.Rathbone;

public class RathboneService {
    private final DataSource dataSource;

    public RathboneService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<Rathbone> getRathboneOptions() {
        List<Rathbone> rathbones = new ArrayList<>();

        try (Connection connection = dataSource.getConnection()) {
            try (PreparedStatement statement = connection.prepareStatement(
                    "SELECT r.id, r.meal_type, r.course_name, r.menu_item_name, r.calorie_text, r.allergen_names, fr.upvotes, fr.downvotes " +
                            "FROM rathboneOptions r " +
                            "LEFT JOIN foodRatings fr ON r.menu_item_name = fr.item_name")) {
                ResultSet resultSet = statement.executeQuery();

                while (resultSet.next()) {
                    Rathbone rathbone = new Rathbone();
                    rathbone.setId(resultSet.getLong("id"));
                    rathbone.setMealType(resultSet.getString("meal_type"));
                    rathbone.setCourseName(resultSet.getString("course_name"));
                    rathbone.setMenuItemName(resultSet.getString("menu_item_name"));
                    rathbone.setCalorieText(resultSet.getString("calorie_text"));
                    rathbone.setAllergenNames(resultSet.getString("allergen_names"));
                    rathbone.setUpvotes(resultSet.getInt("upvotes"));
                    rathbone.setDownvotes(resultSet.getInt("downvotes"));
                    rathbones.add(rathbone);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return rathbones;
    }




    public Rathbone createRathboneOption(Rathbone rathbone) {
        String sql = "INSERT INTO rathboneOptions (meal_type, course_name, menu_item_name, calorie_text, allergen_names) VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            statement.setString(1, rathbone.getMealType());
            statement.setString(2, rathbone.getCourseName());
            statement.setString(3, rathbone.getMenuItemName());
            statement.setString(4, rathbone.getCalorieText());
            statement.setString(5, rathbone.getAllergenNames());

            int rowsAffected = statement.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        rathbone.setId(generatedKeys.getLong(1)); // Added to set the generated primary key
                        return rathbone;
                    }
                }
            }

            throw new SQLException("Unable to create Rathbone option");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateFoodRatings(long rathboneId, int upvotes, int downvotes) {
        String sql = "UPDATE foodRatings SET upvotes = ?, downvotes = ? WHERE id = ?";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, upvotes);
            statement.setInt(2, downvotes);
            statement.setLong(3, rathboneId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
