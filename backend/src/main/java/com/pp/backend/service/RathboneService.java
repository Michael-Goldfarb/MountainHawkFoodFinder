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
                    "SELECT r.id, r.meal_type, r.course_name, r.menu_item_name, r.calorie_text, r.allergen_names, fr.upvotes, fr.downvotes, fr.upvoted, fr.downvoted " +
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
                    rathbone.setUpvoted(resultSet.getBoolean("upvoted"));
                    rathbone.setDownvoted(resultSet.getBoolean("downvoted"));
                    rathbones.add(rathbone);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return rathbones;
    }

    public void updateFoodRatings(long rathboneId, int upvotes, int downvotes, boolean upvoted, boolean downvoted) {
        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement("UPDATE foodRatings SET upvotes = ?, downvotes = ?, upvoted = ?, downvoted = ? WHERE id = ?")) {
            statement.setInt(1, upvotes);
            statement.setInt(2, downvotes);
            statement.setBoolean(3, upvoted);
            statement.setBoolean(4, downvoted);
            statement.setLong(5, rathboneId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void insertFoodRating(String itemName, int upvotes, int downvotes, boolean upvoted, boolean downvoted) {
        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement("INSERT INTO foodratings (item_name, upvotes, downvotes, upvoted, downvoted) VALUES (?, ?, ?, ?, ?)")) {
            statement.setString(1, itemName);
            statement.setInt(2, upvotes);
            statement.setInt(3, downvotes);
            statement.setBoolean(4, upvoted);
            statement.setBoolean(5, downvoted);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
