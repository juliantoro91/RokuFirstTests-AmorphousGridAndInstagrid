sub ShowGridScreen()
    m.GridScreen = CreateObject("roSGNode", "GridScreen")
    m.GridScreen.ObserveField("selectedItem", "OnGridScreenItemSelected")
    ShowScreen(m.GridScreen) ' show GridScreen
end sub

sub OnGridScreenItemSelected(event as Object)
    grid = event.GetRoSGNode()
    ' extract the row and column indexes of the item the user selected
    m.selectedItem = event.GetData()
    content = grid.content.Clone(true)
    ShowDetailsScreen(content, m.selectedItem)
end sub