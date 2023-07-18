package com.pp.backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.pp.backend.entity.HoursOfOperation;
import com.pp.backend.service.HoursOfOperationService;

import java.util.List;

@RestController
@RequestMapping("/hours-of-operation")
public class HoursOfOperationController {
    private final HoursOfOperationService hoursOfOperationService;

    public HoursOfOperationController(HoursOfOperationService hoursOfOperationService) {
        this.hoursOfOperationService = hoursOfOperationService;
    }

    @GetMapping
    public ResponseEntity<List<HoursOfOperation>> getHoursOfOperations() {
        List<HoursOfOperation> hoursOfOperations = hoursOfOperationService.getHoursOfOperation();
        return ResponseEntity.ok(hoursOfOperations);
    }
}
