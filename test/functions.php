<?php
require(dirname(__FILE__) . '/setup.php');
require(dirname(__FILE__) . '/../init.php');

class DependencyFailureTest extends PHPUnit_Framework_TestCase
{
    public function testIsAllowed()
    {
        $_SERVER['REMOTE_ADDR'] = '150.70.123.123';
        $this->assertFalse(is_allowed());
    }

    /**
     *      * @depends testOne
     *           */
    public function testTwo()
    {
    }
}
