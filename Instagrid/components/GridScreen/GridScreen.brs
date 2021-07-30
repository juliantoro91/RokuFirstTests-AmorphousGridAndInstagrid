sub Init()
    m.labels = m.top.FindNode("labels")
    m.title = m.top.FindNode("titleLabel")
    ' Node to Store posters
    m.posters = m.top.FindNode("posters")
    ' To initialize video thumbnail
    m.videoThumbnail=CreateObject("roSGNode","Video")
    m.videoThumbnail.addFields({prevFocusedItem : 1})
    m.videoThumbnail.contentIsPlayList=false
    m.videoThumbnail.control="pause"
    m.videoThumbnail.ObserveField("state", "MonitoringThumbnailStatus")
    ' To highlight focused items
    m.focus=CreateObject("roSGNode","Rectangle")
    m.focus.color="0x32A7AFFF"
    m.focus.opacity=0.3
    ' To initialize focused items
    m.top.itemFocused=invalid
    ' To display content and screen
    m.top.ObserveField("visible", "onVisibleChange")
    m.top.ObserveField("content", "PopulateGridScreen")
    
    ' variables to control posters aspect
    m.itemsInRow=4 ' grid aspect
    m.numberOfRows=2
    m.itemWidth=250 ' posters dimentions
    m.itemHeight=250
    m.newX=141 ' default X and Y values
    m.newY=151
    
    m.loop=0 ' To control loop playback
    m.maxloop=3
    
end sub

sub OnVisibleChange() ' invoked when GridScreen change visibility
    if m.top.visible = true
        m.posters.SetFocus(true) ' set focus to posters if GridScreen visible
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
            m.posters.getChild(i).getChild(0).width=m.itemWidth
            m.posters.getChild(i).getChild(0).height=m.itemHeight
            m.posters.getChild(i).getChild(0).loadWidth=m.itemWidth
            m.posters.getChild(i).getChild(0).loadHeight=m.itemHeight
            position=GetPosition(i, m.itemsInRow)
            m.posters.getChild(i).getChild(0).addFields({position : position})
            m.posters.getChild(i).getChild(0).translation=[m.itemWidth*position[1]+m.newX, m.itemHeight*position[0]+m.newY]
            m.posters.GetChild(i).GetChild(0).blendcolor="0xBEBEBEFF"
        else
            EXIT while
        end if
        i++
    end while
    m.top.ObserveField("itemFocused", "OnItemFocusedChanged")
    m.top.itemFocused=0
end sub

sub OnItemFocusedChanged ()
    ' Updating title of focused item
    m.title.text=m.top.content.GetChild(0).getChild(m.top.itemFocused).title
    
    ' focus setup
    m.focus.width=m.posters.getChild(m.top.itemFocused).getChild(0).width
    m.focus.height=m.posters.getChild(m.top.itemFocused).getChild(0).height
    m.focus.translation=m.posters.getChild(m.top.itemFocused).getChild(0).translation
    
    ' videoThumbnail setup
    m.videoThumbnail.content=m.top.content.GetChild(0).getChild(m.top.itemFocused).Clone(true)    
    m.videoThumbnail.width=m.focus.width
    m.videoThumbnail.height=m.focus.height
    m.videoThumbnail.translation=m.posters.getChild(m.top.itemFocused).getChild(0).translation
    m.videoThumbnail.content.url=m.videoThumbnail.content.turl
    m.videoThumbnail.visible=false
    m.videoThumbnail.getChild(1).visible=false ' To hide loading bar
    
    if m.videoThumbnail.prevFocuseditem <> m.focusedItem
        if m.videoThumbnail.state="none"
            m.videoThumbnail.control="play"
            ShowVideoThumbnail()
        end if
    end if
end sub

sub MonitoringThumbnailStatus()
    if m.top.visible = true
        if m.loop<m.maxloop
            if m.videoThumbnail.state="buffering"
                m.videoThumbnail.GetChild(0).color="0xFFFFFFFF"
                m.loop++
            else if m.videoThumbnail.state="playing"
                m.videoThumbnail.visible="true"
            else if m.videoThumbnail.state="finished"
                m.videoThumbnail.control="play"
                m.videoThumbnail.visible=false
            end if
        else
            m.top.RemoveChild(m.videoThumbnail)
            m.videoThumbnail.prevFocusedItem=m.focusedItem
            m.videoThumbnail.state="none"
            m.loop=0
        end if
    end if
    'STOP
end sub

sub ShowVideoThumbnail()
    m.top.AppendChild(m.videoThumbnail)
    m.top.AppendChild(m.focus)
end sub

function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    ' STOP
    if press
        currentItem = m.posters.getChild(m.top.itemFocused).GetChild(0).position ' get position of actual focused item
        ' Setup video thumbnail
        if key="left" or key="right" or key="up" or key="down"
            m.videoThumbnail.prevFocuseditem = DecodePosition(currentItem, m.itemsInRow)
            m.videoThumbnail.state="none"
            m.videoThumbnail.content=invalid
            m.top.RemoveChild(m.videoThumbnail)
            m.loop=0
        end if
        ' handle button keypress
        if key = "left" and currentItem[1]>0
            currentItem[1]--
            result = true
        else if key = "right" and currentItem[1]<m.itemsInRow-1
            currentItem[1]++
            result = true
        else if key = "up" and currentItem[0]>0
            currentItem[0]--
            result=true
        else if key = "down" and currentItem[0]<m.numberOfRows-1
            currentItem[0]++
            result=true
        else if key="OK"
            m.top.selectedItem=DecodePosition(currentItem, m.itemsInRow)
        end if
        m.top.itemFocused = DecodePosition(currentItem, m.itemsInRow)
    end if
    return result
end function