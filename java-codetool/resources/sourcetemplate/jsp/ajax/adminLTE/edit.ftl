﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../common/jstl.jsp"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- Head -->
<head>
	<meta charset="utf-8" />
	<title>修改${caption!}</title>
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@include file="../../common/admin_css.jsp"%>
	<style>
	section.content{margin-top:0px;}
	.form-title{background:#dfd;padding-left:5px;}
	</style>
</head>
<!-- /Head -->
<!-- Body -->
<body>
	<!-- Main Container -->
	<div class="wraper">
		<div class="">
			<!-- Main content -->
			<section class="content">
				<div class="box">
					<div class="box-body">
                        <form id="formData" class="form-horizontal" onsubmit="return checkForm()">
							<#list primaryKeyList as col>
							<input type="hidden" name="${col.propertyName}" value=""/>
							</#list>
                            <div class="form-title"></div>
                            <#if columns??>
							<#list columns as col>
								<#if !col.primaryKey>
                                <div class="form-group">
                                    <label class="col-lg-2 col-md-2 col-sm-4 control-label">${col.caption!}${(col.nullable)?string('','(*)')}</label>
                                    <div class="col-lg-9 col-md-9 col-sm-7">
                                    	<#if col.length gt 100>
                                    	<textarea class="form-control" name="${col.propertyName}" ${(col.nullable)?string('','require')}></textarea>
                                    	<#else>
                                        <input type="text" class="form-control ${(col.propertyType?index_of('Date')!=-1)?string('datepicker','')}" name="${col.propertyName}" value="" placeholder="请输入${col.caption!}" ${(col.nullable)?string('','require')} />
                                    	</#if>
                                    </div>
                                </div>
                                </#if>
                            </#list>
                            </#if>
                         </form>
                     </div>
				<!-- /box -->
				</div>
			</section>
		</div>
	</div>
	
	<%@include file="../../common/admin_js.jsp"%>
	<script>
        function saveData(dlg){
			var checkResult=checkForm("#formData");
	    	var msg=checkResult.msg;
	   		msg = msg.distinct();
	   		if (!checkResult.state){
	   			if (msg.length==0){
	   				msg.push("请输入必填的内容！");
	   			}
	   			top.bootbox.alert(msg.join("<br/>"));
		   		return false;
	   		}
	   		var $submiting = top.showSubmitLoading();
	    	var data = $("#formData").serialize();
	    	$.ajax({
	    		url:"${"$"}{contextPath}/${moduleName}/${entityName}/ajax/update${entityCamelName}",
	    		type:"post",
	    		data:data,
	    		success:function(res){
	    			$submiting.modal("hide");
	    			if (res.state==0){
	    				top.bootbox.alert('保存成功！',function() {
							if (dlg){
								dlg.win.reloadData();
								dlg.closeDlg();
							}
	    				});  
	    			} else {
	    				top.bootbox.alert(res.message);
	    			}
	    		},
	    		error:function(){
        			top.bootbox.alert("保存出错："+arguments[0].statusText);
        		}
	    	});
		}
        
        //加载主体数据
		function reloadData(){
			$.ajax({
	   			url:"${"$"}{contextPath}/${moduleName}/${entityName}/ajax/load${entityCamelName}",
	   			data:{<#list primaryKeyList as col><#if col_index!=0>,</#if>${col.propertyName}:"${"$"}{fn:escapeXml(param.${col.propertyName})}"</#list>},
	   			success:function(res){
	    			if (res.state==0){
	    				fillFormData(res.data);
	    			} else {
	    				alert(res.message);
	    			}
	    			loadDicts(res.data,function(){
	    				hideLoading();
	    			});
	    		},
	    		error:function(error){
	    			alert(error);
	    		}
	   		});
		}
        
        $(document).ready(function(){
       		$('.datepicker').datepicker({
       			format: 'yyyy-mm-dd',
       			weekStart: 1
       		});
       		
       		reloadData();
       	});
    </script>
</body>
<!--  /Body -->
</html>
