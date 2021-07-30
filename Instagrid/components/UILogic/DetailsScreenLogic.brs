sub ShowDetailsScreen(content as Object, selectedItem as integer)
    m.detailsScreen=CreateObject("RoSGNode","DetailsScreen")
    m.detailsScreen.content=content
    m.detailsScreen.itemFocused=selectedItem
    ShowScreen(m.detailsScreen)
end sub