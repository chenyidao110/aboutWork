# 一、Docker介绍

	## 	1. 下载Docker依赖的环境

~~~shell
	#想安装Docker，需要先将依赖的环境全部下载下来，就像Maven依赖JDK一样：
	yum -y install yum-utils device-mapper-persistent-data lvm2
~~~

## 	2. 指定Docker镜像源

~~~shell
	#默认下载Docker会去国外服务器下载，速度很慢；可以设置为国内镜像，如阿里云
	yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
~~~

## 	3. 安装Docker

~~~shell
	yum makecache fast
	yum -y install docker-ce
~~~

------------------------------------------

## 4. 启动Docker并测试

 1. 安装成功后，需要手动启动，设置为开机启动，并测试一下 Docker

    ```shell
    #启动docker服务
    systemctl start docker
    #设置开机启动
    systemctl enable docker
    #测试
    docker run hello-world
    ```

# 二、Docker的中央仓库

​		1. Docker的官方中央仓库，镜像是最全的，但是下载速度较慢

```
		https://hub.docker.com/
```

​		2. 国内的镜像网站：网易蜂巢，daoCloud等，下载速度快，但是镜像相对不全。

​					https://c.163yun.com/hub#/home http://hub.daocloud.io/ （推荐使用）

  		3.    

~~~shell
在公司内部会采用私服的方式拉取镜像（添加配置）
#需要创建 /etc/docker/daemon.json，并添加如下内容
{	
	"registry-mirrors":["https://registry.docker-cn.com"],	
	"insecure-registries":["ip:port"]
}
#重启两个服务
systemctl daemon-reload
systemctl restart docker
~~~



--------------------------

# 三、镜像的制作

	## 	1. 拉取镜像

​			从中央仓库拉取镜像到本地

~~~shell
	docker pull 镜像名称[:tag]
	#举个例子：docker pull daocloud.io/library/tomcat:8.5.15-jre8
~~~

## 	2. 查看本地全部镜像

​			查看本地已经安装的镜像信息，包含标识、名称、版本、更新时间，大小：

~~~shell
	docker images
~~~

-------

## 	3. 删除本地镜像

​			镜像会占用磁盘空间，可以直接手工删除，镜像标识通过查看获取

~~~shell
	docker rmi 镜像标识
~~~

-----------------------------

		## 	4.镜像的导入、导出

​			如果因为网络原因可以通过硬盘的方式传输镜像，虽然不规范，但是有效，但是这种方式导出的镜像名称和版本都是null，需要手动修改

~~~shell
	#将本地镜像导出
	docker save -o 镜像路径 镜像id
	#加载镜像
	docker load -i 镜像路径
	#修改镜像
	docker tag 镜像id 镜像名称:tags(版本)
~~~

----------

# 四、容器的操作

		## 	1. 运行容器

​			运行容器需要定制具体镜像，如果镜像不存在，会直接下载

~~~shell
	#简单操作
	docker run 镜像的标识|镜像的名称[:tag]
	#常用的参数
	docker run -d -p 宿主机端口:容器端口 --name 容器名称 镜像的标识|的名称[:tag]
	
~~~

				## 	2. 查看正在运行的容器

​			查看全部正在运行的容器信息

~~~shell
	#查看全部运行容器
	docker ps [-a]
	#-a 全部容器
	#-q 只查看容器标识
~~~

			## 	3. 查看容器日志

​			查看容器日志，以查看容器运行的信息

~~~shell
	docker log -f 容器id
	#-f 查看日志的末尾几行
~~~

			## 	4. 进入容器的内部

​			可以进入容器的内部进行操作

~~~shell
	docker exec -it 容器id bash
~~~

## 	5. 复制文件到容器内部

​			复制宿主机文件/目录到容器指定路径

~~~shell
	docker cp 文件名称[目录] 容器id:容器内部路径
~~~

## 	6. 容器的启动&停止&重启&删除

​			容器的启动、停止、重启、删除，后续常用命令

~~~shell
	#启动未运行容器
	docker start 容器id
	#重启容器
	docker restart 窗口id
	#停止指定容器
	docker stop 容器id
	#停止所有容器
	docker stop $(docker ps -qa)
	#删除指定容器(删除前请先停止)
	docker rm 容器id
	#删除所有容器(删除前请先停止)
	docker rm $(docker ps -qa)
~~~

----------------------------------

# 五、Docker的应用

			## 	1. 安装Tomcat

​			运行Tomcat容器

~~~shell
	#运行网络上tomcat镜像
	docker run -d -p 8081:8080 --name tomcat daocloud.io/library/tomcat:8.5.15-jre8
	#也可以运行本地已经制作的镜像
~~~

		## 	2. 运行Mysql容器

~~~shell
	#运行网络源中镜像
    docker run -d -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=root daocloud.io/library/mysql:5.7.5
    #-e MYSQL_ROOT_PASSWORD=root 指定mysql root密码 
~~~

# 六、数据卷

​		