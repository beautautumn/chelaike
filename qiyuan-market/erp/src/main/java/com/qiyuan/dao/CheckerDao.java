package com.qiyuan.dao;

import org.apache.ibatis.annotations.Param;

public interface CheckerDao {
    int countCheck(@Param(value = "checkerId") Long checkerId, @Param(value = "taskTypeWhere") String taskTypeWhere);
}
