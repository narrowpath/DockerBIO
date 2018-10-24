package com.mygenomebox.www.common.config.spring;

import java.lang.reflect.Method;

import org.apache.log4j.Logger;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

/**
 * Order를 주는 이유는 다른 기타의 AOP 설정보다 DataSource 설정이 먼저 들어가게 하기 위해서이다.
 *
 * @author sidnancy81
 *
 */
@Aspect
@Component
@Order(value = 1)
public class ExecutionLoggingAspect implements InitializingBean {
    private static final Logger logger = Logger.getLogger(ExecutionLoggingAspect.class);

	@Around("execution(* com.mygenomebox..*Service.*(..))")

	public Object doServiceProfiling(ProceedingJoinPoint joinPoint) throws Throwable {

		logger.debug("@Service 시작");

		// Annotation을 읽어 들이기 위해 현재의 method를 읽어 들인다.
		final String methodName = joinPoint.getSignature().getName();
		final MethodSignature methodSignature = (MethodSignature) joinPoint.getSignature();
		Method method = methodSignature.getMethod();
		if (method.getDeclaringClass().isInterface()) {
			method = joinPoint.getTarget().getClass().getDeclaredMethod(methodName, method.getParameterTypes());
		}
		// Annotation을 가져온다.
		DataSource dataSource = (DataSource) method.getAnnotation(DataSource.class);
		if (dataSource != null) {
			logger.debug("==user selection datasource==");
			// Method에 해당 dataSource관련 설정이 있을 경우 해당 dataSource의 value를 읽어 들인다.
			ContextHolder.setDataSourceType(dataSource.value());
		}else {
			logger.debug("==default datasource==");
		}
		logger.debug("DataSource ===> " + ContextHolder.getDataSourceType());

		Object returnValue = joinPoint.proceed();
		ContextHolder.clearDataSourceType();

		logger.debug("@Service 끝");

		return returnValue;

	}

	@Override
	public void afterPropertiesSet() throws Exception {
		// TODO Auto-generated method stub

	}
}