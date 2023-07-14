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
                    "SELECT r.id, r.meal_type, r.course_name, r.menu_item_name, r.calorie_text, r.allergen_names, " +
                    "f.givenStars, f.totalGivenStars, f.totalMaxStars, f.averageStars " +
                    "FROM rathboneOptions r " +
                    "LEFT JOIN foodRatings f ON r.menu_item_name = f.item_name")) {
                ResultSet resultSet = statement.executeQuery();

                while (resultSet.next()) {
                    Rathbone rathbone = new Rathbone();
                    rathbone.setId(resultSet.getLong("id"));
                    rathbone.setMealType(resultSet.getString("meal_type"));
                    rathbone.setCourseName(resultSet.getString("course_name"));
                    rathbone.setMenuItemName(resultSet.getString("menu_item_name"));
                    rathbone.setCalorieText(resultSet.getString("calorie_text"));
                    rathbone.setAllergenNames(resultSet.getString("allergen_names"));
                    rathbone.setGivenStars(resultSet.getInt("givenStars"));
                    rathbone.setTotalGivenStars(resultSet.getInt("totalGivenStars"));
                    rathbone.setTotalMaxStars(resultSet.getInt("totalMaxStars"));
                    rathbone.setAverageStars(resultSet.getDouble("averageStars"));
                    rathbones.add(rathbone);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return rathbones;
    }



    public Rathbone createRathboneOption(Rathbone rathbone) {
        String sql = "INSERT INTO rathboneOptions (meal_type, course_name, menu_item_name, calorie_text, allergen_names, givenStars, totalGivenStars, totalMaxStars, averageStars) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                "RETURNING id";

        try (Connection connection = dataSource.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, rathbone.getMealType());
            statement.setString(2, rathbone.getCourseName());
            statement.setString(3, rathbone.getMenuItemName());
            statement.setString(4, rathbone.getCalorieText());
            statement.setString(5, rathbone.getAllergenNames());
            statement.setInt(6, rathbone.getGivenStars());
            statement.setInt(7, rathbone.getTotalGivenStars());
            statement.setInt(8, rathbone.getTotalMaxStars());
            statement.setDouble(9, rathbone.getAverageStars());

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                rathbone.setId(resultSet.getLong("id"));
                return rathbone;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


    public Rathbone getRathboneById(long rathboneId) {
        String sql = "SELECT r.id, r.meal_type, r.course_name, r.menu_item_name, r.calorie_text, r.allergen_names, f.givenStars, f.totalGivenStars, f.totalMaxStars, f.averageStars " +
                "FROM rathboneOptions r " +
                "JOIN foodRatings f ON r.menu_item_name = f.item_name " +
                "WHERE r.id = ?";

        try (Connection connection = dataSource.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setLong(1, rathboneId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                Rathbone rathbone = new Rathbone();
                rathbone.setId(resultSet.getLong("id"));
                rathbone.setMealType(resultSet.getString("meal_type"));
                rathbone.setCourseName(resultSet.getString("course_name"));
                rathbone.setMenuItemName(resultSet.getString("menu_item_name"));
                rathbone.setCalorieText(resultSet.getString("calorie_text"));
                rathbone.setAllergenNames(resultSet.getString("allergen_names"));
                rathbone.setGivenStars(resultSet.getInt("givenStars"));
                rathbone.setTotalGivenStars(resultSet.getInt("totalGivenStars"));
                rathbone.setTotalMaxStars(resultSet.getInt("totalMaxStars"));
                rathbone.setAverageStars(resultSet.getDouble("averageStars"));
                return rathbone;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }


    public void updateFoodRatings(String itemName, int givenStars, int totalGivenStars, int totalMaxStars, double averageStars) {
        String selectSql = "SELECT totalGivenStars, totalMaxStars FROM foodRatings WHERE item_name = ?";
        String updateSql = "UPDATE foodRatings SET givenStars = ?, totalGivenStars = ?, totalMaxStars = ?, averageStars = ? WHERE item_name = ?";
        String insertSql = "INSERT INTO foodRatings (item_name, givenStars, totalGivenStars, totalMaxStars, averageStars) VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = dataSource.getConnection();
            PreparedStatement selectStatement = connection.prepareStatement(selectSql);
            PreparedStatement updateStatement = connection.prepareStatement(updateSql);
            PreparedStatement insertStatement = connection.prepareStatement(insertSql)) {

            selectStatement.setString(1, itemName);
            ResultSet resultSet = selectStatement.executeQuery();

            if (resultSet.next()) {
                totalGivenStars += givenStars;
                totalMaxStars += 5;
                averageStars = (double) totalGivenStars / totalMaxStars;

                updateStatement.setInt(1, givenStars);
                updateStatement.setInt(2, totalGivenStars);
                updateStatement.setInt(3, totalMaxStars);
                updateStatement.setDouble(4, averageStars);
                updateStatement.setString(5, itemName);
                updateStatement.executeUpdate();
            } else {
                // The menu item doesn't exist, insert a new row
                insertStatement.setString(1, itemName);
                insertStatement.setInt(2, givenStars);
                insertStatement.setInt(3, totalGivenStars);
                insertStatement.setInt(4, totalMaxStars);
                insertStatement.setDouble(5, averageStars);
                insertStatement.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
