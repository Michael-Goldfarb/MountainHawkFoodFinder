package com.pp.backend.service;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.sql.DataSource;
import com.pp.backend.entity.DiningPlaces;

public class DiningPlacesService {
    private final DataSource dataSource;

    public DiningPlacesService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<DiningPlaces> getDiningPlacesOptions() {
        List<DiningPlaces> diningPlacess = new ArrayList<>();

        try (Connection connection = dataSource.getConnection()) {
            try (PreparedStatement statement = connection.prepareStatement(
                    "SELECT d.id, d.place_name, d.dining_names, d.course_name, d.menu_item_name, d.calorie_text, d.allergen_names, d.price, d.more_information, " +
                    "f.givenStars, f.totalGivenStars, f.totalMaxStars, " +
                    "CASE WHEN f.totalMaxStars > 0 THEN (f.totalGivenStars * 1.0) / (f.totalMaxStars * 1.0 / 5.0) ELSE 0 END AS averageStars " +
                    "FROM diningPlacesOptions d " +
                    "LEFT JOIN foodRatings f ON d.menu_item_name = f.item_name")) {
                ResultSet resultSet = statement.executeQuery();

                while (resultSet.next()) {
                    DiningPlaces diningPlaces = new DiningPlaces();
                    diningPlaces.setId(resultSet.getLong("id"));
                    diningPlaces.setPlaceName(resultSet.getString("place_name"));
                    diningPlaces.setDiningNames(resultSet.getString("dining_names"));
                    diningPlaces.setCourseName(resultSet.getString("course_name"));
                    diningPlaces.setMenuItemName(resultSet.getString("menu_item_name"));
                    diningPlaces.setCalorieText(resultSet.getString("calorie_text"));
                    diningPlaces.setAllergenNames(resultSet.getString("allergen_names"));
                    diningPlaces.setPrice(resultSet.getString("price"));
                    diningPlaces.setMoreInformation(resultSet.getString("more_information"));
                    diningPlaces.setGivenStars(resultSet.getInt("givenStars"));
                    diningPlaces.setTotalGivenStars(resultSet.getInt("totalGivenStars"));
                    diningPlaces.setTotalMaxStars(resultSet.getInt("totalMaxStars"));
                    diningPlaces.setAverageStars(resultSet.getDouble("averageStars"));
                    diningPlacess.add(diningPlaces);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return diningPlacess;
    }




    public DiningPlaces createDiningPlacesOption(DiningPlaces diningPlaces) {
        String sql = "INSERT INTO diningPlacesOptions (place_name, dining_names, course_name, menu_item_name, calorie_text, allergen_names, price, more_information, givenStars, totalGivenStars, totalMaxStars, averageStars) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                "RETURNING id";

        try (Connection connection = dataSource.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, diningPlaces.getPlaceName());
            statement.setString(2, diningPlaces.getDiningNames());
            statement.setString(3, diningPlaces.getCourseName());
            statement.setString(4, diningPlaces.getMenuItemName());
            statement.setString(5, diningPlaces.getCalorieText());
            statement.setString(6, diningPlaces.getAllergenNames());
            statement.setString(7, diningPlaces.getPrice());
            statement.setString(8, diningPlaces.getMoreInformation());
            statement.setInt(9, diningPlaces.getGivenStars());
            statement.setInt(10, diningPlaces.getTotalGivenStars());
            statement.setInt(11, diningPlaces.getTotalMaxStars());

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                diningPlaces.setId(resultSet.getLong("id"));
                diningPlaces.setAverageStars((double) diningPlaces.getTotalGivenStars() / diningPlaces.getTotalMaxStars() / 5.0);
                return diningPlaces;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


    public DiningPlaces getDiningPlacesById(long diningPlacesId) {
        String sql = "SELECT d.id, d.place_name, d.dining_names, d.course_name, d.menu_item_name, d.calorie_text, d.allergen_names, d.price, d.more_information, f.givenStars, f.totalGivenStars, f.totalMaxStars, f.averageStars " +
                "FROM diningPlacesOptions d " +
                "LEFT JOIN foodRatings f ON d.menu_item_name = f.item_name " +
                "WHERE d.id = ?";

        try (Connection connection = dataSource.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setLong(1, diningPlacesId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                DiningPlaces diningPlaces = new DiningPlaces();
                diningPlaces.setId(resultSet.getLong("id"));
                diningPlaces.setPlaceName(resultSet.getString("place_name"));
                diningPlaces.setDiningNames(resultSet.getString("dining_names"));
                diningPlaces.setCourseName(resultSet.getString("course_name"));
                diningPlaces.setMenuItemName(resultSet.getString("menu_item_name"));
                diningPlaces.setCalorieText(resultSet.getString("calorie_text"));
                diningPlaces.setAllergenNames(resultSet.getString("allergen_names"));
                diningPlaces.setPrice(resultSet.getString("price"));
                diningPlaces.setMoreInformation(resultSet.getString("more_information"));
                diningPlaces.setGivenStars(resultSet.getInt("givenStars"));
                diningPlaces.setTotalGivenStars(resultSet.getInt("totalGivenStars"));
                diningPlaces.setTotalMaxStars(resultSet.getInt("totalMaxStars"));
                diningPlaces.setAverageStars(resultSet.getDouble("averageStars"));
                return diningPlaces;
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } 
}