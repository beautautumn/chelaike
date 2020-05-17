package com.ct.erp.util;
import com.ct.erp.common.spring.SpringContextHolder;
import com.ct.erp.lib.entity.FirstCheck;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;
import redis.clients.jedis.*;
import java.util.HashMap;
import com.alibaba.fastjson.JSONObject;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;


@Component
public class DataSync {

    @Resource(name="datesyncRedisTemplate")
    private RedisTemplate redisTemplate;// = SpringContextHolder.getBean(RedisTemplate.class);
    private Jedis jedis;
    private JedisPool jedisPool;
    public  DataSync(){
    }
    /*@PostConstruct
    private void init(){
        initialPool();
        initialShardedPool();
        jedis = jedisPool.getResource();
        Long db = jedis.getDB();
        System.out.println("db==="+db);
    }*/
    /**
     * 初始化非切片池
     */
    /*private synchronized void initialPool() {
        // 池基本配置
        if(null == jedisPool){
            JedisPoolConfig config = new JedisPoolConfig();
            config.setMaxTotal(20);
            config.setMaxIdle(5);
            config.setMaxWaitMillis(1000l);
            config.setTestOnBorrow(false);
            jedisPool = new JedisPool(config,"redis-master.anpxd.com",6379, 3000, "7ujm*IK<9ol.)P:?", 1);
        }
    }*/

    private void initialShardedPool() {

    }
    // redis.lpush 'chasqui:chasqui-inbox', {"channel": "user_sync", "syn_source_id": "1", "to": "chelaike"}.to_json

    /**
     * @param channel
     *          user_sync
     *          shop_sync
     *          pc_token_sync
     *          company_sync
     *          car_sync
     *          announcement_sync
     * @param sync_resource_id
     */
    public void  publishToRuby(String channel, String sync_resource_id){
        HashMap<String, String> payload = new HashMap<String, String>();
        payload.put("channel", channel);
        payload.put("syn_source_id", sync_resource_id);
        payload.put("to", "chelaike");

        String json = JSONObject.toJSONString(payload);
//        jedis.lpush("chasqui:chasqui-inbox", json);
        redisTemplate.opsForList().leftPush("chasqui:chasqui-inbox", json);
//        redisTemplate.opsForList().leftPush("chasqui-inbox", json);
    }
    public void  publishSMSToRuby(String phone, String code){
        HashMap<String, String> payload = new HashMap<String, String>();
        payload.put("channel", "sms_sync");
        payload.put("phone", phone);
        payload.put("code", code);
        payload.put("to", "chelaike");

        String json = JSONObject.toJSONString(payload);
        redisTemplate.opsForList().leftPush("chasqui:chasqui-inbox", json);
    }
    //{"channel": "user_sync", "syn_source_id": "1", "to": "chelaike", "pwd": "123456"}
    public void  publishStaffToRuby(String staffId, String pwd){
        HashMap<String, String> payload = new HashMap<String, String>();
        payload.put("channel", "user_sync");
        payload.put("syn_source_id", staffId);
        payload.put("to", "chelaike");
        if(StringUtils.isNotBlank(pwd)){
            payload.put("pwd", pwd);
        }

        String json = JSONObject.toJSONString(payload);
        redisTemplate.opsForList().leftPush("chasqui:chasqui-inbox", json);
//        redisTemplate.opsForList().leftPush("chasqui-inbox", json);
//        jedis.lpush("chasqui:chasqui-inbox", json);
    }
    public void  publishTradeToRuby(String carId){
        HashMap<String, String> payload = new HashMap<String, String>();
        payload.put("channel", "car_sync");
        payload.put("syn_source_id", carId);
        payload.put("to", "chelaike");

        String json = JSONObject.toJSONString(payload);
        redisTemplate.opsForList().leftPush("chasqui:chasqui-inbox", json);
    }
    public void  publishMarketToRuby(String marketId){
        HashMap<String, String> payload = new HashMap<String, String>();
        payload.put("channel", "company_sync");
        payload.put("syn_source_id", marketId);
        payload.put("to", "chelaike");

        String json = JSONObject.toJSONString(payload);
        redisTemplate.opsForList().leftPush("chasqui:chasqui-inbox", json);
    }

    public void publishFirstCheckMessageToRuby(FirstCheck firstCheck) {
        HashMap<String, String> payload = new HashMap<String, String>();
        payload.put("channel", "system_message_sync");
        payload.put("to", "chelaike");
        payload.put("message_type", "first_check_appointment");
        payload.put("item_type", "first_check_appointment");
        payload.put("item_id", firstCheck.getId().toString());
        payload.put("operator_id", firstCheck.getOperatorId().toString());
        payload.put("to_user_id", firstCheck.getCheckerId().toString());

        String json = JSONObject.toJSONString(payload);
        redisTemplate.opsForList().leftPush("chasqui:chasqui-inbox", json);
    }

    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext(new String[] { "spring-redis.xml" });
        RedisTemplate redisTemplate = (RedisTemplate) context.getBean("datesyncRedisTemplate");
        HashMap<String, String> payload = new HashMap<String, String>();
        payload.put("channel", "company");
        payload.put("syn_source_id", "1");
        payload.put("to", "chelaike");
        String json = JSONObject.toJSONString(payload);
        redisTemplate.opsForList().leftPush("chasqui:chasqui-inbox", json);
    }
}
