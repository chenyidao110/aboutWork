----配置oracle.md文件使用
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

