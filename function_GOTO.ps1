	
Param([String[]] $dir, [Alias('p')][Switch] $push )
[xml]$x = Get-Content 'B:\SCRIPTS\Config\Directories.xml';
	
	if($dir -eq $x.Windows.DriveB.Home.DOWNLOADS.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.DOWNLOADS.this}
		else{cd $x.Windows.DriveB.Home.DOWNLOADS.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.COLLEGE.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.COLLEGE.this}
		else{cd $x.Windows.DriveB.Home.COLLEGE.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.RECYCLE.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.RECYCLE.this}
		else{cd $x.Windows.DriveB.Home.RECYCLE.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.CompE361.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.CompE361.this}
		else {cd $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.CompE361.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.CompE475.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.CompE475.this}
		else{cd $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.CompE475.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.CompE496A.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.CompE496A.this}
		else{cd $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.CompE496A.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.EE420.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.EE420.this}
		else{cd $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.EE420.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.EE450.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.EE450.this}
		else{cd $x.Windows.DriveB.Home.COLLEGE._19_20.Fall19.EE450.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.COLLEGE._19_20.Spring20.CompE565.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.COLLEGE._19_20.Spring20.CompE565.this}
		else{cd $x.Windows.DriveB.Home.COLLEGE._19_20.Spring20.CompE565.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.COLLEGE._19_20.Spring20.CompE560.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.COLLEGE._19_20.Spring20.CompE560.this}
		else{cd $x.Windows.DriveB.Home.COLLEGE._19_20.Spring20.CompE560.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.COLLEGE._19_20.Spring20.CompE496B.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.COLLEGE._19_20.Spring20.CompE496B.this}
		else{cd $x.Windows.DriveB.Home.COLLEGE._19_20.Spring20.CompE496B.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.COLLEGE._19_20.Spring20.EE600.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.COLLEGE._19_20.Spring20.EE600.this}
		else{cd $x.Windows.DriveB.Home.COLLEGE._19_20.Spring20.EE600.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.this}
		else{cd $x.Windows.DriveB.Home.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.SCRIPTS.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.SCRIPTS.this}
		else{cd $x.Windows.DriveB.Home.SCRIPTS.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.JOB.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.JOB.this}
		else{cd $x.Windows.DriveB.Home.JOB.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.ONE.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.ONE}
		else{cd $x.Windows.DriveB.Home.ONE}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.PICTURES.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.PICTURES.this}
		else{cd $x.Windows.DriveB.Home.PICTURES.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.SITES.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.SITES.this}
		else{cd $x.Windows.DriveB.Home.SITES.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.CODE.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.CODE.this}
		else{cd $x.Windows.DriveB.Home.CODE.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.MUSIC.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.MUSIC.this}
		else{cd $x.Windows.DriveB.Home.MUSIC.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.SOURCES.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.SOURCES.this}
		else{cd $x.Windows.DriveB.Home.SOURCES.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.SOURCES.Repo.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.SOURCES.Repo.this}
		else{cd $x.Windows.DriveB.Home.SOURCES.Repo.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.PERSONAL.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.PERSONAL.this}
		else{cd $x.Windows.DriveB.Home.PERSONAL.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.SITES.BrandonFongMusic.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.SITES.BrandonFongMusic.this}
		else{cd $x.Windows.DriveB.Home.SITES.BrandonFongMusic.this}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.SOURCES.Repo.YES.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.SOURCES.Repo.YES}
		else{cd $x.Windows.DriveB.Home.SOURCES.Repo.YES}
	}
	elseif($dir -eq $x.Windows.DriveB.Home.CMAIN.alias)
	{
		if($push){pushd $x.Windows.DriveB.Home.CMAIN}
		else{cd $x.Windows.DriveB.Home.CMAIN}
	}
	else{ throw "Didn't 'goto' anywhere.  Reenter function with correct parameters." }
