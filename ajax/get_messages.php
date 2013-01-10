<?php

switch(@$_GET['op'])
{
    case 'download-word':
        $s = 'Get a copy of this resume in Word format.';
        break;
    case 'skilled-web-dev':
        $s = 'Self evaluated skills: 
            <ul>
                <li>PHP (8/10)</li>
                <li>Linux (4/10)</li>
                <li>MySQL (6/10)</li>
                <li>OOP (6/10)</li>
            </ul>';
        break;
    case 'years-experience':
        $s = 'Worked with web programming since 2001, more professional train made in the past 6 years.';
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
                <li>CVS as version control</li>
            </ul>';
        break;
}

echo $s;
