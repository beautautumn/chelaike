package com.qiyuan.dao;

import org.apache.ibatis.annotations.Param;

import java.util.Date;

public interface CarsDao {
    int updateCarsState(@Param(value = "carsId") Long carsId, @Param(value = "stateSet") String stateSet, @Param(value = "stateWhere") String[] stateWhere, @Param(value = "staffId")Long staffId);
    int updateCheckState(@Param(value = "carsId") Long carsId, @Param(value = "stateSet") String stateSet, @Param(value = "stateWhere") String[] stateWhere, @Param(value = "staffId")Long staffId);
    int updateCarsStateIn(@Param(value = "carsId") Long carsId, @Param(value = "stateSet") String stateSet, @Param(value = "stateWhere") String[] stateWhere, @Param(value = "comeDate") Date comDate, @Param(value = "staffId")Long staffId);
}
