package com.mygenomebox.www.common.config.spring;

import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

/**
* @author sidnancy
*/

public class RoutingDataSource extends AbstractRoutingDataSource {
  @Override
  protected Object determineCurrentLookupKey() {
    return ContextHolder.getDataSourceType();
  }
}