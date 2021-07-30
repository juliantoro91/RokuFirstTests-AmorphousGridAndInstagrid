sub Init()
    m.labels = m.top.FindNode("fieldLabels")
    m.title = m.top.FindNode("titleLabel")
    m.artist = m.top.FindNode("artistLabel")
    m.date = m.top.findNode("releaseLabel")
    ' Node to Store posters
    m.posters = m.top.FindNode("posters")
    m.top.ObserveField("visible", "onVisibleChange")
    ' To highlight focused items
    m.focus=m.top.findNode("focus")
    m.top.itemFocused=invalid
    m.top.ObserveField("content", "PopulateGridScreen")
end sub

sub OnVisibleChange() ' invoked when GridScreen change visibility
    if m.top.visible = true
        m.posters.SetFocus(true) ' set focus to rowList if GridScreen visible
    end if
end sub

sub loadingPosters(id as Integer)
    rectangle=CreateObject("roSGNode","Rectangle")
    rectangle.color="0xFFFFFF00"
    poster=CreateObject("roSGNode", "Poster")
    poster.id="element"+StrI(id)
    poster.loadDisplayMode="scaleToFit"
    rectangle.appendChild(poster)
    m.posters.appendChild(rectangle)
end sub

sub PopulateGridScreen()
    i=0
    while(true)
        if m.top.content.GetChild(0).getChild(i) <> invalid
            loadingPosters(i+1)
            m.posters.getChild(i).getChild(0).uri=m.top.content.GetChild(0).getChild(i).hdPosterUrl
            m.posters.getChild(i).getChild(0).width=m.top.content.GetChild(0).getChild(i).width
            m.posters.getChild(i).getChild(0).height=m.top.content.GetChild(0).getChild(i).height
            m.posters.getChild(i).getChild(0).loadWidth=m.top.content.GetChild(0).getChild(i).width
            m.posters.getChild(i).getChild(0).loadHeight=m.top.content.GetChild(0).getChild(i).height
            m.posters.getChild(i).getChild(0).translation=[m.top.content.GetChild(0).getChild(i).x, m.top.content.GetChild(0).getChild(i).y]
        else
            EXIT while
        end if
        i++
    end while
    m.top.ObserveField("itemFocused", "OnItemFocusedChanged")
    m.top.itemFocused=0
end sub

sub OnItemFocusedChanged ()
    m.title.text=m.top.content.GetChild(0).getChild(m.top.itemFocused).title
    m.artist.text=m.top.content.GetChild(0).getChild(m.top.itemFocused).artist
    m.date.text=m.top.content.GetChild(0).getChild(m.top.itemFocused).date
    m.focus.width=m.posters.getChild(m.top.itemFocused).getChild(0).width
    m.focus.height=m.posters.getChild(m.top.itemFocused).getChild(0).height
    m.focus.translation=m.posters.getChild(m.top.itemFocused).getChild(0).translation
    
end sub

function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        currentItem = m.top.itemFocused ' position of currently focused item
        ' handle button keypress
        if key = "left" and m.top.content.GetChild(0).getChild(currentItem).left<>"invalid"
            m.top.itemFocused = val(m.top.content.GetChild(0).getChild(currentItem).left)-1
            result = true
        else if key = "right" and m.top.content.GetChild(0).getChild(currentItem).right<>"invalid"
            m.top.itemFocused = val(m.top.content.GetChild(0).getChild(currentItem).right)-1
            result = true
        else if key = "up" and m.top.content.GetChild(0).getChild(currentItem).up<>"invalid"
            m.top.itemFocused = val(m.top.content.GetChild(0).getChild(currentItem).up)-1
            result = true
        else if key = "down" and m.top.content.GetChild(0).getChild(currentItem).down<>"invalid"
            m.top.itemFocused = val(m.top.content.GetChild(0).getChild(currentItem).down)-1
            result = true
        end if
    end if
    return result
end function