package com.pp.backend.service;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.sql.DataSource;
import com.pp.backend.entity.Rathbone;
import java.util.logging.Logger;

public class RathboneService {
    private final DataSource dataSource;
    private static final Logger log = Logger.getLogger(RathboneService.class.getName());

    public RathboneService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<Rathbone> getRathboneOptions() {
        List<Rathbone> rathbones = new ArrayList<>();

        try (Connection connection = dataSource.getConnection()) {
            try (PreparedStatement statement = connection.prepareStatement(
                    "SELECT r.id, r.meal_type, r.course_name, r.menu_item_name, r.calorie_text, r.allergen_names, " +
                    "f.givenStars, f.totalGivenStars, f.totalMaxStars, " +
                    "CASE WHEN f.totalMaxStars > 0 THEN (f.totalGivenStars * 1.0) / (f.totalMaxStars * 1.0 / 5.0) ELSE 0 END AS averageStars " +
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

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                rathbone.setId(resultSet.getLong("id"));
                rathbone.setAverageStars((double) rathbone.getTotalGivenStars() / rathbone.getTotalMaxStars() / 5.0);
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
                "LEFT JOIN foodRatings f ON r.menu_item_name = f.item_name " +
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


    public void updateFoodRatings(String itemName, String userEmail, int givenStars, int totalGivenStars, int totalMaxStars, double averageStars) {
        String selectCountSql = "SELECT COUNT(*) FROM foodRatings";
        String firstSelectSql = "SELECT given_stars FROM ItemRatings WHERE item_name = ?";
        String secondSelectSql = "SELECT given_stars FROM ItemRatings WHERE item_name = ? AND user_email = ?";
        String updateSql = "UPDATE ItemRatings SET given_stars = ? WHERE item_name = ? AND user_email = ?";
        String insertSql = "INSERT INTO ItemRatings (item_name, user_email, given_stars) VALUES (?, ?, ?)";
        String foodRatingsInsertSql = "INSERT INTO foodRatings (item_name, givenStars, totalGivenStars, totalMaxStars, averageStars) VALUES (?, ?, ?, ?, ?)";
        String updateFoodRatingsSql = "UPDATE foodRatings SET givenStars = ?, totalGivenStars = ?, totalMaxStars = ?, averageStars = ? WHERE item_name = ?";
        String selectFoodRatingsSql = "SELECT totalGivenStars, totalMaxStars FROM foodRatings WHERE item_name = ?";
    
        try (Connection connection = dataSource.getConnection();
             PreparedStatement selectCountStatement = connection.prepareStatement(selectCountSql);
             PreparedStatement firstSelectStatement = connection.prepareStatement(firstSelectSql);
             PreparedStatement secondSelectStatement = connection.prepareStatement(secondSelectSql);
             PreparedStatement updateStatement = connection.prepareStatement(updateSql);
             PreparedStatement insertStatement = connection.prepareStatement(insertSql);
             PreparedStatement foodRatingsInsertStatement = connection.prepareStatement(foodRatingsInsertSql);
             PreparedStatement updateFoodRatingsStatement = connection.prepareStatement(updateFoodRatingsSql);
             PreparedStatement selectFoodRatingsStatement = connection.prepareStatement(selectFoodRatingsSql)) {
             
            ResultSet countResultSet = selectCountStatement.executeQuery();
            countResultSet.next();
            int rowCount = countResultSet.getInt(1);
    
            if (rowCount > 0) {
                System.out.println("row > 0");   
                
                firstSelectStatement.setString(1, itemName);
                ResultSet itemResultSet = firstSelectStatement.executeQuery();

                if (itemResultSet.next()) {
                    System.out.println("item exists in foodRatings");
                    
                    secondSelectStatement.setString(1, itemName);
                    secondSelectStatement.setString(2, userEmail);
                    ResultSet userResultSet = secondSelectStatement.executeQuery();
                    
                    if (userResultSet.next()) {
                        System.out.println("user exists in ItemRatings");
                        // Update the existing rating
                        System.out.println("updating ItemRatings and foodRatings");
                        selectFoodRatingsStatement.setString(1, itemName);
                        ResultSet foodRatingsResultSet = selectFoodRatingsStatement.executeQuery();

                        if (foodRatingsResultSet.next()) {
                            int currentTotalGivenStars = foodRatingsResultSet.getInt("totalGivenStars");
                            int currentTotalMaxStars = foodRatingsResultSet.getInt("totalMaxStars");
                            int originalGivenStars = userResultSet.getInt("given_stars");
                            System.out.println("original given stars = " + originalGivenStars);

                            // Update the current values with the new rating
                            totalGivenStars += currentTotalGivenStars;
                            totalGivenStars -= originalGivenStars;
                            totalGivenStars += givenStars;
                            totalMaxStars += currentTotalMaxStars;
                            averageStars = (double) totalGivenStars / (totalMaxStars / 5.0);

                            // Update the foodRatings table
                            updateFoodRatingsStatement.setInt(1, givenStars);
                            updateFoodRatingsStatement.setInt(2, totalGivenStars);
                            updateFoodRatingsStatement.setInt(3, totalMaxStars);
                            updateFoodRatingsStatement.setDouble(4, averageStars);
                            updateFoodRatingsStatement.setString(5, itemName);
                            updateFoodRatingsStatement.executeUpdate();

                            // Update the ItemRatings table
                            updateStatement.setInt(1, givenStars);
                            updateStatement.setString(2, itemName);
                            updateStatement.setString(3, userEmail);
                            updateStatement.executeUpdate();
                        }
                    } else {
                        System.out.println("user does not exist");
                        System.out.println("inserting into ItemRatings and updating foodRatings");
                        selectFoodRatingsStatement.setString(1, itemName);
                        ResultSet foodRatingsResultSet = selectFoodRatingsStatement.executeQuery();

                        if (foodRatingsResultSet.next()) {
                            int currentTotalGivenStars = foodRatingsResultSet.getInt("totalGivenStars");
                            int currentTotalMaxStars = foodRatingsResultSet.getInt("totalMaxStars");

                            // Update the current values with the new rating
                            totalGivenStars += currentTotalGivenStars;
                            totalGivenStars += givenStars;
                            totalMaxStars += currentTotalMaxStars;
                            totalMaxStars += 5;
                            averageStars = (double) totalGivenStars / (totalMaxStars / 5.0);
                            // Update the foodRatings table first
                            updateFoodRatingsStatement.setInt(1, givenStars);
                            updateFoodRatingsStatement.setInt(2, totalGivenStars);
                            updateFoodRatingsStatement.setInt(3, totalMaxStars);
                            updateFoodRatingsStatement.setDouble(4, averageStars);
                            updateFoodRatingsStatement.setString(5, itemName);
                            updateFoodRatingsStatement.executeUpdate();
                            // Insert a new row for the user
                            insertStatement.setString(1, itemName);
                            insertStatement.setString(2, userEmail);
                            insertStatement.setInt(3, givenStars);
                            insertStatement.executeUpdate();   
                        }   
                    }
                } else {
                    System.out.println("Item doesn't exist, inserting");
                    // Insert into foodRatings table
                    totalGivenStars = givenStars;
                    totalMaxStars = 5;
                    averageStars = (double) totalGivenStars / (totalMaxStars / 5.0);
                    foodRatingsInsertStatement.setString(1, itemName);
                    foodRatingsInsertStatement.setInt(2, givenStars);
                    foodRatingsInsertStatement.setInt(3, totalGivenStars);
                    foodRatingsInsertStatement.setInt(4, totalMaxStars);
                    foodRatingsInsertStatement.setDouble(5, averageStars);
                    foodRatingsInsertStatement.executeUpdate();
                    
                    // No existing rating, insert a new one
                    insertStatement.setString(1, itemName);
                    insertStatement.setString(2, userEmail);
                    insertStatement.setInt(3, givenStars);
                    insertStatement.executeUpdate();    
                }
            } else {
                System.out.println("row < 0, inserting");
                // Handle empty "foodratings" table
                // Insert into "foodratings" table first
                totalGivenStars = givenStars;
                totalMaxStars = 5;
                averageStars = (double) totalGivenStars / (totalMaxStars / 5.0);
                foodRatingsInsertStatement.setString(1, itemName);
                foodRatingsInsertStatement.setInt(2, givenStars);
                foodRatingsInsertStatement.setInt(3, totalGivenStars);
                foodRatingsInsertStatement.setInt(4, totalMaxStars);
                foodRatingsInsertStatement.setDouble(5, averageStars);
                foodRatingsInsertStatement.executeUpdate();
    
                // Now insert into "itemratings" table
                insertStatement.setString(1, itemName);
                insertStatement.setString(2, userEmail);
                insertStatement.setInt(3, givenStars);
                insertStatement.executeUpdate();
            }
    
            // Update the foodRatings table with the updated values
            // ... (remaining code)
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    

    
    
    // private double calculateAverageStars(String itemName) {
    //     String selectSql = "SELECT AVG(given_stars) FROM ItemRatings WHERE item_name = ?";
    //     try (Connection connection = dataSource.getConnection();
    //          PreparedStatement selectStatement = connection.prepareStatement(selectSql)) {
    
    //         selectStatement.setString(1, itemName);
    //         ResultSet resultSet = selectStatement.executeQuery();
    //         if (resultSet.next()) {
    //             return resultSet.getDouble(1);
    //         }
    //     } catch (SQLException e) {
    //         e.printStackTrace();
    //     }
    //     return 0;
    // }    
}
