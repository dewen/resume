<?
include_check();

define('ROOT', dirname(__FILE__));

function js_css_ts($fn)
{
    $f = dirname(__FILE__) . '/' . $fn;
    return (file_exists($f)) ? md5($f) : '';
}

function include_check()
{
    $requestFilename = basename($_SERVER['SCRIPT_FILENAME']);
    $thisFilename = basename(__FILE__);

    if ($requestFilename == $thisFilename)
        die('This file has to be included in a front end script.');

}

function isFireFox()
{
    return (isset($_SERVER['HTTP_USER_AGENT']) && (stripos($_SERVER['HTTP_USER_AGENT'], 'firefox') !== false)) ? true : false;
}

function logging($code)
{
    $s = $code . " --- " . $_SERVER['REMOTE_ADDR'] . " --- " . date('Y-m-d H:i') .  " \n{{{\n" . var_export($_SERVER, TRUE) . "\n}}}\n\n";
    file_put_contents(ROOT . '/log/page.log', $s, FILE_APPEND);
}
