package com.ct.erp.rent.service;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ct.erp.common.exception.ServiceException;
import com.ct.erp.constants.sysconst.Const;
import com.ct.erp.lib.entity.Pic;
import com.ct.erp.lib.entity.Staff;
import com.ct.erp.rent.dao.PicDao;
import com.ct.erp.util.UcmsWebUtils;
import com.ct.util.image.AverageImageScale;

@Service
public class PicService {

	@Autowired
	private PicDao PicDao;
	
	public List<Pic> findPicByObjId(Long objId){
		return this.PicDao.findPicByObjId(objId);
	}
	
	public Pic findPicById(Long picId){
		return this.PicDao.findPicById(picId);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = ServiceException.class)
	public void update(Pic pic){
		this.PicDao.update(pic);
	}
	
	
	@Transactional(propagation = Propagation.NESTED, rollbackFor = Exception.class)
	public Pic doSaveUploadEntity(String picName, Staff staff,
			String picUrl, String smallPicUrl, Long objId,String imageType,String picType)throws Exception{
		try {
				Pic entity=new Pic();
				entity.setStaff(staff);
				entity.setPicName(picName);
				entity.setObjId(objId);
				entity.setPicUrl(picUrl);
				entity.setSmallPicUrl(smallPicUrl);
				entity.setPicType(picType);
				entity.setUploadDate(UcmsWebUtils.now());
				return this.PicDao.save(entity);
		} catch (Exception e) {
			throw e;
		}
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public void doDelUploadEntity(Long picId)throws Exception{
		try {
			Pic pic = this.findPicById(picId);
			deleteSinglePic(Const.IMAGE_TYPE_STORE_PIC,pic.getPicName());
			this.PicDao.delete(pic);
		} catch (Exception e) {
			throw e;
		}
	}
	
	
	public String[] doUploadFileStream(File fileObj,
			String localFileName,String imageType) throws Exception {
		String vehiclePath = getPicPath(imageType);
		File vehicleDir = new File(vehiclePath);
		if (!vehicleDir.exists()) {
			vehicleDir.mkdir();
		}
		if (fileObj != null) {
			String fileNamePrefix = new SimpleDateFormat("yyyyMMddHHmmss")
					.format(new Date());
			String newFileName = fileNamePrefix
					+ localFileName.substring(localFileName.lastIndexOf("."));
			String smallFileName = fileNamePrefix + "_small"
					+ localFileName.substring(localFileName.lastIndexOf("."));

			// 从临时目录复制图片到服务器实际存储目录
			File saveFile = new java.io.File(vehiclePath, newFileName);
			FileUtils.copyFile(fileObj, saveFile);

			// 压缩图片
			File smallFile = new File(vehiclePath, smallFileName);
			AverageImageScale.resizeFix(saveFile, smallFile, 900, 600);

			String picAddr = getWebPicAddrPrefix(imageType)
					+ newFileName;
			String smallPicAddr = getWebPicAddrPrefix(imageType)
					+ smallFileName;
			return new String[]{newFileName,picAddr,smallPicAddr,};
		}
		return null;
	}
	
	
	private String[] deleteSinglePic(String folder,String picName) throws Exception {
		String vehiclePath = getPicPath(folder);
		String deleteFileName = vehiclePath + "/" + picName;
		String[] picNameArr = picName.split("\\.");
		String smallFileName = picNameArr[0] + "_small." + picNameArr[1];
		String deleteSmallName = vehiclePath + "/" + smallFileName;
		deleteFile(deleteFileName);
		deleteFile(deleteSmallName);
		return new String[] { deleteFileName, smallFileName, deleteSmallName };
	}
	

	private void deleteFile(String fileName) {
		java.io.File f = new java.io.File(fileName);
		if (f.exists()) {
			f.delete();
		}
	}

	/**
	 * 获取图片存储根路径
	 * 
	 * @return
	 */
	private String getPicRootPath(String objectFlolder) {
		return Const.IMAGE_SAVEPATH + "/" +objectFlolder+"";
	}

	/**
	 * 获取图片存储目录
	 * 
	 * 
	 * @return
	 */
	public String getPicPath(String objectFlolder) {
		return getPicRootPath(objectFlolder) + "/" + "pic";
	}

	/**
	 * 获取图片web访问路径前缀
	 * 
	 * 
	 * @return
	 */
	public String getWebPicAddrPrefix(String objectFlolder) {
		return Const.IMAGE_ADDR + "/"+objectFlolder+"/" + "pic" + "/";
	}

	public PicDao getPicDao() {
		return PicDao;
	}

	public void setPicDao(PicDao picDao) {
		PicDao = picDao;
	}
	public Pic findByContractId(Long contractId) {
		return this.PicDao.findByContractId(contractId);
	}

	public Pic findByShopContractId(Long shopContractId) {
		return this.PicDao.findByShopContractId(shopContractId);
	}
	
}