# 1. 存储过程

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

# 2. 触发器

