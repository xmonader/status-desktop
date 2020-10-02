import QtQuick 2.9
import QtQml.Models 2.3

DelegateModel {
    id: delegateModel

    property var lessThan: function(left, right) { return true; }
    property var filterAcceptsItem: function(item) { return true; }

    function update() {
        console.log("updating....")
        if (items.count > 0) {
            items.setGroups(0, items.count, "items");
        }

        console.log("filtering....")
        // Step 1: Filter items
        var visible = [];
        for (var i = 0; i < items.count; ++i) {
            var item = items.get(i);
            if (filterAcceptsItem(item.model)) {
                visible.push(item);
            }
        }

        console.log("sorting....")
        // Step 2: Sort the list of visible items
        visible.sort(function(a, b) {
            return lessThan(a.model, b.model) ? -1 : 1;
            // return a.index < b.index ? -1 : 1;
        });

        console.log("adding items....")
        // Step 3: Add all items to the visible group:
        for (i = 0; i < visible.length; ++i) {
            item = visible[i];
            item.inVisible = true;
            if (item.visibleIndex !== i) {
                visibleItems.move(item.visibleIndex, i, 1);
            }
        }
    }

    items.onChanged: update()
    onLessThanChanged: update()
    onFilterAcceptsItemChanged: update()

    groups: DelegateModelGroup {
        id: visibleItems

        name: "visible"
        includeByDefault: false
    }

    filterOnGroup: "visible"
}
/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
