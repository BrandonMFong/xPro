		
function GO-TO
{
	Param([String[]] $dir, [Alias('p')][Switch] $push )
	if($dir -eq "dl")
	{
		if($push){pushd $User.DOWNLOADS.this}
		else{cd $User.DOWNLOADS.this}
	}
	elseif($dir -eq "Col")
	{
		if($push){pushd $User.COLLEGE.this}
		else{cd $User.COLLEGE.this}
	}
	elseif($dir -eq "Rec")
	{
		if($push){pushd $User.RECYCLE.this}
		else{cd $User.RECYCLE.this}
	}
	elseif($dir -eq "CompE361")
	{
		if($push){pushd $User.COLLEGE._19_20.Fall_19.CompE_361.this}
		else {cd $User.COLLEGE._19_20.Fall_19.CompE_361.this}
	}
	elseif($dir -eq "CompE475")
	{
		if($push){pushd $User.COLLEGE._19_20.Fall_19.CompE_475.this}
		else{cd $User.COLLEGE._19_20.Fall_19.CompE_475.this}
	}
	elseif($dir -eq "CompE496A")
	{
		if($push){pushd $User.COLLEGE._19_20.Fall_19.CompE_496A.this}
		else{cd $User.COLLEGE._19_20.Fall_19.CompE_496A.this}
	}
	elseif($dir -eq "EE420")
	{
		if($push){pushd $User.COLLEGE._19_20.Fall_19.EE_420.this}
		else{cd $User.COLLEGE._19_20.Fall_19.EE_420.this}
	}
	elseif($dir -eq "EE450")
	{
		if($push){pushd $User.COLLEGE._19_20.Fall_19.EE_450.this}
		else{cd $User.COLLEGE._19_20.Fall_19.EE_450.this}
	}
	elseif($dir -eq "CompE565")
	{
		if($push){pushd $User.COLLEGE._19_20.Spring_20.CompE_565.this}
		else{cd $User.COLLEGE._19_20.Spring_20.CompE_565.this}
	}
	elseif($dir -eq "CompE560")
	{
		if($push){pushd $User.COLLEGE._19_20.Spring_20.CompE_560.this}
		else{cd $User.COLLEGE._19_20.Spring_20.CompE_560.this}
	}
	elseif($dir -eq "CompE496B")
	{
		if($push){pushd $User.COLLEGE._19_20.Spring_20.CompE_496B.this}
		else{cd $User.COLLEGE._19_20.Spring_20.CompE_496B.this}
	}
	elseif($dir -eq "EE600")
	{
		if($push){pushd $User.COLLEGE._19_20.Spring_20.EE_600.this}
		else{cd $User.COLLEGE._19_20.Spring_20.EE_600.this}
	}
	elseif($dir -eq "Main")
	{
		if($push){pushd $User.this}
		else{cd $User.this}
	}
	elseif($dir -eq "Sc")
	{
		if($push){pushd $User.SCRIPTS.this}
		else{cd $User.SCRIPTS.this}
	}
	elseif($dir -eq "Job")
	{
		if($push){pushd $User.JOB.this}
		else{cd $User.JOB.this}
	}
	elseif($dir -eq "One")
	{
		if($push){pushd $User.ONE}
		else{cd $User.ONE}
	}
	elseif($dir -eq "Pic")
	{
		if($push){pushd $User.PICTURES.this}
		else{cd $User.PICTURES.this}
	}
	elseif($dir -eq "SI")
	{
		if($push){pushd $User.SITES.this}
		else{cd $User.SITES.this}
	}
	elseif($dir -eq "code")
	{
		if($push){pushd $User.CODE.this}
		else{cd $User.CODE.this}
	}
	elseif($dir -eq "mus")
	{
		if($push){pushd $User.MUSIC.this}
		else{cd $User.MUSIC.this}
	}
	elseif($dir -eq "sr")
	{
		if($push){pushd $User.SOURCES.this}
		else{cd $User.SOURCES.this}
	}
	elseif($dir -eq "repo")
	{
		if($push){pushd $User.SOURCES.Repo.this}
		else{cd $User.SOURCES.Repo.this}
	}
	elseif($dir -eq "pers")
	{
		if($push){pushd $User.PERSONAL.this}
		else{cd $User.PERSONAL.this}
	}
	<#
	elseif($dir -eq "")
	{
		if($push){}
		else{}
	}
	#>
	else{ throw "Didn't 'goto' anywhere.  Reenter function with correct parameters." }
}
Set-Alias goto 'GO-TO'  