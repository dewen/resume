<?php

require_once('../init.php');

logging('GET_IMAGE');

$type = $image = '';
switch(@$_GET['op'])
{
    case 'dewen_photo':
        $image = ROOT . '/images/dewen_'.rand(1,3).'.jpg';
        $type = 'Content-Type: image/jpeg';
        break;
    case 'cert1':
        $image = ROOT . '/images/cert1.png';
        $type = 'Content-Type: image/png';
        break;
    case 'cert2':
        $image = ROOT . '/images/cert2.png';
        $type = 'Content-Type: image/png';
        break;
}
$imagedata = ($image) ? file_get_contents($image) : '';

ob_start();
$length = strlen($imagedata);
header('Expires: Sat, 26 Jul 1997 05:00:00 GMT' ); 
header('Last-Modified: ' . gmdate( 'D, d M Y H:i:s' ) . ' GMT' ); 
header('Cache-Control: no-store, no-cache, must-revalidate' ); 
header('Cache-Control: post-check=0, pre-check=0', false ); 
header('Pragma: no-cache' ); 
header('Content-Length: '.$length);
header($type);
echo $imagedata;
ob_end_flush();
