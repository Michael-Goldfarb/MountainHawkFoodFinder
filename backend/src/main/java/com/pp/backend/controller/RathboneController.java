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
}
