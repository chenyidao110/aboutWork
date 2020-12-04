----����oracle.md�ļ�ʹ��
--1. ��ͨ�洢����
set serverout on;
create or replace procedure insert_dept is
begin
	insert into dept values(77, '�г���չ��', 'BEIJING');
	commit;
	dbms_output.put_line('���ݲ���ɹ�');
end;
/
--==============================================
---2.ʹ�ô�IN�Ĵ洢����
set serverout on;
create or replace procedure insert_dept(
	number_deptno in number,
	var_dname in varchar2,
	var_loc in varchar2) is
begin
	insert into dept values(number_deptno,var_dname,var_loc);
	commit;
	dbms_output.put_line('���ݲ���ɹ�');
end;
/
--==============================================
----3.������out�����Ĵ洢����
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
	dbms_output.put_line('�ò��ű�Ų�����!');
end;
/
---PLSQL������ʹ��
declare
	var_dname dept.dname%type;
	var_loc dept.loc%type;
begin
	select_dept(66,var_dname,var_loc);
	dbms_output.put_line(var_dname || 'λ��:' || var_loc);
end;
/
--==============================================
---4.��INOUT�����Ĵ洢����
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

--PLSQL����ʹ�ô洢����
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
		dbms_output.put_line(var_temp || '��ƽ���ǣ�' || var_number);
	else
		dbms_output.put_line(var_temp || '��ƽ�����ǣ�' || var_number);
	end if;
end;
/
--==============================================
---5.��Ĭ��ֵ��IN���Ͳ���
create or replace procedure insert_dept(
	num_deptno in number,
	var_dname in varchar2 default '�ۺϲ�',
	var_loc in varchar2 default '����') is
begin
	insert into dept values(num_deptno,var_dname,var_loc);
	commit;
end;
/

--PLSQ����
declare
	row_dept dept%rowtype;
begin
	insert_dept(57,var_loc=>'̫ԭ');
	commit;
	select * into row_dept from dept where deptno=57;
	dbms_output.put_line('���������ǣ�<<' || row_dept.dname || '>>��λ���ǣ�<<' || row_dept.loc || '>>');
end;
/
--==============================================

