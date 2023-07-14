package com.pp.backend.controller;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import java.util.List;
import com.pp.backend.entity.Rathbone;
import com.pp.backend.entity.RathboneRatingRequest;
import com.pp.backend.service.RathboneService;

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
    
    @PostMapping
    public ResponseEntity<Rathbone> createRathboneOption(@RequestBody Rathbone rathbone) {
        Rathbone createdRathbone = rathboneService.createRathboneOption(rathbone);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdRathbone);
    }
    
    @PutMapping("/{rathboneId}")
    public ResponseEntity<Rathbone> updateFoodRatings(@PathVariable String rathboneId,
                                                    @RequestParam boolean upvoted,
                                                    @RequestParam boolean downvoted) {
        long rathboneIdLong;
        try {
            rathboneIdLong = Long.parseLong(rathboneId);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().build();
        }

        Rathbone rathbone = rathboneService.getRathboneById(rathboneIdLong);
        if (rathbone == null) {
            return ResponseEntity.notFound().build();
        }

        int upvotes = rathbone.getUpvotes();
        int downvotes = rathbone.getDownvotes();

        if (upvoted && !rathbone.isUpvoted()) {
            upvotes++;
            if (rathbone.isDownvoted()) {
                downvotes--;
            }
        } else if (!upvoted && rathbone.isUpvoted()) {
            upvotes--;
        }

        if (downvoted && !rathbone.isDownvoted()) {
            downvotes++;
            if (rathbone.isUpvoted()) {
                upvotes--;
            }
        } else if (!downvoted && rathbone.isDownvoted()) {
            downvotes--;
        }

        rathboneService.updateFoodRatings(rathbone.getMenuItemName(), upvotes, downvotes);

        Rathbone updatedRathbone = new Rathbone(rathbone.getId(), rathbone.getMealType(), rathbone.getCourseName(),
                rathbone.getMenuItemName(), rathbone.getCalorieText(), rathbone.getAllergenNames(), upvotes, downvotes,
                rathbone.isUpvoted(), rathbone.isDownvoted());

        return ResponseEntity.ok(updatedRathbone);
    }
}