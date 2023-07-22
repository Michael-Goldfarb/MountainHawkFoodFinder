package com.pp.backend.controller;

import com.pp.backend.entity.DiningPlaces;
import com.pp.backend.entity.DiningPlacesRatingRequest;
import com.pp.backend.service.DiningPlacesService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/dining-places")
public class DiningPlacesController {
    private final DiningPlacesService diningPlacesService;

    public DiningPlacesController(DiningPlacesService diningPlacesService) {
        this.diningPlacesService = diningPlacesService;
    }

    @GetMapping
    public ResponseEntity<List<DiningPlaces>> getDiningPlacesOptions() {
        List<DiningPlaces> diningPlaces = diningPlacesService.getDiningPlacesOptions();
        return ResponseEntity.ok(diningPlaces);
    }

    @GetMapping("/{diningPlacesId}")
    public ResponseEntity<DiningPlaces> getDiningPlacesById(@PathVariable Long diningPlacesId) {
        DiningPlaces diningPlaces = diningPlacesService.getDiningPlacesById(diningPlacesId);

        if (diningPlaces == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(diningPlaces);
    }

    @PostMapping
    public ResponseEntity<DiningPlaces> createDiningPlacesOption(@RequestBody DiningPlaces diningPlaces) {
        DiningPlaces createdDiningPlaces = diningPlacesService.createDiningPlacesOption(diningPlaces);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdDiningPlaces);
    }

    @PutMapping("/{diningPlacesId}")
    public ResponseEntity<DiningPlaces> updateFoodRatings(@PathVariable Long diningPlacesId, @RequestBody DiningPlacesRatingRequest ratingRequest, @RequestHeader("userEmail") String userEmail) {
        DiningPlaces diningPlaces = diningPlacesService.getDiningPlacesById(diningPlacesId);
        System.out.println(diningPlaces);

        if (diningPlaces == null) {
            return ResponseEntity.notFound().build();
        }

        int givenStars = ratingRequest.getGivenStars();
        int totalGivenStars = ratingRequest.getTotalGivenStars();
        int totalMaxStars = ratingRequest.getTotalMaxStars();
        double averageStars = ratingRequest.getAverageStars();

        diningPlacesService.updateFoodRatings(diningPlaces.getMenuItemName(), userEmail, givenStars, totalGivenStars, totalMaxStars, averageStars);

        diningPlaces.setGivenStars(givenStars);
        diningPlaces.setTotalGivenStars(totalGivenStars);
        diningPlaces.setTotalMaxStars(totalMaxStars);
        diningPlaces.setAverageStars(averageStars);
        diningPlaces.setUserEmail(userEmail);

        return ResponseEntity.ok(diningPlaces);
    }
}