sub Init()
    ' Loading video instance
    m.video=m.top.FindNode("videoScreen")
    m.video.loop=true
    m.video.getChild(1).visible=false ' To hide loading bar
    m.video.contentIsPlayList=false
    
    ' Loading labels instances
    m.title=m.top.FindNode("titleLabel")
    m.place=m.top.FindNode("placeLabel")
    m.description=m.top.FindNode("descriptionLabel")
    m.date=m.top.FindNode("dateLabel")
    
    m.top.ObserveField("itemFocused","OnItemFocusedChanged")
    m.top.ObserveField("visible", "OnVisibleChange")
    m.video.ObserveField("state", "AvoidErrorState")
end sub

sub OnItemFocusedChanged()
    
    m.title.text=m.top.content.GetChild(0).getChild(m.top.itemFocused).title
    m.place.text=m.top.content.GetChild(0).getChild(m.top.itemFocused).place
    m.description.text=m.top.content.GetChild(0).getChild(m.top.itemFocused).description
    m.date.text=m.top.content.GetChild(0).getChild(m.top.itemFocused).date
    
    m.video.content=m.top.content.GetChild(0).getChild(m.top.itemFocused).Clone(true)
    
    m.video.control="play"
end sub

sub OnVisibleChange()
    if m.top.visible = true
        ' m.video.SetFocus(true)
    end if
end sub

sub AvoidErrorState()
    if m.video.state="error"
        m.video.control="play"
        m.video.visible=false
    else if m.video.state="buffering"
        m.video.visible=false
    else if m.video.state="playing"
        m.video.visible=true
    end if
end sub

function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        currentItem = m.top.itemFocused ' get actual focused item
        ' handle button keypress
        if key = "left" and currentItem>0
            currentItem--
            result = true
        else if key = "right" and currentItem<m.top.content.GetChild(0).getChildCount()-1
            currentItem++
            result = true
        else if key = "OK"
            AvoidErrorState()
            result = true
        else if key = "back"
            m.video.control="stop"
            m.top.removeChild(m.video)
            m.video=invalid
        end if
        if m.video <> invalid
            m.video.content=invalid
            m.top.itemFocused = currentItem
        end if
    end if
    return result
end function