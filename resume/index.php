<?php
require_once('../init.php');
?><!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Dewen Li Resume | LAMP PHP developer</title>
    <meta name="keywords" content="dewen li resume lamp php developer css3 html5 jquery php5 linux mysql postgres version control software cvs git svn">
    <meta name="description" content="Middle level PHP developer with strong experience developing on the LAMP stack. ">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- 1140px Grid styles for IE -->
    <!--[if lte IE 9]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen" /><![endif]-->
    <!-- The 1140px Grid - http://cssgrid.net/ -->
    <link rel="stylesheet" href="/css/1140.css" type="text/css"/>
    <link rel="stylesheet" href="/css/screen.css" type="text/css" media="screen"/>
    <link rel="stylesheet" href="/css/print.css" type="text/css" media="print"/>
    <link href="/css/jquery-bubble-popup-v3.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="/css/fortawesome/css/font-awesome.css">
    <!--css3-mediaqueries-js - http://code.google.com/p/css3-mediaqueries-js/ - Enables media queries in some unsupported browsers-->
    <script type="text/javascript" src="/js/css3-mediaqueries.js"></script>
    <script src="/js/jquery-1.8.3.min.js"></script>
    <script src="/js/resume.js?<?=js_css_ts('/js/resume.js')?>"></script>
    <script src="/js/scripts/jquery-bubble-popup-v3.min.js?<?=js_css_ts('/js/scripts/jquery-bubble-popup-v3.min.js')?>" type="text/javascript"></script>
    <style type="text/css"></style>
    <link rel="prefetch" href="/resume/introduction.html">
    <link href='http://fonts.googleapis.com/css?family=Julius+Sans+One' rel='stylesheet' type='text/css'>
</head>
<body class="resume">
    <!-- {{{ header -->
    <div class="container header">
        <div class="row">
            <div class="sixcol">
                <h1><a href="http://dewen.li/" class="dewen">Dewen Li</a></h1>
            </div>
            <div class="sixcol last contact">
                <dl><dt>E-Mail:</dt><dd>dewen.sinocrest@gmail.com</dd></dl>
                <dl><dt>Cell phone:</dt><dd>917-640-3289</dd></dl>
                <dl><dt>Home address:</dt><dd>Great Neck, NY 11021</dd></dl>
            </div>
        </div>
    </div>
    <!-- }}} -->
    <!-- {{{ summary -->
    <div class="container">
        <div class="row">
            <div class="fourcol">
                <h3>SUMMARY</h3>
            </div>
            <div class="eightcol last">
                <span class="pop_message" rel="<?echo htmlspecialchars('{"id":"skilled-web-dev"}')?>">Skilled PHP web application developer</span>. 
                Experienced in hands-on 
                technical design and implementation, performance tuning and 
                troubleshooting.  Extensive experience building interactive, 
                database driven web based applications/services. 
            </div>
        </div>
    </div>
    <!-- }}} -->
    <!-- {{{ skills -->
    <div class="container">
        <div class="row">
            <div class="fourcol">
                <h3>SKILLS</h3>
            </div>
            <div class="eightcol last">
                <ul>
                    <li><span class="pop_message" rel="<?echo htmlspecialchars('{"id":"years-experience"}')?>">6 years experience</span> in multi-tier architecture and full life-cycle software management and development</li>
                    <li>Experienced with developing <span class="pop_message" rel="<?echo htmlspecialchars('{"id":"enterprise"}')?>">enterprise e-Commerce projects</span> with <span class="pop_message" rel="<?echo htmlspecialchars('{"id":"scrum-experience"}')?>">Scrum/Agile methodology</li>
                    <li>Comprehensive knowledge of web applications and development technologies</li>
                    <li><span class="pop_message" rel="<?echo htmlspecialchars('{"id":"development"}')?>">Experienced user</span> on Linux or other Unix-like OS, familiar with shell commands and scripting.  </li>
                    <li>Relational database design. Working experience with MySQL, PostgreSQL. Training with Oracle.</li>
                    <li>Working knowledge of site security with secure programming practices.</li>
                    <li>PHP, JAVA, Cold Fusion</li>
                    <li>Other skills: OOP Design Patterns, WEB2, Bash, Version Control (CVS, SVN, GIT), Test driven development, XML (RSS, XSD, XSLT, XPATH), Eclipse IDE, Vim. </li>
                </ul>
            </div>
        </div>
    </div>
    <!-- }}} skills -->
    <!-- {{{ professional experience -->
    <div class="container">
        <div class="row">
            <div class="twelvecol last">
                <h3>PROFESSIONAL EXPERIENCE</h3>
            </div>
        </div>
    </div>
    <!-- }}} -->
    <!-- {{{ yamaha music interactive -->
    <div class="container">
        <div class="row">
            <div class="fourcol">
                <h4>04/2007 - present</h4>
            </div>
            <div class="eightcol last">
                <h3>Yamaha Music Interactive (e-Commerce)</h3>
                <h4>PHP Web Application Developer</h4>
                <ul>
                    <li>Developing the company's primary e-commerce site (http://www.yamahamusicsoft.com/ with 70K visits per month, 500K registered users) on top of framework. Responsible for developing and implementing technical designs for the website. </li>
                    <li>Worked on different projects from other Yamaha music service sites: 
                        <p>http://services.music.yamaha.com/  Online Services, PHP5, PostgresSQL</p>
                    </li>
                    <li>Features include Sphinx based searching, MemCached based object caching, template caching, event handling, Unit test by modules</li>
                    <li>Responsible for version build and release with release plan and release notes.</li>
                    <li>Implemented MVC application with variety of design patterns, factory, singleton, observer, decorator and data mapper etc.</li>
                    <li>Designed and implemented the "Data Access Object" in integration tier for encapsulation of Database access and better DBMS portability</li>
                    <li>Site backend implementations, includes CMS with ACL controls, reports, product management etc.</li>
                </ul>
            </div>
        </div>
    </div>
    <!-- }}} -->
    <!-- {{{ new york habitat inc. -->
    <div class="container">
        <div class="row">
            <div class="fourcol">
                <h4>04/2002 – 04/2007</h4>
            </div>
            <div class="eightcol last">
                <h3>New York Habitat Inc. (Real Estate)</h3>
                <h4>Internet Specialist/Application developer</h4>
                <ul>
                <li>Architect, design and implement Company’s information system. Providing services for employees to work across different countries.</li>
                <li>Developed company’s website that manages 1500 apartments online and 140,000 visitors per month. Site release manager: http://nyhabitat.com </li>
                <li>Analysis and design new Request Process System with HTML template. Maintaining the 100,000 registered client databases.</li>
                <li>Designed and developed Intranet Apartment Management System according to the business specification. Handles about 12,000 apartments from different cities. Services include searching, mapping, photos, web synchronizing, etc.  </li>
                <li>SEO project.</li>
                </ul>
            </div>
        </div>
    </div>
    <!-- }}} -->
    <!-- {{{  bigfoot communications, llc -->
    <div class="container">
        <div class="row">
            <div class="fourcol">
                <h4>05/2001 - 04/2002</h4>
            </div>
            <div class="eightcol last">
                <h3>Bigfoot Communications, LLC</h3>
                <h4>Junior ASP developer</h4>
                <ul>
                    <li>Use ASP and MS SQL Sever 7. Create SOAP module. Create database schema. Write stored procedures, create system logs.</li>
                    <li>Service Bill Project: Create DLLs connection to CyberCash register</li>
                    <li>New Member Join Project: ISAPI application. Modify DLLs for new members join.</li>
                    <li>Customer Service Project: Customer management system. Create stored procedures for scheduled tasks and statistic. Add more functionality to customer service support.</li>
                </ul>
            </div>
        </div>
    </div>
    <!-- }}} -->
    <!-- {{{ education -->
    <div class="container">
        <div class="row">
            <div class="fourcol">
                <h3>EDUCATION</h3>
            </div>
            <div class="eightcol last">
                <ul>
                    <li>05/2001     M.S. in Computer Info. System   BERNARD M. BARUCH COLLEGE, CUNY       </li>
                    <li>06/1999 M.S. in Petroleum Engineering       UNIVERSITY OF ALASKA</li>
                    <li>06/1993 B.A. in Mechanical Engineering  PETROLEUM UNIVERSITY, DONGYING</li>
                </ul>
            </div>
        </div>
    </div>
    <!-- }}} -->
    <!-- {{{ references -->
    <div class="container">
        <div class="row">
            <div class="fourcol">
                <h3>REFERENCES</h3>
            </div>
            <div class="eightcol last">
                <em>Available Upon Request</em>
            </div>
        </div>
    </div>
    <!-- }}} -->
    <!-- {{{ resources -->
    <div class="container resources">
        <div class="row">
            <div class="fourcol">
                <h3 class="download_word">RESOURCES</h3>
            </div>
            <div class="eightcol last">
                <ul>
                    <li><a href="https://www.facebook.com/dewen.li.526"><i class="icon-facebook-sign"></i></a>: Facebook </li>
                    <li><a href="http://www.linkedin.com/pub/dewen-li/23/69/311"><i class="icon-linkedin-sign"></i></a>: Linked In</li>
                    <li><a href="http://sinocrest.com/dewen.li/wiki/">WIKI</a>: Some handy tips collected for development</li>
                    <?if (isFireFox()):?>
                    <li><a href="/docs/resume.pdf">PDF</a>: Get a PDF version of resume</li>
                    <?else:?>
                    <li><a href="javascript: void(0);" class="print"><i class="icon-print"></i></a> Print this resume</li>
                    <?endif?>
                </ul>
            </div>
        </div>
    </div>
    <!-- }}} -->

</body>
</html>
<script type="text/javascript">

  var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-37382610-1']);
      _gaq.push(['_trackPageview']);

  (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
              ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
              var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
                })();

</script>
