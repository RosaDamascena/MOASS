package com.moass.api.domain.reservation.controller;

import com.moass.api.domain.reservation.dto.ReservationInfoCreateDto;
import com.moass.api.domain.reservation.service.ReservationInfoService;
import com.moass.api.global.annotaion.Login;
import com.moass.api.global.auth.dto.UserInfo;
import com.moass.api.global.exception.CustomException;
import com.moass.api.global.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/reservationInfo")
@RequiredArgsConstructor
public class ReservationInfoController {

    final ReservationInfoService reservationInfoService;
    @PostMapping
    public Mono<ResponseEntity<ApiResponse>> createReservationInfo(@Login UserInfo userInfo, @RequestBody ReservationInfoCreateDto reservationInfoCreateDto){
        return reservationInfoService.createReservationInfo(userInfo,reservationInfoCreateDto)
                .flatMap(reservationInfoId -> ApiResponse.ok("예약 정보 생성 성공", reservationInfoId))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("예약 정보 생성 실패 : " + e.getMessage(), e.getStatus()));
    }

    /**
    @GetMapping("/today")
    public Mono<ResponseEntity<ApiResponse>> gettodayReservationInfo(@Login UserInfo userInfo){
        return reservationInfoService.getTodayReservationInfo(userInfo)
                .collectList()
                .flatMap(reservationInfos -> ApiResponse.ok("오늘 예약 정보 조회 성공", reservationInfos))
                .onErrorResume(CustomException.class, e -> ApiResponse.error("오늘 예약 정보 조회 실패 : " + e.getMessage(), e.getStatus()));
    }
    */
}
