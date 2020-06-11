if not exists (select * from master.dbo.sysdatabases where name = '@DBName')
begin
	create database @DBName;
end