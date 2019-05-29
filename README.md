# codetool
一个java代码生成工具，支持hibernate,mybatis,jdbc三种数据持久层框架，标准的mvc模式代码

该工具按照MVC标准代码结构生成对应的Mapper.xml, Dao接口，Service接口和实现，Controller以及对应的CRUD页面，页面以jsp呈现。
目前支持的前端框架有dorado，基于bootstrap的adminLTE，beyondAdmin，可自行选择要生成什么模板页面。

WEB端与服务器端的交互方式支持MVC和restful风格，建议采用restful，方便后期改为纯前后端分离结构。

----------------------------------------------------------------------------------------
使用说明：

使用特别简单，只需要修改几个配置：
1、代码生成的目录，建议生成的代码文件不要直接保存到项目所在目录，防止覆盖或出错；
2、数据库连接的配置，如数据库IP、用户和密码；
3、若要按模块生成，则添加几个对应的Model标签，在各标签内配置要生成的数据表名即可

具体配置请参考：resource/config.xml

-------------------------------------------------------------------------------
[code]
	<?xml version="1.0" encoding="UTF-8"?>
	<!-- 配置示例说明 -->
	<configure>
		<basedir>F:/code</basedir>
		<basePackage>com.mars</basePackage>
		<!-- 使用的模板框架，可以选择adminLTE,beyoneAdmin，默认为beyondAdmin -->
		<theme>adminLTE</theme>
		<!-- 数据库连接配置 -->
		<db>
			<dbName>database name</dbName>
			<user>user</user>
			<pwd>password</pwd>
			<driver>com.mysql.jdbc.Driver</driver>
			<url>jdbc:mysql://localhost:3306/database_name?useUnicode=true&amp;characterEncoding=utf-8</url>
		</db>

		<!-- 需要忽略生成到entity的字段 -->
		<!-- 对于一般稍大型的系统，有很多数据表有相同的字段，如创建人、创建时间、修改人、修改时间、数据状态等，
		这些可能使用统一的父类字段属性，那么这些字段可以在生成配置文件的时候进行忽略而不显示
		 -->
		<ignoreColumns>
			create_user,create_time,update_user,update_time,state,note,com_id
		</ignoreColumns>

		<!-- 包名配置 -->
		<packageSetting>
			<actionPackage>action</actionPackage>
			<daoPackage>dao</daoPackage>
			<daoImplPackage>impl</daoImplPackage>
			<servicePackage>service</servicePackage>
			<serviceImplPackage>impl</serviceImplPackage>
			<entityPackage>entity</entityPackage>
			<mapperPackage>mapper</mapperPackage>
			<viewPackage>view</viewPackage>
			<!-- 是否删除表前缀，全局配置 -->
			<isDeleteTablePrefix>true</isDeleteTablePrefix>
		</packageSetting>
		<module>
			<!-- 数据持久层框架，可选：mybatis,hibernate,jdbc,jpa -->
			<persistance>mybatis</persistance>
			<!-- 模块名称，该模块会根据自动生成一个包，相关的dao, service,entity,action等都会生成在该包里面 -->
			<name>wap</name>
			<!-- 是否删除表前缀，如果为true，则在table里面设置的表前缀名称就会被自动删除 -->
			<isDeleteTablePrefix>true</isDeleteTablePrefix>
			<!-- 文件保存路径，默认为全局配置的目录，这里可以单独指定保存目录 -->
			<savePath></savePath>
			<!-- 采用的数据交互架构，可选：mvc, rest, dorado -->
			<framework>mvc</framework>
			<!-- 以下为要生成代码的数据库表，支持嵌套 -->
			<!-- table标签属性说明
			name: 			表名
			prefix : 		表前缀 
			entityName 		生成的实体类名 
			parentField: 	如果是主从表，则从表需设置该属性，表示父表的关联属性
			refType: 		表关联类型，在子表中配置，分为OneToOne,OneToMany等，用于持久层为hibernate或jpa的entity，如果与父表的关系是多对一，则会在父表对应的 entity中生成该子表的List集合属性
			 -->
			<table name="cms_category" entityName="Category" prefix="cms_">
				<table name="cms_article" entityName="Article" prefix="cms_" parentField="cat_id" refType="OneToMany"/>
			</table>
			<table name="cms_comment"/>
		</module>
	</configure>
[/code]
