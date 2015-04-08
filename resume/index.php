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
    <link rel="icon" href="/favicon.ico">
    <link rel="shortcut icon" href="/favicon.ico" />
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
                <dl><dt>Home address:</dt><dd>Jericho, NY 11753</dd></dl>
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
                <span class="pop_message" rel="<?echo htmlspecialchars('{"id":"skilled-web-dev"}')?>">Skilled PHP web application developer</span> 
                 with professional experience designing and implementing web 
                 based applications. Extensive Software Development Life Cycle 
                 experience. Experienced in hands-on technical design, 
                 implementation, performance tuning and troubleshooting. 
                 Excellent analytic and problem solving skills. 
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
                    <li><span class="pop_message" rel="<?echo htmlspecialchars('{"id":"years-experience"}')?>">Over 10 years experience</span> in multi-tier architecture and full life-cycle software management and development</li>
                    <li>Experienced with developing <span class="pop_message" rel="<?echo htmlspecialchars('{"id":"enterprise"}')?>">enterprise e-Commerce projects</span> with <span class="pop_message" rel="<?echo htmlspecialchars('{"id":"scrum-experience"}')?>">Scrum/Agile methodology</li>
                    <li>Comprehensive knowledge of web applications and development technologies</li>
                    <li><span class="pop_message" rel="<?echo htmlspecialchars('{"id":"development"}')?>">Experienced user</span> on Linux or other Unix-like OS, familiar with shell commands and scripting.  </li>
                    <li>Databases: Relational database design. Working experience with MySQL, PostgreSQL. Training with Oracle. Knowledge of MSSQL, MongoDB</li>
                    <li>Languages: PHP (<a href="http://www.zend.com/en/services/certification/zend-certified-engineer-directory#cid=1&sid=NY&certtype_zf=on&certtype_php=on&certtype=ZFPHP&firstname=dewen&lastname=&company=&ClientCandidateID=" class="cert2" target="_blank">certified</a>), Java, Cold Fusion, ASP, JavaScript</li>
                    <li>Frameworks: Zend Framework (<a href="http://www.zend.com/en/services/certification/zend-certified-engineer-directory#cid=1&sid=NY&certtype_zf=on&certtype_php=on&certtype=ZFPHP&firstname=dewen&lastname=&company=&ClientCandidateID=" target="_blank" class="cert1">certified</a>), Symfony2, CodeIgniter</li>
                    <li>Testing: PHPUnit, SimpleTest and Selenium</li>
                    <li>Other skills: OOP Design Patterns, WEB2, Bash, Version Control (CVS, Git, SVN, PVCS), Test driven development, XML (RSS, XSD, XSLT, XPath), Eclipse IDE, Vim. XDebug, XHProf. Developing with Linux, Mac and Windows.</li>
                    <li>Front-end expertise: HTML5, CSS3, DOM, jQuery.</li>
                    <li>Open Source CMS/Shopping Cart: Drupal, Joomla, Zen Cart.</li>
                    <li>Server and Hosting: Acquia and Amazon EC2 experience.</li>
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
    <!-- {{{ Institute for Integrative Nutrition -->
    <div class="container">
        <div class="row">
            <div class="fourcol">
                <h4>01/2014 - present</h4>
            </div>
            <div class="eightcol last">
                <h3><a href="http://www.integrativenutrition.com/" target="_blank">Institute for Integrative Nutrition (education)</a></h3>
                <h4>Senior PHP/Drupal Developer</h4>
                <ul>

                  <li>As Drupal7 module developer on IINLC team, developed Learning Center system backend to deliver course content to students worldwide.</li>
                  <li>Build distributed system base on Drupal’s Services module with REST web APIs support, allowing front end Apps to consume data through web services.</li>
                  <li>Module integration with Memcached, Apache Solr, Akamai CDN and Zendesk etc.</li>
                  <li>Integration of Mandrill transactional mail API into Learning Center, sending web, email and push notifications to students.</li>
                  <li>Worked on different Drupal and customized cache solutions to improve the performance of application. </li>
                  <li>Created scheduled process that parses Apache and Drupal logs on the fly. Built a report system that monitoring site performance and data integrity, sending notifications to project owner by email.</li>
                  <li>Amazon EC2 and Acquia web host experience. Server LAMP environment setup, code deployment.</li>
                  <li>Development tools and methods used in work: Github (version control), Jenkins (deployment), New Relic (performance monitoring) , SimpleTest (unit and functional test), Acquia (Drupal hosting service), Drupal modules (services, webform, field_collection, features, elysia_cron, xhprof, etc). Scrum methodology</li>


                </ul>

            </div>
        </div>
    </div>
    <!-- }}} -->
    <!-- {{{ FashionGPS -->
    <div class="container">
        <div class="row">
            <div class="fourcol">
                <h4>04/2013 - 01/2014</h4>
            </div>
            <div class="eightcol last">
                <h3><a href="https://fashiongps.com/" target="_blank">FashionGPS (B2B software)</a></h3>
                <h4>Senior LAMP Developer</h4>
                <ul>
                    <li>Architected and implemented FashionGPS  <span  class="pop_message" rel="<?echo htmlspecialchars('{"id":"radar"}')?>">Radar</span>/
                    <span class="pop_message" rel="<?echo htmlspecialchars('{"id":"styles"}')?>">Styles</span> integration project used for fashion industry clients including Gucci, KCD, DKNY. Load Balanced high volume site built with lightweight PHP framework CodeIgniter2 using jQuery, Bootstrap, MySQL, implemented with template and object caching. </li>
                    <li>Newly developed B2B application Styles on top of Symfony2.2 to support clients managing their images.  Multiple images uploading with drag and drop with remote image server storage. Intensive development on JavaScript with jQuery.</li>
                    <li>Developed Styles Image Reporting module for client to review and export their product images. As part of large Symfony project, the Image Report module uses Composer to manage its dependencies, i.e PHPExcel, BundleTools, RadarSync, MVC model test with PHPUnit. </li>
                    <li>Developed and maintained social media presence and interact on Facebook, Twitter, and LinkedIn. Support direct comments and images posting on user’s social media sites using third party API.  Added LinkedIn and FaceBook login to Radar site with OAuth API.  </li>
                    <li>Created JSON API to export data for clients and Radar iPhone App. Project developed and tested with POSTMAN Client.  </li>
                    <li>Optimized performance on both application backend and frontend. Applying various methods to help reduce the server side response time including index adjustment, data caching, minify CSS and JavaScript files. Research and tuned jQuery for better processing time when dealing with DOM objects.</li>
                    <li>Using JIRA issue tracking system, projects managed and developed with Continuous Integration practice. Work in multi-developer environment of rapid commits to GitHub.</li>
                    <li>Supporting FashionGPS sales team to archive the goals. Helping junior developers on projects, provide instruction and code review.</li>
                    <li>Experience configuring LAMP, MAMP and WAMP servers as well as managing entire networks of LAMP machines. Worked closely together with the IT Network Engineer to assist and coordinate the expansion of our site, including servers, website and database.</li>
                </ul>

            </div>
        </div>
    </div>
    <!-- }}} -->
    <!-- {{{ yamaha music interactive -->
    <div class="container">
        <div class="row">
            <div class="fourcol">
                <h4>04/2007 - 04/2013</h4>
            </div>
            <div class="eightcol last">
                <h3>Yamaha Music Interactive (e-Commerce)</h3>
                <h4>PHP Web Application Developer</h4>
                <ul>
                <li>Worked on company's eCommerce site (<a href="http://www.yamahamusicsoft.com/" target="_blank">http://www.yamahamusicsoft.com/</a> with <span  class="pop_message" rel="<?echo htmlspecialchars('{"id":"yms-visits"}')?>">70K visits per month</span>, 500K registered users) on top of <span class="pop_message" rel="<?echo htmlspecialchars('{"id":"ymia-framework"}')?>">framework</span>. Responsible for developing and implementing technical designs for the website. </li>
                    <li>Sphinx based searching, MemCached, scheduler, event handling, Unit test</li>
                    <li>Worked on different projects from other Yamaha music service sites: 
                        <p><a href="http://notestarapp.com/en/tour" target="_blank">http://notestarapp.com/en/tour</a></p>
                        <p><a href="http://services.music.yamaha.com/radio/faq.html?instrument=Mark%20IV" target="_blank">http://services.music.yamaha.com/radio/</a></p>
                    </li>
                    <li>Responsible for version build and release with release plan and release notes.</li>
                    <li>Implemented MVC application with variety of design patterns, factory, singleton, observer, decorator and data mapper etc.</li>
                    <li>Backend development, includes CMS with ACL controls, reports, product management etc.</li>
                    <li>Frontend with <span  class="pop_message" rel="<?echo htmlspecialchars('{"id":"responsive-web-design"}')?>">responsive web design</span>, using HTML5 and CCS3.</li>
                    <li>Marketing support, build newsletter tools/template, export data from SFDC (Saleforce), etc.</li>
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
                <li>Architect, design and implement Company's information system. Providing services for employees to work across different countries.</li>
                <li>Developed company's website that manages 1500 apartments online and 140,000 visitors per month. Site release manager: http://nyhabitat.com </li>
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
