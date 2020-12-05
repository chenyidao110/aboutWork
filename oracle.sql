----配置oracle.md文件使用
---一、存储过程
--1. 普通存储过程
set serverout on;
create or replace procedure insert_dept is
begin
	insert into dept values(77, '市场拓展部', 'BEIJING');
	commit;
	dbms_output.put_line('数据插入成功');
end;
/
--==============================================
---2.使用带IN的存储过程
set serverout on;
create or replace procedure insert_dept(
	number_deptno in number,
	var_dname in varchar2,
	var_loc in varchar2) is
begin
	insert into dept values(number_deptno,var_dname,var_loc);
	commit;
	dbms_output.put_line('数据插入成功');
end;
/
--==============================================
----3.创建带out参数的存储过程
set serverout on;
create or replace procedure select_dept(
	number_deptno in number,
	var_dname out dept.dname%type,
	var_loc out dept.loc%type) is
begin
	select dname,loc into var_dname, var_loc
	from dept where deptno=number_deptno;
exception
	when no_data_found then
	dbms_output.put_line('该部门编号不存在!');
end;
/
---PLSQL语句块中使用
declare
	var_dname dept.dname%type;
	var_loc dept.loc%type;
begin
	select_dept(66,var_dname,var_loc);
	dbms_output.put_line(var_dname || '位于:' || var_loc);
end;
/
--==============================================
---4.带INOUT参数的存储过程
create or replace procedure pro_square(
	num in out number,
	flag in boolean) is
	i int :=2;
begin
	if flag then
		num := power(num,i);
	else
		num := sqrt(num);
	end if;
end;
/

--PLSQL语句块使用存储过程
set serverout on;
declare
	var_number number;
	var_temp number;
	var_flag boolean;
begin
	var_temp :=4;
	var_number := var_temp;
	var_flag := true;
	pro_square(var_number,var_flag);
	if var_flag then
		dbms_output.put_line(var_temp || '的平方是：' || var_number);
	else
		dbms_output.put_line(var_temp || '的平方根是：' || var_number);
	end if;
end;
/
--==============================================
---5.带默认值的IN类型参数
create or replace procedure insert_dept(
	num_deptno in number,
	var_dname in varchar2 default '综合部',
	var_loc in varchar2 default '北京') is
begin
	insert into dept values(num_deptno,var_dname,var_loc);
	commit;
end;
/

--PLSQ语句块
declare
	row_dept dept%rowtype;
begin
	insert_dept(57,var_loc=>'太原');
	commit;
	select * into row_dept from dept where deptno=57;
	dbms_output.put_line('部门名称是：<<' || row_dept.dname || '>>，位置是：<<' || row_dept.loc || '>>');
end;
/
--==============================================

-----二、触发器
--==============================================
---1.语句级触发器
--创建日志表
create table dept_log
(
	operate_tags varchar2(10),
	operate_time date
);

--创建语句级触发器，记录对dept表所做的操作
create or replace trigger tri_dept
	before insert or update or delete
	on dept
declare
	var_tag varchar(10);
begin
	if inserting then
		var_tag := '插入';
	elsif updating then
		var_tag := '更新';
	elsif deleting then
		var_tag := '删除'
	end if;
	insert into dept_log
	values(var_tag,sysdate);
	commit;
end;
/

--sql语句
insert into dept values(66,'业务咨询部','长春');
update dept set loc='沈阳' where deptno=66;
delete from dept where deptno=66;
--==============================================
---2.行级触发器
---创建实验表
create table goods
(
	id number primary key,
	goods_name varchar2(50)
);

--创建一个序列
create sequence seq_id;
--创建触发器,用于为goods表的id列赋值
create or replace trigger tri_insert_goods
	before insert
	on goods
	for each row
begin
	select seq_id.nextval
	into :new.id
	from dual;
end;
/
--==============================================
---3.instead of 触发器
---创建视图
create view view_emp_dept
	as select empno,ename,dept.deptno,dname,job,hiredate
	from dept,emp
	where dept.deptno = emp.deptno;

--编写instead of触发器
create or replace trigger tri_insert_view
	instead of insert
	on view_emp_dept
	for each row
declare
	row_dept dept%rowtype;
begin
	select * into row_dept from dept where deptno = :new.deptno;
	if sql%notfound then	---未检索到该部门编号的记录
		insert into dept(deptno,dname)	----向dept表中插入数据
		values(:new.deptno,:new.dname);
	end if;
	insert into emp(empno,ename,deptno,job,hiredate)		----向emp表中插入数据
	values(:new.empno,:new.ename,:new.deptno,:new.job,:new.hiredate);
end;
/
---插入数据
insert into view_emp_dept(empno,ename,deptno,dname,job,hiredate) values(8888,'东方',10,'ACCOUNTING','CASHIER',sysdate);
--==============================================
