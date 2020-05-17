package com.tianche.core.exception;

import com.tianche.controller.Result;
import com.tianche.util.JsonUtil;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.AbstractHandlerExceptionResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Created by jf on 15/5/13.
 */
public class DefaultExceptionHandler extends AbstractHandlerExceptionResolver {
    @Override
    protected ModelAndView doResolveException(
			HttpServletRequest httpServletRequest,
			HttpServletResponse response, Object o, Exception e) {
		Result result = Result.create();
		result.setSuccess(false);
		if (!(e instanceof TiancheException)) {
			e.printStackTrace();
			e = new TiancheException(ErrorStatus.UNKOWN, "调用失败");
		}
		TiancheException ex1 = (TiancheException)e;
		result.add("code", ex1.getErrorStatus().getCode());
		result.add("error", ex1.getErrorStatus().getMessage());
		result.add("message", ex1.getLocalMessage());
		try {
			response.setContentType("application/json");
			response.setCharacterEncoding("utf-8");
			response.getWriter().write(JsonUtil.bean2Json(result));
		} catch (IOException ex) {
			ex.printStackTrace();
		}
		return new ModelAndView();
	}
}
