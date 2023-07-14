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

    public void createRathboneOption(Rathbone rathbone) {
        String rathboneSql = "INSERT INTO rathboneOptions (meal_type, course_name, menu_item_name, calorie_text, allergen_names) VALUES (?, ?, ?, ?, ?)";
        String foodRatingSql = "INSERT INTO foodRatings (item_name, upvotes, downvotes, upvoted, downvoted) VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement rathboneStatement = connection.prepareStatement(rathboneSql, PreparedStatement.RETURN_GENERATED_KEYS);
             PreparedStatement foodRatingStatement = connection.prepareStatement(foodRatingSql)) {

            connection.setAutoCommit(false);

            rathboneStatement.setString(1, rathbone.getMealType());
            rathboneStatement.setString(2, rathbone.getCourseName());
            rathboneStatement.setString(3, rathbone.getMenuItemName());
            rathboneStatement.setString(4, rathbone.getCalorieText());
            rathboneStatement.setString(5, rathbone.getAllergenNames());

            int rowsAffected = rathboneStatement.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = rathboneStatement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        rathbone.setId(generatedKeys.getLong(1)); // Added to set the generated primary key
                    }
                }
            }

            foodRatingStatement.setString(1, rathbone.getMenuItemName());
            foodRatingStatement.setInt(2, rathbone.getUpvotes());
            foodRatingStatement.setInt(3, rathbone.getDownvotes());
            foodRatingStatement.setBoolean(4, rathbone.isUpvoted());
            foodRatingStatement.setBoolean(5, rathbone.isDownvoted());
            foodRatingStatement.executeUpdate();

            connection.commit();
            connection.setAutoCommit(true);

        } catch (SQLException e) {
            e.printStackTrace();
        }
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

    public void insertFoodRating(String itemName, int upvotes, int downvotes) {
        String sql = "INSERT INTO foodRatings (item_name, upvotes, downvotes) VALUES (?, ?, ?)";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, itemName);
            statement.setInt(2, upvotes);
            statement.setInt(3, downvotes);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
