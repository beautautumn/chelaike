package com.ct.erp.market.service;

import com.ct.erp.lib.entity.Market;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.market.dao.MarketDao;
import com.ct.erp.sys.dao.StaffDao;
import com.ct.erp.util.DataSync;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;
import java.util.List;

@Service
@Transactional
public class MarketService {
    @Autowired
    private MarketDao marketDao;
    @Autowired
    private StaffDao staffDao;
    @Autowired
    private DataSync dataSync;

    public List<Market> findValidMarketList(){
        return this.marketDao.findValidMarketList();
    }
    private static String md5(String pwd) throws NoSuchAlgorithmException {
        MessageDigest md5= MessageDigest.getInstance("MD5");
        return Hex.encodeHexString(md5.digest((pwd).getBytes()));
    }

    /*public static void main(String[] args) throws NoSuchAlgorithmException {
        String mobile = "13800138000";
        System.out.println(md5(StringUtils.substring(mobile, -6)));
    }*/

    public Market findMarketById(long id) { return this.marketDao.load(id); }

    public ServiceResult createMarket(Market market){

        List<Staff> staffs = staffDao.findByLoginName(market.getMarketMobile());
        Integer cnt = marketDao.countMarketMobile(market.getMarketMobile());
        if((staffs != null && staffs.size() > 0) || cnt > 0){
            return new ServiceResult(false,"手机号"+market.getMarketMobile()+"已被注册,请使用其它手机号码进行注册.");
        }
        try {
            marketDao.save(market);
           /* Staff staff = new Staff();
            staff.setLoginName(market.getMarketMobile());
            staff.setName(market.getMarketName());
            staff.setStatus("1");
            String loginPassword = StringUtils.substring(staff.getLoginName(), -6);
            staff.setLoginPwd(md5(loginPassword));
            staff.setCreateTime(new Timestamp(System.currentTimeMillis()));
            staff.setUpdateTime(new Timestamp(System.currentTimeMillis()));
            staff.setMarket(market);
            staffDao.save(staff);
            dataSync.publishStaffToRuby(staff.getId().toString(), loginPassword);*/
            return new ServiceResult(true, "商户创建成功!");
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            e.printStackTrace();
        }
        return new ServiceResult(false, "商户创建失败!");
    }

    public void doFrozen(Long marketId) {
        Market marketToUpdate = marketDao.load(marketId);
        marketToUpdate.setMarketStatus("frozen");
        marketDao.getSession().flush();
        staffDao.updateByMarketId(marketId, "0");
    }

    public void doUnFrozen(Long marketId) {
        Market marketToUpdate = marketDao.load(marketId);
        marketToUpdate.setMarketStatus("normal");
        marketDao.getSession().flush();
        staffDao.updateByMarketId(marketId, "1");
    }

    public void doCancel(Long marketId) {
        Market marketToUpdate = marketDao.load(marketId);
        marketToUpdate.setMarketStatus("cancelled");
        marketDao.getSession().flush();
        staffDao.updateByMarketId(marketId, "0");
    }

    public Long convertMarketId2CompanyId (Long marketId) {
        return marketDao.getCompanyId(marketId);
    }
}
