<?php

require_once('../init.php');

logging('GET_IMAGE');

switch(@$_GET['op'])
{
    case 'dewen_photo':
        $image = ROOT . '/images/dewen_'.rand(1,3).'.jpg';
        $imagedata = file_get_contents($image);
        break;
    default:
        $imagedata = '';
        
}

ob_start();
$length = strlen($imagedata);
header('Expires: Sat, 26 Jul 1997 05:00:00 GMT' ); 
header('Last-Modified: ' . gmdate( 'D, d M Y H:i:s' ) . ' GMT' ); 
header('Cache-Control: no-store, no-cache, must-revalidate' ); 
header('Cache-Control: post-check=0, pre-check=0', false ); 
header('Pragma: no-cache' ); 
header('Content-Length: '.$length);
header('Content-Type: image/jpeg');
echo $imagedata;
ob_end_flush();
