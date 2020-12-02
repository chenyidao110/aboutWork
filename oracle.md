# 一. 存储过程

## 1. 模板

~~~sql
create [or replace] procedure pro_name[parame1 [in|out] para_type] is|as
begin
	--存储过程功能主题
[exception]
	---异常处理语句,可选
end [pro_name];
/
~~~

## 2. 实例

### 2.1 创建无参存储过程

​	创建一个存储过程,该存储过程向dept表中插入一条记录,代码如下:

~~~sql
create procedure pro_insertDept is
begin
	insert into dept values(77,'市场拓展部','JILING');
	commit;
	dbms_output.put_line('插入记录成功!');
end;
/
~~~

### 2.2 创建存储过程(replace)

​	创建存储过程时使用 or replace关键字,如果数据库中有同名存储过程,会覆盖

~~~sql
create or replace procedure pro_insertDept is
begin
	insert into dept values(99,'市场拓展部','BEIJING');
	commit;
	dbms_output.put_line('插入记录成功!');
end;
/
~~~

### 2.3 创建存储过程(IN)

​	这是一种输入类型的参数,参数值由调用方传入,并且只能被存储过程读取;关键字IN位于参数名称之后.

~~~sql
create or replace procedure insert_dept(
	num_deptno in number,
	var_ename in varchar2,
	var_loc in varchar2) is
begin
	insert into dept 
	values(num_deptno,var_ename,var_loc);
	commit;
end;
/
~~~

### 2.4 创建存储过程(OUT)

​	这是一种输出类型的参数,表示这个参数在存储过程中已经被赋值,并且这个参数可以传递到当前存储过程以外的环境中;

​	**如果参数种有OUT类型的,调用存储过程时必须传入参数,否则报错**

~~~sql
create or replace procedure select_dept(
	num_deptno in number,
	var_dname out dept.name%type,
	var_loc out dept.loc%type) is
begin
	select dname,loc
	into var_dname,var_loc
	from dept
	where deptno = num_deptno;
exception
	where no_data_found then
	dbms_output.put_line('该部门编号的不存在!');
end;
/

---PL/SQL语句块使用如下
set serverout on;
declare
	var_dname dept.dname%type;
	var_loc dept.loc%type;
begin
	select_dept(99,var_dname,var_loc);
	dbms_output.put_line(var_dname || '位于: ') || var_loc);
endl;
/

--exec使用如下
variable var_dname varchar2(50);
variable var_loc varchar2(50);
exec select_dept(15,:var_dname,:var_loc);
	---exec语句执行后看不到变量值,有两种方法
	---1.print变量
	print var_dname var_loc;
	---2.select语句检索绑定的变量值
	select :var_dname,:var_loc from dual;
~~~

### 2.5 创建存储过程(INOUT)

​	在执行存储过程时,IN参数不能被修改,它只能根据被传入的指定值(或是默认值)为存储过程提供数据;而OUT类型的参数只能等待被赋值,而不能像IN参数那样为存储过程本身提供数据.但IN OUT参数可以兼顾其他两种参数的特点,在调用存储过程时,可以从外界向该类型的参数传入值;在执行完存储过程之后,可以将该参数的返回值传递给外界.

~~~sql
create or replace procedure pro_square(
	num in out number,
	flag in boolean) is
begin
	if flag then
		num := power(num);
	else
		num := sqrt(num);
	end if;
end;
/

---pl/sql语句块执行
set serverout on
declare
	var_number number;
	var_temp number;
	boo_flag boolean;
begin
	var_temp :=3;
	var_number := var_temp;
	boo_flag := false;
	pro_squre(var_number,boo_flag);
	if boo_flag then
		dbms_output.put_line(var_temp || '的平方是: ' || var_number);
	else
		dbms_outout.put_line(var_temp || '的平方根是: ' || var_number);
	end if;
end;
/
~~~

### 2.6 创建存储过程(IN参数默认值)

~~~sql
create or replace procedure insert_dept(
	num_deptno in number,
	var_dname in varchar2 default '综合部',
	var_loc in varchar2 default '北京') is
begin
	insert int dept values(num_deptno,var_dname,var_loc);
end;
/

---PL/SQL执行，要采用"指定名称"方式传递参数值
set serverout on;
declare
	row_dept dept%type	---定义行变量，和dept表的一行数据类型相同
begin
	insert(57,var_loc=>'太原');
	commit;
	select * into row_dept from dept where deptno=57;
	dbms_output.put_line('部门名称是：<<'||row_dept.dname||'>> ,位置是：<<'||row_dept.loc||'>>');
endl;
/
~~~

## 3. 删除

~~~sql
drop procedure pro_name;
~~~

# 二. 触发器

​	触发器可以看作是一种"特殊"的存储过程，它定义了一些在**数据库相关事件**(如INSERT/UPDATE/CREATE等事件)发生时应执行的"功能代码块"，通常用于管理复杂的完整性约束，或监控对表的修改，或通知其他程序，甚至可以实现对数据的审计功能。

​	**触发事件**：能够引起触发器运行的操作就被称为"触发事件"，如执行DML语句(使用INSERT、UPDATE、DELETE语句对表或视图执行数据处理操作)，执行DDL语句(使用CREATE、ALTER、DROP语句在数据库中创建、修改、删除模式对象)，引发数据库系统事件(如系统启动或退出、产生异常错误等)，引发用户事件(如登录或退出数据库操作)，以上这些操作都可以引起触发器的运行

## 1. 模板

~~~sql
CREATE [OR REPLACE] TRIGGER TRI_NAME
	[BEFOR][AFTER|INSTEAD OF] tri_event
	ON table_name|view_name|user_name|db_name
	[FOR EACH ROW][WHEN tri_condition]
BEGIN
	plsql_sentences
END tri_name;

---条件谓词格式
IF inserting THEN
	do something about insert
ELSIF upding THEN
	do something about update
ELSIF deleting THEN
	do something about delete
END IF;
~~~

## 2. 触发器分类

- 行级触发器：当DML语句对每一行数据进行操作时都会引起该触发器的运行
- 语句级触发器：无论DML语句影响多少行数据，其所引起的触发器只执行一行。
- 替换触发器：该触发器是定义在视图上的，而不是定义在表上，它是用来替换所使用实际语句的触发器
- 用户事件触发器：是指与DDL操作或用户登录、退出数据库等事件相关的触发器。如用户登录到数据库或使用ALTER语句修改表结构等事件的触发器。
- 系统事件触发器：是指在Oracle数据库系统的事件中进行触发的触发器，如Orale实例的启动与关闭。

## 3. 实例

### 3.1 语句级触发器

​	语句级触发器，就是针对一条DML语句而引起的触发器执行。特点如下

- 不用FOR EACH ROW
- 无论影响多少行数据，触发器只执行一次

~~~sql
--创建dept_log数据表，
create table dept_log
(
	operate_tag varchar2(10),
    operate_time date
);
---创建一个针对dept表的语句级触发器，将用户对dept表的操作信息保存到dept_log表中
---创建触发器tri_dept
create or replace trigger tri_dept
	before insert or update or delete
	on dept
declare
	var_tag varchar2(10);
begin
	if inserting then
		var_tag := '插入';
	elsif updating then
		var_tag := '修改';
	elsif deleting then
		var_tag := '删除';
	end if;
	insert into dept_log
	values(var_tag,sysdate);
end tri_dept;
/
~~~

### 3.2 行级触发器

​	行级触发器特点，针对数据行操作，特点：

- 针对DML操作所影响的每一行数据执行一次触发器
- 创建时，必须作用FOR EACH ROW

~~~sql
---行级触发器的典型应用就是给数据表生成主键，以此为例
---创建一个用于存储商品种类的数据表，包含商品序号列和名称列
create table goods
(
	id int primary key,
    good_name varchar2(50)
);
---创建一个序列
create sequence seq_id;
---创建触发器，用于为goods表的id列赋值
create or replace trigger tri_insert_good
	before insert
	on goods
	for each row
begin
	select seq_id.nextvar
	into :new.id
	from dual;
end;
/
~~~

### 3.3 替换触发器

​	替换触发器，它的"触发时机"关键字是INSTEAD OF，不是BEFORE或者AFTER，特点如下：

- 替换触发器是建立在视图上的，而不是表上
- 用户为视图编写替换触发器后，针对视图的DML操作实际上变成了执行触发器中的PL/SQL语句块，对构成视图的基表进行操作

~~~sql
---创建视图
create view view_emp_dept
	as select empno,ename,dept.deptno,dname,job,hiredate
	from emp,dept
	where emp.deptno = dept.deptno;
	
---编写针对视图的替换触发器
create or replace trigger tri_insert_view
	instead of insert
	on view_emp_dept
	for each row
declare
	row_dept dept%type
begin
	select * into row_dept from dept where deptno = :new.deptno;
	if sql%notfound then	---未检索到该部门编号的记录
		insert into dept(deptno,dname)	----向dept表中插入数据
		values(:new.deptno,:new.dname);
	end if;
	insert into emp(empno,ename,deptno,job,hiredate)		----向emp表中插入数据
	values(:new.empno,:new.ename,:new.deptno,:new.job,:new.hiredate);
end tri_insert_view;
/
~~~

### 3.4 用户事件触发器

​	用户事件触发器是因为DDL操作或者用户登录、退出等操作而引起运行的一种触发器，常见的用户事件：

- CREATE ALTER DROP ANALYZE COMMIT GRANT REVOKE RENAME TRUNCATE SUSPEND 
- LOGON LOGOFF

~~~sql
---创建日志信息表
create table ddl_oper_log
(
	db_obj_name varchar2(20),	---数据对象名称
    db_obj_type varchar2(20),	---对象类型
    oper_action varchar2(20),	---上体ddl行为
    oper_user varchar2(20),		---操作用户
    oper_date date				---操作日期
);
---创建用户事件触发器
create or replace trigger tri_ddl_oper
	before create or or alter or drop
	on username.schema
begin
	insert into ddl_oper_log values(
    	ora_dict_obj_name,
        ora_dict_obj_type,
        ora_sysevent,
        ora_login_user,
        sysdate);
end;
/
/*
	ora_dict_obj_name：获取DDL操作所对应的数据库对象
	ora_dict_obj_type：获取DDL操作所对应的数据库对象的类型
	ora_sysevent：获取触发器的系统事件名
	ora_login_user：获取登录用户名
*/
~~~

## 4.删除

~~~sql
drop trigger tri_name;
~~~

# 三. 函数

