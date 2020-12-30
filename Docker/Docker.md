# 一、Docker介绍

## 1. 下载Docker依赖的环境

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

## 1. 拉取镜像

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

## 4. 镜像的导入、导出

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

## 1. 运行容器

​			运行容器需要定制具体镜像，如果镜像不存在，会直接下载

~~~shell
	#简单操作
	docker run 镜像的标识|镜像的名称[:tag]
	#常用的参数
	docker run -d -p 宿主机端口:容器端口 --name 容器名称 镜像的标识|的名称[:tag]
	# -e TZ=Asia/Shanghai
	
~~~

## 2. 查看正在运行的容器

​			查看全部正在运行的容器信息

~~~shell
	#查看全部运行容器
	docker ps [-a]
	#-a 全部容器
	#-q 只查看容器标识
~~~

## 3. 查看容器日志

​			查看容器日志，以查看容器运行的信息

~~~shell
	docker log -f 容器id
	#-f 查看日志的末尾几行
~~~

## 4. 进入容器的内部

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

## 1. 安装Tomcat

​			运行Tomcat容器

~~~shell
	#运行网络上tomcat镜像
	docker run -d -p 8081:8080 --name tomcat daocloud.io/library/tomcat:8.5.15-jre8
	#也可以运行本地已经制作的镜像
~~~

## 2. 运行Mysql容器

~~~shell
	#运行网络源中镜像
    docker run -d -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=root daocloud.io/library/mysql:5.7.5
    #-e MYSQL_ROOT_PASSWORD=root 指定mysql root密码 
~~~

# 六、数据卷

​		数据卷：将宿主机的一个目录映射到容器的一个目录中,可以在宿主机中操作目录中的内容，那么容器内部映射的文件，也会跟着一起改变。

## 1. 创建数据卷

~~~shell
	#创建数据卷后，默认会存放在/var/lib/docker/volumes/数据卷名称/_data
	docker volume create 数据卷名称
~~~

## 2. 查看全部数据卷

~~~shell
	#查看全部数据卷
	docker volume ls
~~~

## 3. 查看数据卷详情

~~~shell
	#查看数据卷详情，可以查询到存放路径，创建时间等
	docker volume inspect 数据卷名称
~~~

## 4. 删除数据卷

~~~shell
	#删除指定数据卷
	docker volume rm 数据卷名称
~~~

## 5. 容器映射数据卷

~~~shell
	#通过数据卷名称映射，如果数据卷不存在，Docker会帮你自动创建，会将容器内自带的文件存储在默认路径中
	docker run -d -p 8081:8080 --name tomcat 数据卷名称:容器内部路径 镜像id
	#例如：docker run -d -p 8081:8080 --name tomcat -v tomcat:/usr/local/tomcat/logs b8
	
	#通过路径映射数据卷，直接指定一个路径做为数据卷的存放位置，但是这个路径下是空的
	docker run -d -p 8081:8080 --name tomcat -v /root创建的路径:容器内部路径 镜像id
	#例如：docker run -d -p 8081:8080 --name tomcat -v /opt/docker/volumes/tomcat/logs:/usr/local/tomcat/logs  -e TZ=Asia/Shanghai b8
~~~

# 七、Dockerfile自定义镜像

## 1. Dockerfile

​	创建自定义镜像就需要创建一个Dockerfiler,如下为Dockerfile的语言

~~~shell
	#from: 指定当前自定义镜像依赖的环境
	#copy: 将相对路径下的文件复制到自定义镜像中
	#workdir: 声明镜像的默认工作目录
	#run: 执行的命令，可以写多个
	#cmd: 需要执行的命令(在workdir下执行，cmd可以写多个，只以最后一个为准)
	
	#示例
	from daocloud.io/library/tomcat:8.5.15-jre8
	copy index.html /usr/local/tomcat/webapps
~~~

## 2. 通过Dockerfile制作镜像

~~~shell
	#编写Dockerfile后通过命令将其制作为镜像，并且要在Dockerfile当前目录下，之后即可在镜像中查看到指定的镜像信息，注意最后的.
	docker build -t 镜像名称[:tag] ./
~~~

# 八、Docker-Compose

## 1. 下载安装Docker-compose

### 1.1 下载docker-compose

~~~shell
	#在github上搜索docker-compose并下载，此处下载的是最新版本
	wget https://github.com/docker/compose/releases/download/1.27.4/docker-compose-Linux-x86_64
~~~

### 1.2 修改名称，设置权限

~~~shell
	#修改名称
	mv docker-compose-Linux-x86_64 docker-compose
	#设置权限
	chmod 755 docker-compose
~~~

### 1.3 添加环境变量

~~~shell
	#方便直接使用docker-compose命令，要将docker-compose添加到环境变量中
	#将docker-compose放到/usr/local/bin下，修改/etc/profile文件，将/usr/local/bin添加到PATH中
	mv docker-compose /usr/local/bin/
	vim /etc/profile
	export PATH=/usr/local/bin:$PATH
	#修改后
	source /etc/profile
~~~

### 1.4 测试

~~~shell
	#在任意目录下执行docker-compose命令，显示相关信息
	docker-compose
~~~

## 2. 管理Mysql和Tomcat容器

~~~yml
	#yml文件以key:value方式来指定配置信息
	#多个配置信息以换行+缩进的方式来区分
	#在docker-compose.yml文件中，不要使用制表符
version: '3.1'
services:
  mysql:           # 服务的名称
    restart: always   # 代表只要docker启动，那么这个容器就跟着一起启动
    image: daocloud.io/library/mysql:5.7.4  # 指定镜像路径
    container_name: mysql  # 指定容器名称
    ports:
      - 3306:3306   #  指定端口号的映射
    environment:
      MYSQL_ROOT_PASSWORD: root   # 指定MySQL的ROOT用户登录密码
      TZ: Asia/Shanghai        # 指定时区
    volumes:
     - /opt/docker_mysql_tomcat/mysql_data:/var/lib/mysql   # 映射数据卷
  tomcat:
    restart: always
    image: daocloud.io/library/tomcat:8.5.15-jre8
    container_name: tomcat
    ports:
      - 8081:8080
    environment:
      TZ: Asia/Shanghai
    volumes:
      - /opt/docker/tomcat/webapps:/usr/local/tomcat/webapps
      - /opt/docker/tomcat/logs:/usr/local/tomcat/logs
~~~

## 3. 使用Docker-Compose管理容器

​		在使用docker-compose命令时,默认会在当前路径下寻找docker-compose.yml文件

~~~shell
	#1.基于docker-compose启动管理的容器
	docker-compose up -d
	#2.关闭并删除容器
	docker-compose down
	#3.开启|关闭|重启已经存在的由docker-compose维护的容器
	docker-compse start|stop|restart
	#4.查看由docker-compose管理的容器
	docker-compose ps
	#5.查看日志
	docker-compose logs -f
~~~

## 4. Docker-Compose配合Dockerfile使用

​		**使用docker-compose.yml文件以及Dockerfile文件在生成自定义镜像的同时启动当前镜像，并且由docker-compose去管理容器**

### 4.1 docker-compose文件

~~~yml
	# 编写docker-compose文件
    # yml文件
    version: '3.1'
    services:
      ssm:
        restart: always
        build:            # 构建自定义镜像
          context: ../      # 指定dockerfile文件的所在路径
          dockerfile: Dockerfile   # 指定Dockerfile文件名称
        image: ssm:1.0.1
        container_name: ssm
        ports:
          - 8081:8080
        environment:
          TZ: Asia/Shanghai
~~~

### 4.2 Dockerfile

~~~shell
	#编写Dockerfile文件
    from daocloud.io/library/tomcat:8.5.15-jre8
    copy ssm.war /usr/local/tomcat/webapps
~~~



​	

