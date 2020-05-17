package com.ct.erp.report.web;

import com.aliyun.oss.ClientException;
import com.aliyun.oss.OSSClient;
import com.aliyun.oss.OSSException;
import com.ct.erp.cars.dao.CarDao;
import com.ct.erp.common.utils.GlobalConfigUtil;
import com.ct.erp.common.web.SimpleActionSupport;
import com.ct.erp.core.security.SecurityUtils;
import com.ct.erp.core.security.SessionInfo;
import com.ct.erp.lib.entity.*;
import com.ct.erp.loan.dao.VehicleDao;
import com.ct.erp.rent.dao.ContractAreaDao;
import com.ct.erp.report.dao.ReportDao;
import com.ct.erp.rotation.dao.RotationDao;
import com.ct.erp.util.HttpUtils;
import com.ct.erp.util.OssProperty;
import com.ct.erp.util.UcmsWebUtils;
import net.sf.json.JSONObject;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.file.Path;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@SuppressWarnings("serial")
@Scope("prototype")
@Controller("qiyuan.reportAction")
public class ReportAction extends SimpleActionSupport {
    @Autowired
    private ReportDao reportDao;

    @Autowired
    private CarDao carDao;
    @Autowired
    private VehicleDao vehicleDao;
    @Autowired
    private ContractAreaDao areaDao;


    private Cars cars;

    private Vehicle vehicle;

    private ContractArea contractArea;

    public Cars getCars() {
        return cars;
    }

    public void setCars(Cars cars) {
        this.cars = cars;
    }

    private OSSClient getOssClient() {
        String endpoint = OssProperty.getEndPoint();
        String accessKeyId = OssProperty.getAccessKeyId();
        String accessKeySecret = OssProperty.getAccessKeySecret();
        return new OSSClient(endpoint, accessKeyId,accessKeySecret);
    }

    //private List<File> file;
    private String fileFileName;
    private String fileFileContentType;
    private String filePath;
    private File file;

    public void setFile(File file) {
        this.file = file;
    }

    public File getFile() {
        return file;
    }
    /*  public List<File> getFile() {
        return file;
    }

    public void setFile(List<File> file) {
        this.file = file;
    }*/

    public String getFileFileName() {
        return fileFileName;
    }

    public void setFileFileName(String fileFileName) {
        this.fileFileName = fileFileName;
    }

    public String getFileFileContentType() {
        return fileFileContentType;
    }

    public void setFileFileContentType(String fileFileContentType) {
        this.fileFileContentType = fileFileContentType;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    //private File reportFile;//命名应该和上传页面name属性值保持一致
   private CheckTask check;

    public CheckTask getCheck() {
        return check;
    }

    public void setCheck(CheckTask check) {
        this.check = check;
    }

    public Long getCheckId() {
        return checkId;
    }

    public void setCheckId(Long checkId) {
        this.checkId = checkId;
    }

    // private String reportFileBase64;
   private Long checkId;



    public String toEdit(){
        //rotation = rotationDao.get(rotationId);
      check =  reportDao.get(checkId);

        if(StringUtils.isEmpty(check.getValuation())){
            check.setValuation("");
        }
        else{
            Double val = Double.valueOf(check.getValuation())/10000.00;
            check.setValuation(String.valueOf(val));
        }

        cars = carDao.get(check.getCarId());
        if(cars.equals("")|| cars.equals(null)||
                StringUtils.isEmpty(cars.toString())){
            cars.setName("");
        }

        return "toEdit";
    }

    public String findOne(){
        //rotation = rotationDao.get(rotationId);
        check =  reportDao.get(checkId);
        if(StringUtils.isEmpty(check.getValuation())){
            check.setValuation("");
        }
        else{
            Double val = Double.valueOf(check.getValuation())/10000.00;
            check.setValuation(String.valueOf(val));
        }

        cars = carDao.get(check.getCarId());

        if(cars.equals("")|| cars.equals(null)||
                StringUtils.isEmpty(cars.toString())){
            cars.setName("");
        }
       System.out.println(cars.getName());

        return "findOne";
    }

    /**
     * 获取车300估值
     * @throws Exception
     */
    public void getCarValuation() throws Exception{

        HttpServletResponse response =ServletActionContext.getResponse();

        JSONObject result=new JSONObject();
        PrintWriter out = response.getWriter();



        vehicle = vehicleDao.get(check.getCarId());

        contractArea = areaDao.get(check.getCarId());

        String areaId = contractArea.getSiteArea().getId().toString();

        String kindId = vehicle.getKind().getId().toString();

        Double mile = Double.valueOf(vehicle.getMileageCount());

        SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM");


        String registMonth = vehicle.getRegistMonth();
        String regDate = registMonth.substring(0,7);

        String jsonString = HttpUtils.sendGet(GlobalConfigUtil.get("che300.priceUrl")+
                "?token="+GlobalConfigUtil.get("che300.token")+"&modelId="+kindId+"&regDate="+
                regDate+"&mile="+mile+"&zone="+areaId);

        com.alibaba.fastjson.JSONObject obj= com.alibaba.fastjson.JSONObject.parseObject(jsonString);
        String status =obj.getString("status");
        if(status.equals("1")){
            String carValue = obj.getString("eval_price");

            System.out.println(carValue);

            result.put("resultCode","200");

            result.put("carValue",carValue);
            out.print(result);
        }
        else{
            result.put("resultCode","600");
            out.print(result);
        }
    }

    public void edit(){
        //Rotation rotation = rotationDao.load(this.rotation.getId());
        HttpServletResponse response = ServletActionContext.getResponse();
        SessionInfo sessionInfo= SecurityUtils.getCurrentSessionInfo();
        try {
            CheckTask check1 = reportDao.load(this.check.getTaskId());
            Cars cars = carDao.load(this.check.getCarId());
            /*cars.setName("");
            carDao.getSession().flush();*/
            cars.setName(this.cars.getName());
            System.out.println(cars.getName());

            carDao.getSession().flush();

            check1.setReport_type(this.check.getReport_type());
            check1.setReport_url(this.check.getReport_url());

            Double val = Double.valueOf(check.getValuation())*10000;
            check1.setValuation(String.valueOf(val));



           reportDao.getSession().flush();

            UcmsWebUtils.ajaxOutPut(response, "success");
        }  catch (Exception e) {
        e.printStackTrace();
    }
    }

    /**
     * 文件上传的方法
     */
    public String simpleFileupload()throws Exception{


        HttpServletRequest request=ServletActionContext.getRequest();
        HttpServletResponse response =ServletActionContext.getResponse();
        request.setCharacterEncoding("UTF-8");
        response.setHeader("Content-type", "text/html;charset=UTF-8");

        JSONObject result=new JSONObject();
        PrintWriter out = response.getWriter();

        CheckTask check = reportDao.load(this.check.getTaskId());
       check.setReport_url("");

          reportDao.getSession().flush();


        File file = new File(fileFileName);
       // String path ="c://"+fileFileName;

        InputStream input = new FileInputStream(file);

        OSSClient ossClient = getOssClient();
        String vehicleBucket = OssProperty.getBucket();
        String folderName = "check/" + "file";

        String key = folderName + "/" + check.getReport_type()+ "/"+UUID.randomUUID();

        //ossClient.putObject(vehicleBucket, key,input );

        try {
            // Do some operations with the instance here, such as put object...
           // client.putObject(...);
            ossClient.putObject(vehicleBucket, key,input );
        } catch (OSSException oe) {
            System.out.println("Caught an OSSException, which means your request made it to OSS, "
                    + "but was rejected with an error response for some reason.");
            System.out.println("Error Message: " + oe.getErrorCode());
            System.out.println("Error Code:       " + oe.getErrorCode());
            System.out.println("Request ID:      " + oe.getRequestId());
            System.out.println("Host ID:           " + oe.getHostId());
        } catch (ClientException ce) {
            System.out.println("Caught an ClientException, which means the client encountered "
                    + "a serious internal problem while trying to communicate with OSS, "
                    + "such as not being able to access the network.");
            System.out.println("Error Message: " + ce.getMessage());
            result.put("resultCode", "600");
            out.print(result);
            return null;

        }
        String url =OssProperty.getHost() +"/" + key;
        check.setReport_url(url);
        reportDao.getSession().flush();
        System.out.println(check.getReport_url());

        result.put("resultCode", "200");
        result.put("url",check.getReport_url());
        out.print(result);
        return null;




    }

    //picFileupload
    /**
     * 图片上传的方法
     */
    /*public String picFileupload1()throws Exception{
        HttpServletRequest request=ServletActionContext.getRequest();
        HttpServletResponse response =ServletActionContext.getResponse();
        request.setCharacterEncoding("UTF-8");
        response.setHeader("Content-type", "text/html;charset=UTF-8");

        JSONObject result=new JSONObject();
        PrintWriter out = response.getWriter();
        String path = ServletActionContext.getServletContext().getRealPath("/upload");
        File file = new File(path);
        if (!file.exists()) {
            file.mkdir();
        }
        String[] fileSuffix = new String[] { ".png"};
        try {
            if(this.getFile() != null && !this.getFile().equals("")){
                for(int j=0;j<this.getFile().size();j++){
                    File f = this.getFile().get(j);
                    String []filename=fileFileName.split(",");
                    // 判断文件格式
                    for (int i = 0; i < fileSuffix.length; i++) {
                        for(int s=0;s<filename.length;s++){
                            if (!filename[s].endsWith(fileSuffix[i])) {
                                result.put("resultCode", "600");
                                out.print(result);
                                return null;
                            }
                        }
                    }
                    SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
                    StringBuffer sb=new StringBuffer();
                    String []s=filename[j].split("\\.");
                    for (int i = 0; i < s.length; i++) {
                        if(i==0){
                            sb.append(s[i]);
                            sb.append(sdf.format(new Date()));
                            sb.append(".");
                        }else{
                            sb.append(s[i]);
                        }
                    }
                    FileInputStream inputStream = new FileInputStream(f);
                    String name=sb.toString();

                    String filepath=path + "\\" + name;
                    FileOutputStream outputStream = new FileOutputStream(filepath);
                    byte[] buf = new byte[1024];
                    int length = 0;
                    while ((length = inputStream.read(buf)) != -1) {
                        outputStream.write(buf, 0, length);
                    }

                    result.put("filepath", filepath);
                    inputStream.close();
                    outputStream.flush();
                }
            }
            result.put("resultCode", "200");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("resultCode", "500");
        }
        out.print(result);
        return null;
    }*/

}
