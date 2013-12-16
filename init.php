<?php
define('ROOT', dirname(__FILE__));

include_check();
security_check();

function js_css_ts($fn)
{
    $f = dirname(__FILE__) . '/' . $fn;
    return (file_exists($f)) ? md5($f) : '';
}

function is_allowed($ip)
{
    $cf = ROOT . '/conf/blocked.php';
    if (file_exists($cf))
    {
        $blocked = include($cf);
        foreach($blocked as $_)
            if (strpos($ip, $_) === 0) return false;
    }
    return true;
}

function include_check()
{
    $requestFilename = basename($_SERVER['SCRIPT_FILENAME']);
    $thisFilename = basename(__FILE__);

    if ($requestFilename == $thisFilename)
        die('This file has to be included in a front end script.');

}

function security_check()
{
    if (!is_cli() && !is_allowed($_SERVER['REMOTE_ADDR']))
    {
        header("HTTP/1.0 404 Not Found");
        echo file_get_contents(ROOT . '/404.html');
        die();
    }
}
function isFireFox()
{
    return (isset($_SERVER['HTTP_USER_AGENT']) && (stripos($_SERVER['HTTP_USER_AGENT'], 'firefox') !== false)) ? true : false;
}

function logging($code)
{
    if (is_cli()) return;

    $s = $code . " --- " . $_SERVER['REMOTE_ADDR'] . " --- " . date('Y-m-d H:i') .  " \n{{{\n" . var_export($_SERVER, TRUE) . "\n}}}\n\n";
    file_put_contents(ROOT . '/log/page.log', $s, FILE_APPEND);
}

function is_cli()
{
    return (php_sapi_name() === 'cli') ? true : false;
}
