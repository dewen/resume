<?php

switch(@$_GET['op'])
{
    case 'radar':
        $s = 'GPS Radar is a public-facing, invite-only web and iPhone app, for whose selective community consists of some of the world\'s editors, buyers and influencers. This community uses the app to manage their event invitations, RSVPs, and access content from the show';
        break;
    case 'styles':
        $s = 'GPS Styles is a media hosting and distribution channel';
        break;
    case 'download-word':
        $s = 'Get a copy of this resume in Word format.';
        break;
    case 'skilled-web-dev':
        $s = 'Self evaluated skills: 
            <ul>
                <li>PHP (8/10) -  Certified PHP developer. More working experience with PHP5. Preference building applications on top of frameworks.</li>
                <li>Linux (5/10) - Development work on Linux environment, good understanding of UNIX like system.</li>
                <li>MySQL/Postgres (6/10) - familar with SQL, EAV modeling.</li>
                <li>OOP (7/10) - Familiar with concept and design patterns</li>
                <li>Version control (8/10) -  Heavy use of version control with CVS, GIT, familiar with branching, merging and building processes. Worked with SVN for office document management.</li>
            </ul>';
        break;
    case 'years-experience':
        $s = 'Worked on web programming since 2001';
        break;
    case 'scrum-experience':
        $s = 'Most projects developed using agile (scrum), normally 2 - 4 sprints. The tools used include JIRA, Flowdock, Mantis and Google Docs.';
        break;
    case 'enterprise':
        $s = 'Dealing with
            <ul>
                <li>large volume of visits</li>
                <li>multi-language system</li>
                <li>performance issues</li>
            </ul>';
        break;
    case 'development':
        $s = 'Development environment and tools
            <ul>
                <li>CentOS release 5</li>
                <li>vim 7.0 - use vi on Linux for coding.</li>
                <li>Familiar with commands like <em>find, wget, rsync etc</em></li>
            </ul>';
        break;
    case 'ymia-framework':
        $s = 'Zend Framework alike system with modules,
            <ul>
                <li>MVC</li>
                <li>Template Engine</li>
                <li>Memcached</li>
                <li>Sphinx - Full Text Search</li>
                <li>Localization</li>
                <li>OFS - Object File System</li>
                <li>EAV</li>
            </ul>';
        break;
    case 'responsive-web-design':
        $s = '
            <ul>
                <li>Implemented with CSS Grid</li>
                <li>Media Query</li>
            </ul>';
        break;
    case 'dev-tools':
        $s = '
            <ul>
                <li>Araxis Merge</li>
                <li>Eclipse PDT</li> 
                <li>PUTTY</li> 
                <li>Flowdock</li> 
                <li>JIRA</li> 
                <li>Mantis - bug tracking</li> 
            </ul>';
        break;
    case 'yms-visits':
        $s = '
            <ul>
                <li>Around 75K people visits monthly</li>
                <li>2.5K ~ 3.5K unique visits daily with 5K page views</li> 
                <li>Bounce rate 35%</li>
                <li>45% US visits</li>
            </ul>';
        break;
}

echo $s;
