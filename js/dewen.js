$(document).ready(function() {
    var t = $("h1.dewen");
    var p = $(".print");

    setPosition(t);
    $(window).resize(function() { setPosition(t); }); 
    t.mouseover(function(){setTextUpdate(t, 'RESUME')});
    t.mouseout(function(){setTextUpdate(t, 'DEWEN LI')});
    t.click(function(){openLink('/resume')});
    p.click(function(){window.print()});
});

function setPosition(elem)
{
    var eleWidth = elem.width();
    var eleHeight = elem.height();
    var winWidth = $(window).width();
    var winHeight = $(window).height();
    var visWidth = winWidth;
    var visHeight = winHeight;

    var topPos = ((visHeight/2)-(eleHeight/2)) + 'px';
    var leftPos = ((visWidth/2)-(eleWidth/2)) + 'px';

    elem.css('position', 'absolute')
    .css('top', topPos)
    .css('left', leftPos)
    ;
    elem.fadeIn(1000);
}

function setTextUpdate(elem, txt)
{
    elem.hide();
    elem.text(txt);
    elem.fadeIn(500);
}

function openLink(link)
{
    document.location.href=link;
}
