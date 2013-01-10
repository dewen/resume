/**
 *  Dewen Li 2013 - Resume support
 *
 *  Copyright (C) 2013 Dewen Li
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
$(document).ready(function() {
    var t = $("h1 a.dewen");
    var p = $(".print");
    var b = $('<div class="bottom_bar"></div>');

    t.mouseover(function(){showImage(t, 'dewen_photo')});
    t.mouseout(function(){showImage(t, false)});
    b.appendTo($('body')).delay(2000).fadeIn(400);

    // pop bubble messages
    var popOptions = {
        alwaysVisible: true,
        position: 'bottom',
        align: 'left',
        tail: {align: 'top', hidden: true},
        innerHtmlStyle: {
            color:'#FFFFFF', 
            'text-align':'left',
            width: '250px'
        },
        themeName: 'all-azure',
        themePath: '/js/jquerybubblepopup-themes/',
        themeMargins: {total: '10px',difference: '10px'},
        mouseOut: 'show'
    };

    $.ajax('/ajax/controls.php', {
        dataType:'html', 
        success: function(data){
            b.html(data);
        }
    });

    var msgs = [];
    $('.pop_message').live('mouseover', function(){
        params = jQuery.parseJSON($(this).attr('rel'));
        if (!params.id)
            return;

        if (msgs[params.id] == undefined)
            $.ajax('/ajax/get_messages.php?op=' + params.id, {dataType:'html', async:false, success: function(data){msgs[params.id] = txt = data}});
        else
            txt = msgs[params.id];

        if (txt)
        {
            $(this).CreateBubblePopup();
            popOptions['innerHtml'] = txt;
            $(this).SetBubblePopupOptions(popOptions);
        }
    });
    $('.pop_message').live('mouseout', function(){
        $(this).RemoveBubblePopup();
    });
});


function showImage(elem, request)
{
    var imgHolder = $(".loaded_img", elem);
    var pos = elem.position();

    if (!request) {
        imgHolder.remove();
        return;
    }

    if (!imgHolder.length) 
    {
        imgHolder = $('<img class="loaded_img" style="display: none;" src="/util/get_image.php?op=' + request + '">');
        elem.append(imgHolder);
    }
    imgHolder.ready(function(){
        imgHolder.css({'background': 'white','border': '1px solid #ccc','position':'absolute','top': pos.top + elem.height(), 'box-shadow': '6px 6px 6px #ccc', 'display':'block'});
    });
}
