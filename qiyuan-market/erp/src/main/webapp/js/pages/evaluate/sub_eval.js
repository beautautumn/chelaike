/************************************************/
/*提交评估表单
/*Author: xueyufish
*/
sub_eval = (function() {

    var _get_conditions_level = function(item_code) {

        var damage_levels = "";
        if ($("input[type='radio'][name='rdConditionsExcp_" + item_code + "']:checked").val() == 'on') {
            damage_levels = 'noExcept';
        } else {
            var arr_damage_levels = new Array();
            $("input[type='checkbox'][name='chkConditionsLevel_" + item_code + "']:checked").each(function(i) {
                arr_damage_levels[i] = $(this).val();
            });

            for (var i = 0; i < arr_damage_levels.length; i++) {
                damage_levels += arr_damage_levels[i] + ",";
            }
            var reg = /,$/gi;
            damage_levels = damage_levels.replace(reg, "");
        }

        return damage_levels;
    }

    var _get_conditions_desc = function(item_code) {
        if ($("input[type='radio'][name='rdConditionsExcp_" + item_code + "']:checked").val() != 'on') {
            return $('#txtCondition_' + item_code).val();
        } else {
            return '';
        }

    }

    /**
     * 获取工况json
     * {"itemCode":"24","evalKind":"裂痕 ,钣金胶差异 ","evalDesc":"","imgUrl":""}
     * 此方法暂时写死，后面可以优化
     */
    var _get_conditions_json = function() {
        var result = [];

        for (var i = 142; i <= 149; i++) {
            var json = {
                "itemCode": "" + i + "",
                "evalKind": _get_conditions_level("" + i + ""),
                "evalDesc": _get_conditions_desc("" + i + ""),
                "imgUrl": ""
            };
            result[i - 142] = json;
        }
        return result;
    }

    var _get_result_json = function(editType, staffId, subType) {
        //车源标识
        var acquSourceId = $("#hdAcquSourceId").val();

        //老客户
        var regularCustTag = 0;
        $("input[type='checkbox'][name='regularCustTag']:checked").each(function(i) {
            regularCustTag = 1;
        });

        //颜色变更标记
        var colorChgTag = 0;
        $("input[type='checkbox'][name='colorChgTag']:checked").each(function(i) {
            colorChgTag = 1;
        });

        var oldColor = "";
        if (colorChgTag == 1) {
            oldColor = $("#oldColor").val();
        } 

        //变速箱
        var gearsTypeTag = $("input[type='radio'][name='gearsTypeTag']:checked").val();
        if (gearsTypeTag == undefined) {
            gearsTypeTag = -1;
        }

        //涡轮增压
        var turboCharger = 0;
        $("input[type='checkbox'][name='turboCharger']:checked").each(function(i) {
            turboCharger = 1;
        });

        //车身类型        
        var carType = $("input[type='radio'][name='carType']:checked").val();
        if (carType == undefined) {
            carType = -1;
        }

        //使用性质        
        var usedType = $("input[type='radio'][name='usedType']:checked").val();
        if (usedType == undefined) {
            usedType = -1;
        }
        //环保标准
        var environmentalLevel = $("input[type='radio'][name='environmentalLevel']:checked").val();
        if (environmentalLevel == undefined) {
            environmentalLevel = -1;
        }

        //保养记录
        var maintRecordTag = $("input[type='radio'][name='maintRecordTag']:checked").val();
        if (maintRecordTag == undefined) {
            maintRecordTag = -1;
        }

        //新车质保
        var warrantyTag = $("input[type='radio'][name='warrantyTag']:checked").val();
        if (warrantyTag == undefined) {
            warrantyTag = -1;
        }

        //燃油类型
        var fuelType = $("input[type='radio'][name='fuelType']:checked").val();
        if (fuelType == undefined) {
            fuelType = -1;
        }


        //交强险
        var issurValidTag = $("input[type='radio'][name='issurValidTag']:checked").val();
        if (issurValidTag == undefined) {
            issurValidTag = -1;
        }

        //商业险
        var commIssurValidTag = $("input[type='radio'][name='commIssurValidTag']:checked").val();
        if (commIssurValidTag == undefined) {
            commIssurValidTag = -1;
        }


        //行驶证
        var drivingLicenseTag = $("input[type='radio'][name='drivingLicenseTag']:checked").val();
        if (drivingLicenseTag == undefined) {
            drivingLicenseTag = -1;
        }

        

        //登记证
        var registrationCertTag = $("input[type='radio'][name='registrationCertTag']:checked").val();
        if (registrationCertTag == undefined) {
            registrationCertTag = -1;
        }

        //车辆牌照
        var licenseCodeTag = $("input[type='radio'][name='licenseCodeTag']:checked").val();
        if (licenseCodeTag == undefined) {
            licenseCodeTag = -1;
        }

        //车钥匙
        var carKeys = $("input[type='radio'][name='carKeys']:checked").val();
        if (carKeys == undefined) {
            carKeys = -1;
        }

        //购置税
        var purchaseTaxTag = $("input[type='radio'][name='purchaseTaxTag']:checked").val();
        if (purchaseTaxTag == undefined) {
            purchaseTaxTag = -1;
        }

        //环保标记
        var environmentTag = $("input[type='radio'][name='environmentTag']:checked").val();
        if (environmentTag == undefined) {
            environmentTag = -1;
        }

        //原车发票
        var invoiceTag = $("input[type='radio'][name='invoiceTag']:checked").val();
        if (invoiceTag == undefined) {
            invoiceTag = -1;
        }

        //说明书
        var originalManualTag = 0;
        $("input[type='checkbox'][name='originalManualTag']:checked").each(function(i) {
            originalManualTag = 1;
        });

        //保修手册
        var maintManualTag = 0;
        $("input[type='checkbox'][name='maintManualTag']:checked").each(function(i) {
            maintManualTag = 1;
        });

        //三脚架
        var triangleTag = 0;
        $("input[type='checkbox'][name='triangleTag']:checked").each(function(i) {
            triangleTag = 1;
        });

        //备胎
        var spareWheelTag = 0;
        $("input[type='checkbox'][name='spareWheelTag']:checked").each(function(i) {
            spareWheelTag = 1;
        });

        //灭火器
        var extinguisherTag = 0;
        $("input[type='checkbox'][name='extinguisherTag']:checked").each(function(i) {
            extinguisherTag = 1;
        });

        //急救包
        var aidKitTag = 0;
        $("input[type='checkbox'][name='aidKitTag']:checked").each(function(i) {
            aidKitTag = 1;
        });

        //烟灰缸
        var ashtrayTag = 0;
        $("input[type='checkbox'][name='ashtrayTag']:checked").each(function(i) {
            ashtrayTag = 1;
        });

        //点烟器
        var cigarLighterTag = 0;
        $("input[type='checkbox'][name='cigarLighterTag']:checked").each(function(i) {
            cigarLighterTag = 1;
        });

        //天线
        var antennaTag = 0;
        $("input[type='checkbox'][name='antennaTag']:checked").each(function(i) {
            antennaTag = 1;
        });

        //随车工具
        var toolBoxTag = 0;
        $("input[type='checkbox'][name='toolBoxTag']:checked").each(function(i) {
            toolBoxTag = 1;
        });

        //导航卡/光盘
        var navigateDiskTag = 0;
        $("input[type='checkbox'][name='navigateDiskTag']:checked").each(function(i) {
            navigateDiskTag = 1;
        });
       
        var standardConfig = $("#standardEquip").val();
        
        
        //是否OBD
        var obdTag;
        if($("#obdTag").get(0).checked){
        	obdTag=1;
        }else{
        	obdTag=0;
        }
        
        //车门数量
        var carDoorNum=$("#carDoorNum").val();
        
        ///车型名称(品牌+车系+车型)
        var catalogueName=$("#brandName").val()+"-"+$("#seriesName").val()+"-"+$("#styleName").val();
        
        //污渍
        var stainTag=$("input[name='stainTag']:checked").val();
        //异味
        var smellTag=$("input[name='smellTag']:checked").val();
        //热点数据
        var hotareaItems=evaluate_hotspot.get_hostpot_items_all();
        //机电数据
        var conditions=evaluate_hotspot.get_condition_result();

        return {
        	"passengerNum":$("#passengerNum").val(),
        	"transferTag": $("#transferTag").val(),
        	"gearsTypeTag": gearsTypeTag,
        	"evalItem":$("#evalItem").val(),
        	"phoneNumber": $("#phoneNumber").val(),
        	"credenteBean": {
        		"commIssurValidTag": commIssurValidTag, 
        		"otherAttachment": $("#otherAttachment").val(),
        		"maintRecordTag": maintRecordTag,
        		"purchaseTaxTag": purchaseTaxTag,
        		"licenseCodeTag": licenseCodeTag,
        		"toolBoxTag": toolBoxTag,
        		"issurValidTag": issurValidTag,
        		"ashtrayTag": ashtrayTag,
        		"checkValidMonth": $("#checkValidMonth").val(),
        		"cigarLighterTag": cigarLighterTag,
        		"originalManualTag": originalManualTag,
        		"warrantyTag": warrantyTag,
        		"drivingLicenseTag": drivingLicenseTag,
        		"navigateDiskTag": navigateDiskTag,
        		"commIssurValidDate": $("#commIssurValidDate").val(),
        		"checkValidTag":"",
        		"aidKitTag": aidKitTag,
        		"antennaTag": antennaTag,
        		"standardEquip":standardConfig,
        		"issurValidDate": $("#issurValidDate").val(),
        		"carKeys": carKeys,
        		"environmentTag": environmentTag,
        		"custEquip": $("#custEquip").val(), 
        		"spareWheelTag": spareWheelTag,
        		"extinguisherTag": extinguisherTag,
        		"registrationCertTag": registrationCertTag,
        		"invoiceTag": invoiceTag,
        		"commIssurFee": $("#commIssurFee").val(),
        		"maintainMileage": '',
        		"triangleTag": triangleTag,
        		"newcarPrice": $("#newcarPrice").val(),	
        		"maintManualTag": maintManualTag,
            }, 
            "upholsteryColor": $("#upholsteryColor").val(),
            "environmentalLevel": environmentalLevel,
            "smellTag": smellTag,
            "oldLicenseCode": $("#oldLicenseCode").val(),
            "hotareaItems":hotareaItems,
            "oldColor": oldColor,
            "conditions":conditions,
            "motorCode": $("#motorCode").val(),
            "maintainItems": [],
            "fuelType": fuelType,
            "regularCustTag": regularCustTag,
        	"maintainInfo":{},
        	"usedType": usedType,
        	"obdTag":obdTag,
        	"custName": $("#custName").val(),
        	"carColor": $("#carColor").val(),
        	"vinCheckTag": $("#vinCheckTag").combobox("getValue"),
        	"registMonth": $("#registMonth").val(),
        	"surfaceGrade": $("#surfaceGrade").combobox("getValue"),
        	"outputVolume": $("#outputVolume").val(),
        	"modelCode": $("#styleCode").val(),
            "carDoorNum":carDoorNum,
            "catalogueName":catalogueName,
            "sellPoint":$("#sellPoint").val(),
            "infoSource": $("#selInfoSource").combobox("getValue"),
            "carType": carType,
            "factoryMonth": $("#factoryMonth").val(),
            "brandCode": $("#brandCode").val(),
            "stainTag":stainTag,
            "custId": $("#hdCustId").val(),
            "actualMileage": $("#actualMileage").val(),
            "driverKind":$("#driverKind").combobox("getValue"),
            "staffId": staffId,
            "acquSourceId": acquSourceId,
            "shelfGrade": $("#shelfGrade").combobox("getValue"),
            "mileageCount": $("#mileageCount").val(),
            "colorChgTag": colorChgTag,
            "upholsteryGrade": $("#upholsteryGrade").combobox("getValue"),
            "shelfCode": $("#shelfCode").val(),
            "turboCharger": turboCharger,
            "subType": subType,
            "machineGrade": $("#machineGrade").combobox("getValue"),
            "seriesCode": $("#seriesCode").val(),
            "maintainShelves":[],
            "editType": editType,
            "comprehensiveGrade":$("#comprehensiveGrade").combobox("getValue")
        };
    }

    var _validate_form = function(edit_type) {
    	if($("#selInfoSource").combobox("getValue")==''){
    		alert('请选择信息来源');
    		return;
    	}
    	
    	
        if ($("#custName").val() == "") {
            alert("请填写车主姓名!");
            $("#custName").focus();
            return false;
        }

        if ($("#phoneNumber").val() == "") {
            alert("请填写联系电话!");
            $("#phoneNumber").focus();
            return false;
        }

        if ($("#brandCode").val() == 0) {
            alert("请选择车辆品牌!");
            return false;
        }

        if ($("#seriesCode").val() == 0) {
            alert("请选择车系!");
            return false;
        }

        if ($("#styleCode").val() == 0) {
            alert("请选择车型!");
            return false;
        }

        if ($("#outputVolume").val() == "") {
            alert("请填写排气量!");
            $("#outputVolume").focus();
            return false;
        }

        var reg = /^([0-9]|[.]){1,50}$/gim;
        if (!reg.test($.trim($("#outputVolume").val()))) {
            alert("排量请输入数字!");
            $("#outputVolume").focus();
            return false;
        }


        if ($("#motorCode").val() == "") {
            alert("请填写发动机号!");
            $("#motorCode").focus();
            return false;
        }

        if ($("#shelfCode").val() == "") {
            alert("请填写车架号!");
            $("#shelfCode").focus();
            return false;
        }


        if ($("#factoryMonth").val() == "") {
            alert("请填写出厂日期!");
            $("#factoryMonth").focus();
            return false;
        }

        if ($('input:radio[name="gearsTypeTag"]:checked').val() == null) {
            alert("请选择变速箱");
            return false;
        }

        if (edit_type != 3) {

            if ($("#oldLicenseCode").val() == "") {
                alert("请填写车牌号!");
                $("#oldLicenseCode").focus();
                return false;
            }

            if ($("#registMonth").val() == "") {
                alert("请填写初次登记日期!");
                $("#registMonth").focus();
                return false;
            }

            //库存评估不校验使用性质
            if ($('input:radio[name="usedType"]:checked').val() == null) {
                alert("请选择使用性质");
                return false;
            }



            //库存评估不校验环保标准
            if ($('input:radio[name="environmentalLevel"]:checked').val() == null) {
                alert("请选择环保标准");
                return false;
            }



            if ($("#mileageCount").val() == "") {
                alert("请输入表显里程!");
                $("#mileageCount").focus();
                return false;
            }



            if ($('input:radio[name="issurValidTag"]:checked').val() == null) {
                alert("请选择交强险!");
                return false;
            }



            if ($('input:radio[name="commIssurValidTag"]:checked').val() == null) {
                alert("请选择商业险!");
                return false;
            }


            if ($('input:radio[name="carKeys"]:checked').val() == null) {
                alert("请选择车钥匙数!");
                return false;
            }

            if ($('input:radio[name="issurValidTag"]:checked').val() != null) {
                if ($('input:radio[name="issurValidTag"]:checked').val() == 1) {
                    if ($("#issurValidDate").val() == "") {
                        alert("请填写交强险到期日!");
                        $("#issurValidDate").focus();
                        return false;
                    }
                }
            }

            if ($('input:radio[name="commIssurValidTag"]:checked').val() != null) {
                if ($('input:radio[name="commIssurValidTag"]:checked').val() == 1) {
                    if ($("#commIssurValidDate").val() == "") {
                        alert("请填写商业险到期日!");
                        $("#commIssurValidDate").focus();
                        return false;
                    }
                }
            }
        }


        var reg = /^([0-9]|[.]){1,50}$/gim;
        if ($("#transferTag").val() != "") {
            if (!reg.test($.trim($("#transferTag").val()))) {
                alert("过户次数请输入数字!");
                $("#transferTag").focus();
                return false;
            }
        }
        return true;
    }

    return {

        save_draft: function(edit_type, staff_id) {

            if (_validate_form(edit_type)) {
                var result_json = $.toJSON(_get_result_json(edit_type, staff_id, "1")); //保存草稿提交类型为1
                console.log("the edit_type is :%s the result_json is %s",edit_type,result_json);
                $.ajax({
                    type: "POST",
                    url: "evaluate_doEdit.action",
                    data: "jsonString=" + result_json,
                    success: function(callback) {
                        if (callback == "success") {
                            alert("保存草稿成功！");
                            //history.back();
                            opener.location.reload();
                            //window.close();
                        } else if (callback == "error") {
                            alert("保存草稿失败！请联系管理员");
                        }
                    }
                });
            }
        },

        submit_eval: function(edit_type, staff_id) {
            if (_validate_form(edit_type)) {
                var result_json = $.toJSON(_get_result_json(edit_type, staff_id, "2")); //提交评估提交类型为2
                console.log("the edit_type is :%s the result_json is %s",edit_type,result_json);
                $.ajax({
                    type: "POST",
                    url: "evaluate_doEdit.action",
                    data: "jsonString=" + result_json,
                    success: function(callback) {
                        if (callback == "success") {
                            alert("提交评估成功！");
                            //history.back();
                            opener.location.reload();
                            //window.close();
                        } else if (callback == "error") {
                            alert("提交评估失败！请联系管理员");
                        }
                    }
                });
            }
        },

        modify_eval: function(edit_type, staff_id) {
            if (_validate_form(edit_type)) {
                var result_json = $.toJSON(_get_result_json(edit_type, staff_id, "3")); //修改评估提交类型为3
                $.ajax({
                    type: "POST",
                    url: "evaluate_doEdit.action",
                    data: "jsonString=" + result_json,
                    success: function(callback) {
                        if (callback == "success") {
                            alert("修改评估成功！");
                            //parent.closeAll();
                            console.log("parent is %o", parent);

                            parentDialog.close();
                        } else if (callback == "error") {
                            alert("修改评估失败！请联系管理员");
                        }
                    }
                });
            }
        }
    };
})();