package com.pp.backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import java.util.List;
import com.pp.backend.entity.Rathbone;
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
    public ResponseEntity<Void> updateFoodRatings(@PathVariable long rathboneId,
                                                  @RequestParam boolean upvoted,
                                                  @RequestParam boolean downvoted) {
        Rathbone rathbone = rathboneService.getRathboneById(rathboneId);
        if (rathbone == null) {
            return ResponseEntity.notFound().build();
        }
        
        int upvotes = rathbone.getUpvotes();
        int downvotes = rathbone.getDownvotes();
        
        if (upvoted && !rathbone.isUpvoted()) {
            upvotes++;
            rathbone.setUpvoted(true);
            if (rathbone.isDownvoted()) {
                downvotes--;
                rathbone.setDownvoted(false);
            }
        } else if (!upvoted && rathbone.isUpvoted()) {
            upvotes--;
            rathbone.setUpvoted(false);
        }
        
        if (downvoted && !rathbone.isDownvoted()) {
            downvotes++;
            rathbone.setDownvoted(true);
            if (rathbone.isUpvoted()) {
                upvotes--;
                rathbone.setUpvoted(false);
            }
        } else if (!downvoted && rathbone.isDownvoted()) {
            downvotes--;
            rathbone.setDownvoted(false);
        }
        
        rathboneService.updateFoodRatings(rathboneId, upvotes, downvotes, rathbone.isUpvoted(), rathbone.isDownvoted());
        
        return ResponseEntity.ok().build();
    }
}
