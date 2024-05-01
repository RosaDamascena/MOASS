package com.moass.api.domain.user.repository;

import com.moass.api.domain.user.entity.User;
import com.moass.api.domain.user.entity.UserDetail;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface UserRepository extends ReactiveCrudRepository<User, Integer> {

    @Query("SELECT u.user_id, u.user_email, u.status_id, u.password, u.profile_img, u.background_img, " +
            "u.layout, u.connect_flag, s.card_serial_id, s.job_code, s.team_code, s.user_name ,u.position_name " +
            "FROM User u INNER JOIN SsafyUser s ON u.user_id = s.user_id " +
            "WHERE u.user_email = :userEmail")
    Mono<UserDetail> findUserDetailByUserEmail(String userEmail);

    @Query("SELECT u.user_id, u.user_email, u.status_id, u.password, u.profile_img, u.background_img, " +
            "u.layout, u.connect_flag, s.card_serial_id, s.job_code, s.team_code, s.user_name, u.position_name " +
            "FROM User u INNER JOIN SsafyUser s ON u.user_id = s.user_id " +
            "WHERE s.team_code = :teamCode " +
            "ORDER BY s.user_name ASC")
    Flux<UserDetail> findAllTeamUserByTeamCode(String teamCode);
    Mono<User> findByUserEmail(String userEmail);

    Mono<User> findByUserEmailOrUserId(String userEmail, String userId);

    @Query("INSERT INTO `User` (user_id, user_email, password) " +
            "VALUES (:#{#user.userId}, :#{#user.userEmail}, :#{#user.password})")
    Mono<User> saveForce(User user);

    Mono<User>  findByUserId(String userId);
}

