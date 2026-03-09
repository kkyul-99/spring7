package com.java.game.repository;

import com.java.game.entity.Trainee;
import com.java.game.entity.Gender;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TraineeRepository extends JpaRepository<Trainee,Long>{
    List<Trainee> findByGender(Gender gender);
}
