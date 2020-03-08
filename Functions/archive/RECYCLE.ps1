Param($item)
	if(!(Test-Path B:\RECYCLE))
	{
		mkdir B:\RECYCLE
	}

	mv $item B:\RECYCLE