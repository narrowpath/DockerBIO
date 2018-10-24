package com.mygenomebox.helix.boot.asyncJob.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mygenomebox.helix.boot.asyncJob.entity.AsyncJobHist;
import com.mygenomebox.www.common.config.ibatis.MyBatisDao;

@Mapper
@MyBatisDao
public interface AsyncJobMapper {
    List<AsyncJobHist> asyncJobHistList();
    int insertOrUpdate(AsyncJobHist asyncJobHist);
}
