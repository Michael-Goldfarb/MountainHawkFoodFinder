package com.pp.backend.controller;

import com.pp.backend.entity.Rathbone;
import com.pp.backend.entity.RathboneRatingRequest;
import com.pp.backend.service.RathboneService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/rathbone")
public class RathboneController {
    private final RathboneService rathboneService;

    public RathboneController(RathboneService rathboneService) {
        this.rathboneService = rathboneService;
    }

    @GetMapping
    public ResponseEntity<List<Rathbone>> getRathboneOptions() {
        List<Rathbone> rathbones = rathboneService.getRathboneOptions();
        return ResponseEntity.ok(rathbones);
    }

    @GetMapping("/{rathboneId}")
    public ResponseEntity<Rathbone> getRathboneById(@PathVariable Long rathboneId) {
        Rathbone rathbone = rathboneService.getRathboneById(rathboneId);

        if (rathbone == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(rathbone);
    }

    @PostMapping
    public ResponseEntity<Rathbone> createRathboneOption(@RequestBody Rathbone rathbone) {
        Rathbone createdRathbone = rathboneService.createRathboneOption(rathbone);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdRathbone);
    }

    @PutMapping("/{rathboneId}")
    public ResponseEntity<Rathbone> updateFoodRatings(@PathVariable Long rathboneId, @RequestBody RathboneRatingRequest ratingRequest, @RequestHeader("userEmail") String userEmail) {
        Rathbone rathbone = rathboneService.getRathboneById(rathboneId);

        if (rathbone == null) {
            return ResponseEntity.notFound().build();
        }

        int givenStars = ratingRequest.getGivenStars();
        int totalGivenStars = ratingRequest.getTotalGivenStars();
        int totalMaxStars = ratingRequest.getTotalMaxStars();
        double averageStars = ratingRequest.getAverageStars();

        rathboneService.updateFoodRatings(rathbone.getMenuItemName(), userEmail, givenStars, totalGivenStars, totalMaxStars, averageStars);

        rathbone.setGivenStars(givenStars);
        rathbone.setTotalGivenStars(totalGivenStars);
        rathbone.setTotalMaxStars(totalMaxStars);
        rathbone.setAverageStars(averageStars);
        rathbone.setUserEmail(userEmail);

        return ResponseEntity.ok(rathbone);
    }
}