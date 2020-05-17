package com.tianche.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

public class DataTimeJsonSerializer extends JsonSerializer<Date> {

	@Override
	public void serialize(Date date, JsonGenerator jg, SerializerProvider sp)
			throws IOException, JsonProcessingException {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String formattedDate = formatter.format(date);
		jg.writeString(formattedDate);
	}

}
