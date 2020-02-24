$i = 'PROD_HR_Feed_Key_20200223.csv';
$i = $i.Replace('PROD_HR_Feed_Key_', ''); $i = $i.Replace('.csv', '');
$i = [datetime]::parseexact($i, 'yyyyMMdd', $null);